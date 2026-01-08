local config = {
	remote_host = "princemedici",
	local_host = "127.0.0.1",
	port = "8012",
	ssh_host = "princemedici@princemedici",
	server_args = {
		local_context = "4096",
		remote_context = "65536",
		cache_type = "q8_0",
		idle_timeout = "7200",
	},
}

local models = {
	local_models = {
		{ name = "Qwen2.5-Coder-1.5B", path = vim.fn.expand("~/models/qwen2.5-coder-1.5b-q8_0.gguf") },
		{
			name = "Qwen3-Coder-25B-A3B",
			path = vim.fn.expand("~/models/cerebras_Qwen3-Coder-REAP-25B-A3B-Q4_K_M.gguf"),
		},
	},
	remote_models = {
		{ name = "Qwen2.5-Coder-3B", path = "~/models/qwen2.5-coder-3b-q8_0.gguf" },
		{ name = "Qwen3-Coder-25B-A3B", path = "~/models/cerebras_Qwen3-Coder-REAP-25B-A3B-Q4_K_M.gguf" },
	},
}

local state = {
	current_server = nil,
	current_model = nil,
}

local function get_url(host, path)
	return string.format("http://%s:%s%s", host, config.port, path)
end

local function check_server(host, callback)
	local done = false
	vim.fn.jobstart({
		"curl",
		"-s",
		"-o",
		"/dev/null",
		"-w",
		"%{http_code}",
		"--connect-timeout",
		"1",
		get_url(host, "/health"),
	}, {
		stdout_buffered = true,
		on_stdout = function(_, data)
			if done then
				return
			end
			done = true
			callback(data and data[1] == "200")
		end,
		on_exit = function(_, code)
			if done then
				return
			end
			done = true
			callback(false)
		end,
	})
end

local function find_active_server(callback)
	check_server(config.remote_host, function(remote_ok)
		if remote_ok then
			callback(config.remote_host, "remote")
		else
			check_server(config.local_host, function(local_ok)
				callback(local_ok and config.local_host or nil, local_ok and "local" or nil)
			end)
		end
	end)
end

local function set_endpoint(host)
	local ok, minuet = pcall(require, "minuet")
	if ok and minuet.config then
		minuet.config.provider_options.openai_fim_compatible.end_point = get_url(host, "/v1/completions")
	end
end

local function wait_for_server(host, callback, attempts)
	attempts = attempts or 0
	if attempts > 30 then
		vim.notify("Server failed to start", vim.log.levels.ERROR)
		return
	end
	check_server(host, function(ok)
		if ok then
			callback()
		else
			vim.defer_fn(function()
				wait_for_server(host, callback, attempts + 1)
			end, 1000)
		end
	end)
end

local function start_server(location, model)
	local args = config.server_args
	local host = location == "local" and config.local_host or config.remote_host

	state.current_server = location
	state.current_model = model.name
	vim.notify("Starting " .. location .. ": " .. model.name .. " (loading...)", vim.log.levels.INFO)

	if location == "local" then
		vim.fn.jobstart({
			"llama-server",
			"-m",
			model.path,
			"--port",
			config.port,
			"-ngl",
			"99",
			"--flash-attn",
			"on",
			"-c",
			args.local_context,
			"--cache-type-k",
			args.cache_type,
			"--cache-type-v",
			args.cache_type,
			"--sleep-idle-seconds",
			args.idle_timeout,
		}, { detach = true })
	else
		local cmd = string.format(
			"ssh -o ConnectTimeout=2 %s 'nohup ~/llama.cpp/build/bin/llama-server -m %s --host 0.0.0.0 --port %s -ngl 99 --flash-attn on -c %s --cache-type-k %s --cache-type-v %s > /tmp/llama-server.log 2>&1 &'",
			config.ssh_host,
			model.path,
			config.port,
			args.remote_context,
			args.cache_type,
			args.cache_type
		)
		vim.fn.jobstart(cmd, { detach = true })
	end

	wait_for_server(host, function()
		set_endpoint(host)
		vim.notify(model.name .. " ready!", vim.log.levels.INFO)
	end)
end

local function stop_all()
	vim.fn.jobstart({ "pkill", "-f", "llama-server" }, { detach = true })
	vim.fn.jobstart({
		"ssh",
		"-o",
		"ConnectTimeout=2",
		config.ssh_host,
		"pkill -f llama-server",
	}, { detach = true })
	state.current_server = nil
	state.current_model = nil
	vim.notify("Stopping llama servers...", vim.log.levels.INFO)
end

local function show_status()
	find_active_server(function(host, location)
		if host then
			local model_info = state.current_model and (" - " .. state.current_model) or ""
			vim.notify(string.format("%s server running (%s)%s", location, host, model_info), vim.log.levels.INFO)
		else
			vim.notify("No llama server running", vim.log.levels.WARN)
		end
	end)
end

local function auto_detect()
	find_active_server(function(host, location)
		if host then
			set_endpoint(host)
			state.current_server = location
			vim.notify("Using " .. location .. " llama server", vim.log.levels.INFO)
		end
	end)
end

local function pick_server()
	vim.ui.select({ "local", "remote" }, {
		prompt = "Select server:",
		format_item = function(item)
			local indicator = (state.current_server == item) and " (active)" or ""
			return item .. indicator
		end,
	}, function(choice)
		if not choice then
			return
		end
		local model_list = choice == "local" and models.local_models or models.remote_models
		vim.ui.select(model_list, {
			prompt = "Select model:",
			format_item = function(m)
				return m.name
			end,
		}, function(model)
			if not model then
				return
			end
			stop_all()
			vim.defer_fn(function()
				start_server(choice, model)
			end, 1000)
		end)
	end)
end

local function pick_model()
	local all_models = {}
	for _, m in ipairs(models.local_models) do
		table.insert(all_models, { name = m.name, path = m.path, location = "local" })
	end
	for _, m in ipairs(models.remote_models) do
		table.insert(all_models, { name = m.name, path = m.path, location = "remote" })
	end

	vim.ui.select(all_models, {
		prompt = "Select model:",
		format_item = function(m)
			local indicator = (state.current_model == m.name) and " *" or ""
			return string.format("[%s] %s%s", m.location, m.name, indicator)
		end,
	}, function(choice)
		if not choice then
			return
		end
		stop_all()
		vim.defer_fn(function()
			start_server(choice.location, choice)
		end, 1000)
	end)
end

return {
	"milanglacier/minuet-ai.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	event = "InsertEnter",
	init = function()
		vim.api.nvim_create_user_command("LlamaStart", pick_server, {})
		vim.api.nvim_create_user_command("LlamaModel", pick_model, {})
		vim.api.nvim_create_user_command("LlamaStop", stop_all, {})
		vim.api.nvim_create_user_command("LlamaStatus", show_status, {})
	end,
	config = function()
		require("minuet").setup({
			provider = "openai_fim_compatible",
			request_timeout = 3,
			throttle = 100,
			debounce = 150,
			context_window = 4096,
			n_completions = 1,
			notify = "warn",
			provider_options = {
				openai_fim_compatible = {
					api_key = "TERM",
					name = "Llama.cpp",
					end_point = get_url(config.remote_host, "/v1/completions"),
					model = "qwen2.5-coder",
					stream = true,
					optional = {
						max_tokens = 128,
						top_p = 0.9,
					},
					template = {
						prompt = function(prefix, suffix, _)
							return "<|fim_prefix|>" .. prefix .. "<|fim_suffix|>" .. suffix .. "<|fim_middle|>"
						end,
						suffix = false,
					},
				},
			},
		})
		auto_detect()
	end,
}

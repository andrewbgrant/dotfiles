local config = {
	remote_host = "100.79.220.39",
	local_host = "127.0.0.1",
	port = "8012",
	ssh_host = "princemedici@princemedici",
	server_args = {
		local_context = "4096",
		remote_context = "8192",
		cache_type = "q8_0",
		idle_timeout = "7200",
	},
}

local function load_models()
	local path = vim.fn.expand("~/models/config.json")
	local file = io.open(path, "r")
	if not file then
		vim.notify("~/models/config.json not found", vim.log.levels.ERROR)
		return { local_models = {}, remote_models = {} }
	end
	local content = file:read("*a")
	file:close()
	local data = vim.json.decode(content)
	for _, list in pairs(data) do
		for _, model in ipairs(list) do
			model.path = vim.fn.expand(model.path)
		end
	end
	return data
end

local models = load_models()

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

local function fetch_model_name(host, callback)
	vim.fn.jobstart({
		"curl",
		"-s",
		"--connect-timeout",
		"1",
		get_url(host, "/v1/models"),
	}, {
		stdout_buffered = true,
		on_stdout = function(_, data)
			local response = table.concat(data or {}, "")
			local model = response:match('"model":"([^"]+)"')
			if model then
				model = model:gsub("%.gguf$", "")
			end
			callback(model)
		end,
		on_exit = function(_, code)
			if code ~= 0 then
				callback(nil)
			end
		end,
	})
end

local function find_active_server(callback)
	check_server(config.local_host, function(local_ok)
		if local_ok then
			callback(config.local_host, "local")
		else
			check_server(config.remote_host, function(remote_ok)
				callback(remote_ok and config.remote_host or nil, remote_ok and "remote" or nil)
			end)
		end
	end)
end

local function set_endpoint(host)
	local ok, minuet = pcall(require, "minuet")
	if ok and minuet.config then
		local endpoint = get_url(host, "/v1/completions")
		minuet.config.provider_options.openai_fim_compatible.end_point = endpoint
	else
		vim.notify("Minuet not loaded, cannot set endpoint", vim.log.levels.WARN)
	end
end

local function wait_for_server(host, callback, attempts)
	attempts = attempts or 0
	if attempts > 30 then
		vim.notify("Server failed to start after 30 attempts", vim.log.levels.ERROR)
		return
	end
	if attempts > 0 and attempts % 5 == 0 then
		vim.notify("Waiting for server... (attempt " .. attempts .. "/30)", vim.log.levels.INFO)
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
			"ssh -f -n -o ConnectTimeout=2 %s 'PATH=$PATH:~/llama.cpp/build/bin ~/models/llama-fim-server.sh %s %s %s >/tmp/llama-server.log 2>&1'",
			config.ssh_host,
			model.path,
			args.remote_context,
			config.port
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
		"~/models/llama-fim-stop.sh",
	}, { detach = true })
	state.current_server = nil
	state.current_model = nil
	vim.notify("Stopping llama servers...", vim.log.levels.INFO)
end

local function auto_detect()
	find_active_server(function(host, location)
		if host then
			set_endpoint(host)
			state.current_server = location
			fetch_model_name(host, function(model)
				if model then
					state.current_model = model
					-- vim.notify("Using " .. location .. " llama server (" .. model .. ")", vim.log.levels.INFO)
				else
					-- vim.notify("Using " .. location .. " llama server", vim.log.levels.INFO)
				end
			end)
		else
			local default_model = models.local_models[1]
			start_server("local", default_model)
		end
	end)
end

local function is_active_model(model_name, server_model)
	if not server_model then
		return false
	end
	local name_lower = model_name:lower():gsub("[%-_]", "")
	local server_lower = server_model:lower():gsub("[%-_]", "")
	return server_lower:find(name_lower, 1, true) ~= nil
end

local function pick_model()
	find_active_server(function(host, location)
		local current_model = nil
		local server_running = host ~= nil

		local function show_picker()
			local all_models = {}
			for _, m in ipairs(models.local_models) do
				table.insert(all_models, { name = m.name, path = m.path, location = "local" })
			end
			for _, m in ipairs(models.remote_models) do
				table.insert(all_models, { name = m.name, path = m.path, location = "remote" })
			end
			if server_running then
				table.insert(all_models, { name = "Stop server", is_action = true })
			end

			vim.ui.select(all_models, {
				prompt = "Select model:",
				format_item = function(m)
					if m.is_action then
						return m.name
					end
					local active = is_active_model(m.name, current_model) and " (active)" or ""
					return string.format("[%s] %s%s", m.location, m.name, active)
				end,
			}, function(choice)
				if not choice then
					return
				end
				if choice.is_action then
					stop_all()
					return
				end
				stop_all()
				vim.defer_fn(function()
					start_server(choice.location, choice)
				end, 1000)
			end)
		end

		if host then
			fetch_model_name(host, function(model)
				current_model = model
				show_picker()
			end)
		else
			show_picker()
		end
	end)
end

return {
	"milanglacier/minuet-ai.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	event = "InsertEnter",
	init = function()
		vim.api.nvim_create_user_command("LlamaModel", pick_model, {})
		vim.api.nvim_create_user_command("LlamaStop", stop_all, {})
		vim.keymap.set("n", "<leader>al", pick_model, { desc = "Llama Model" })
		vim.keymap.set("n", "<leader>aL", stop_all, { desc = "Llama Stop" })
	end,
	config = function()
		require("minuet").setup({
			provider = "openai_fim_compatible",
			request_timeout = 10,
			throttle = 100,
			debounce = 150,
			context_window = 4048,
			n_completions = 1,
			notify = "error",
			provider_options = {
				openai_fim_compatible = {
					api_key = "TERM",
					name = "Llama.cpp",
					end_point = get_url(config.local_host, "/v1/completions"),
					model = "qwen2.5-coder",
					stream = true,
					optional = {
						max_tokens = 56,
						top_p = 0.9,
						stop = { "\n" },
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
		vim.defer_fn(auto_detect, 100)
	end,
}

local remote_host = "100.79.220.39"
local local_host = "127.0.0.1"
local port = "8012"
local ssh_host = "princemedici@princemedici"
local remote_model = "~/models/cerebras_Qwen3-Coder-REAP-25B-A3B-Q4_K_M.gguf"
local local_model = "/Users/andrewgrant/models/cerebras_Qwen3-Coder-REAP-25B-A3B-Q4_K_M.gguf"

local function check_server(host)
	local result = vim.fn.system(
		"curl -s -o /dev/null -w '%{http_code}' --connect-timeout 1 http://"
			.. host
			.. ":"
			.. port
			.. "/health 2>/dev/null"
	)
	return result == "200"
end

local function get_active_host()
	if check_server(remote_host) then
		return remote_host, "remote"
	elseif check_server(local_host) then
		return local_host, "local"
	end
	return nil, nil
end

local function stop_local_server()
	vim.fn.system("pkill -f 'llama-server.*" .. port .. "'")
end

local function start_local_server()
	if check_server(local_host) then
		return true
	end
	vim.fn.jobstart({
		"llama-server",
		"-m",
		local_model,
		"--port",
		port,
		"-ngl",
		"99",
		"--flash-attn",
		"on",
		"-c",
		"2048",
		"-b",
		"4096",
		"-ub",
		"1024",
		"--cache-type-k",
		"f16",
		"--cache-type-v",
		"f16",
		"--sleep-idle-seconds",
		"7200",
	}, { detach = true })
	vim.notify("Starting local llama server...", vim.log.levels.INFO)
	return false
end

local function start_remote_server()
	if check_server(remote_host) then
		return true
	end
	local cmd = string.format(
		"ssh -o ConnectTimeout=2 %s 'nohup ~/llama.cpp/build/bin/llama-server -m %s --host 0.0.0.0 --port %s -ngl 99 --flash-attn on -c 4096 -b 4096 -ub 1024 --cache-type-k f16 --cache-type-v f16 > /tmp/llama-server.log 2>&1 &'",
		ssh_host,
		remote_model,
		port
	)
	vim.fn.jobstart(cmd, { detach = true })
	vim.notify("Starting remote llama server...", vim.log.levels.INFO)
	return false
end

local function update_endpoint(host)
	vim.g.llama_config = vim.tbl_extend("force", vim.g.llama_config or {}, {
		endpoint = "http://" .. host .. ":" .. port .. "/infill",
	})
end

local function ensure_server()
	local host, location = get_active_host()
	if host then
		if location == "remote" and check_server(local_host) then
			stop_local_server()
			vim.notify("Remote server found, stopped local server", vim.log.levels.INFO)
		end
		update_endpoint(host)
		vim.notify("Using " .. location .. " server (" .. host .. ")", vim.log.levels.INFO)
		return
	end
	if start_remote_server() then
		update_endpoint(remote_host)
	else
		vim.defer_fn(function()
			if check_server(remote_host) then
				update_endpoint(remote_host)
				vim.notify("Remote server ready", vim.log.levels.INFO)
			else
				start_local_server()
				update_endpoint(local_host)
			end
		end, 3000)
	end
end

return {
	"ggml-org/llama.vim",
	event = "VeryLazy",
	init = function()
		vim.g.llama_config = {
			endpoint = "http://" .. remote_host .. ":" .. port .. "/infill",
			show_info = 0,
		}

		vim.api.nvim_create_user_command("LlamaStart", ensure_server, {})
		vim.api.nvim_create_user_command("LlamaLocal", function()
			start_local_server()
			update_endpoint(local_host)
		end, {})
		vim.api.nvim_create_user_command("LlamaRemote", function()
			start_remote_server()
			update_endpoint(remote_host)
		end, {})
		vim.api.nvim_create_user_command("LlamaStop", function()
			vim.fn.system("pkill -f 'llama-server.*" .. port .. "'")
			vim.fn.jobstart(
				"ssh -o ConnectTimeout=2 " .. ssh_host .. " 'pkill -f \"llama-server.*" .. port .. "\"'",
				{ detach = true }
			)
			vim.notify("Stopped llama servers", vim.log.levels.INFO)
		end, {})
		vim.api.nvim_create_user_command("LlamaStatus", function()
			local host, location = get_active_host()
			if host then
				vim.notify("Llama server running: " .. location .. " (" .. host .. ")", vim.log.levels.INFO)
			else
				vim.notify("No llama server running", vim.log.levels.WARN)
			end
		end, {})

		ensure_server()
	end,
}

local model_path = "/Users/andrewgrant/models/cerebras_Qwen3-Coder-REAP-25B-A3B-Q4_K_M.gguf"

local function is_server_running()
	local result = vim.fn.system("curl -s -o /dev/null -w '%{http_code}' http://127.0.0.1:8012/health 2>/dev/null")
	return result == "200"
end

local function start_server()
	if is_server_running() then
		return
	end
	vim.fn.jobstart({
		"llama-server",
		"-m",
		model_path,
		"--port",
		"8012",
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
	}, {
		detach = true,
	})
end

local function stop_server()
	vim.fn.system("pkill -f 'llama-server.*8012'")
end

return {
	"ggml-org/llama.vim",
	event = "VeryLazy",
	init = function()
		vim.g.llama_config = {
			endpoint = "http://127.0.0.1:8012/infill",
			show_info = 0,
		}

		vim.api.nvim_create_user_command("LlamaStart", start_server, {})
		vim.api.nvim_create_user_command("LlamaStop", stop_server, {})
		vim.api.nvim_create_user_command("LlamaStatus", function()
			if is_server_running() then
				vim.notify("Llama server is running", vim.log.levels.INFO)
			else
				vim.notify("Llama server is not running", vim.log.levels.WARN)
			end
		end, {})

		start_server()
	end,
}

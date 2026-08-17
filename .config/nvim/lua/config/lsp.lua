local lsp_config_dir = vim.fn.stdpath("config") .. "/lsp"
local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
local go_bin = vim.fn.expand("~/go/bin")

local install_commands = {
	basedpyright = "pip install basedpyright",
	tsc = "MasonInstall tsc",
	lua_ls = "brew install lua-language-server",
	bashls = "npm install -g bash-language-server",
	html = "npm install -g vscode-langservers-extracted",
	jsonls = "npm install -g vscode-langservers-extracted",
	gopls = "go install golang.org/x/tools/gopls@latest",
	marksman = "brew install marksman",
	ruff = "pip install ruff",
	rust_analyzer = "rustup component add rust-analyzer",
	tailwindcss = "npm install -g @tailwindcss/language-server",
	texlab = "brew install texlab",
	xml = "brew install lemminx",
	yamlls = "npm install -g yaml-language-server",
}

--- Checks whether a path exists without blocking startup on a subprocess.
---@param path string
---@return boolean
local function file_exists(path)
	return vim.uv.fs_stat(path) ~= nil
end

--- Truncates runaway LSP logs before clients open them.
local function trim_lsp_log()
	local log_path = vim.lsp.log.get_filename()
	local stat = vim.uv.fs_stat(log_path)
	if stat and stat.size > 10 * 1024 * 1024 then
		vim.fn.writefile({}, log_path)
	end
end

--- Resolves an LSP executable from PATH or the local package-manager bins.
---@param cmd string
---@return string?
local function get_cmd_path(cmd)
	local path = vim.fn.exepath(cmd)
	if path ~= "" then
		return path
	end

	local mason_cmd = mason_bin .. "/" .. cmd
	if file_exists(mason_cmd) then
		return mason_cmd
	end

	local go_cmd = go_bin .. "/" .. cmd
	if file_exists(go_cmd) then
		return go_cmd
	end
end

--- Loads project LSP definitions so installed servers can be enabled centrally.
---@return table<string, vim.lsp.Config>
local function load_lsp_configs()
	local configs = {}
	if not file_exists(lsp_config_dir) then
		return configs
	end

	for file in vim.fs.dir(lsp_config_dir) do
		if file:match("%.lua$") then
			local config_path = lsp_config_dir .. "/" .. file
			local ok, config = pcall(dofile, config_path)
			if ok and config and config.name then
				configs[config.name] = config
			end
		end
	end

	return configs
end

--- Splits configured servers by whether their executable can be resolved.
---@param configs table<string, vim.lsp.Config>
---@return { installed: string[], missing: string[] }
local function check_lsp_binaries(configs)
	local missing = {}
	local installed = {}

	for name, config in pairs(configs) do
		if config.cmd and #config.cmd > 0 then
			if get_cmd_path(config.cmd[1]) then
				table.insert(installed, name)
			else
				table.insert(missing, name)
			end
		end
	end

	return { installed = installed, missing = missing }
end

--- Registers installed servers with their resolved executable paths.
---@param configs table<string, vim.lsp.Config>
local function setup_lsps(configs)
	for name, config in pairs(configs) do
		if config.cmd and #config.cmd > 0 then
			local cmd_path = get_cmd_path(config.cmd[1])
			if cmd_path then
				local updated_config = vim.deepcopy(config)
				updated_config.cmd[1] = cmd_path
				vim.lsp.config(name, updated_config)
				vim.lsp.enable(name)
			end
		end
	end
end

--- Reports which configured LSP servers are available on this machine.
local function lsp_status()
	local configs = load_lsp_configs()
	local status = check_lsp_binaries(configs)

	local output = { "LSP Status:", "==========", "" }

	if #status.installed > 0 then
		table.insert(output, "✓ Installed:")
		for _, name in ipairs(status.installed) do
			table.insert(output, "  - " .. name)
		end
		table.insert(output, "")
	end

	if #status.missing > 0 then
		table.insert(output, "✗ Missing:")
		for _, name in ipairs(status.missing) do
			table.insert(output, "  - " .. name)
		end
		table.insert(output, "")
	end

	vim.notify(table.concat(output, "\n"), vim.log.levels.INFO)
end

--- Shows installation commands for configured servers that are unavailable.
local function lsp_install_missing()
	local configs = load_lsp_configs()
	local status = check_lsp_binaries(configs)

	if #status.missing == 0 then
		vim.notify("All LSPs are installed!", vim.log.levels.INFO)
		return
	end

	local output = { "Install missing LSPs:", "=====================", "" }
	for _, name in ipairs(status.missing) do
		local cmd = install_commands[name]
		if cmd then
			table.insert(output, name .. ":")
			table.insert(output, "  " .. cmd)
		end
	end

	vim.notify(table.concat(output, "\n"), vim.log.levels.INFO)
end

trim_lsp_log()

local configs = load_lsp_configs()
setup_lsps(configs)

vim.api.nvim_create_user_command("LspStatus", lsp_status, {})
vim.api.nvim_create_user_command("LspInstallMissing", lsp_install_missing, {})

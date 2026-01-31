local lsp_config_dir = vim.fn.stdpath("config") .. "/lsp"
local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"

local install_commands = {
	basedpyright = "pip install basedpyright",
	ts_ls = "npm install -g typescript-language-server",
	lua_ls = "brew install lua-language-server",
	bashls = "npm install -g bash-language-server",
	eslint = "npm install -g vscode-langservers-extracted",
	html = "npm install -g vscode-langservers-extracted",
	jsonls = "npm install -g vscode-langservers-extracted",
	marksman = "brew install marksman",
	ruff = "pip install ruff",
	rust_analyzer = "rustup component add rust-analyzer",
	tailwindcss = "npm install -g @tailwindcss/language-server",
	texlab = "brew install texlab",
	yamlls = "npm install -g yaml-language-server",
}

local function file_exists(path)
	local stat = vim.loop.fs_stat(path)
	return stat ~= nil
end

local function command_exists(cmd)
	local handle = io.popen("which " .. cmd .. " 2>/dev/null")
	if handle then
		local result = handle:read("*a")
		handle:close()
		if result ~= "" and result ~= nil then
			return true
		end
	end
	
	local mason_cmd = mason_bin .. "/" .. cmd
	local stat = vim.loop.fs_stat(mason_cmd)
	return stat ~= nil
end

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

local function check_lsp_binaries(configs)
	local missing = {}
	local installed = {}

	for name, config in pairs(configs) do
		if config.cmd and #config.cmd > 0 then
			local cmd = config.cmd[1]
			if command_exists(cmd) then
				table.insert(installed, name)
			else
				table.insert(missing, name)
			end
		end
	end

	return { installed = installed, missing = missing }
end

local function get_cmd_path(cmd)
	local handle = io.popen("which " .. cmd .. " 2>/dev/null")
	if handle then
		local result = handle:read("*a")
		handle:close()
		if result ~= "" and result ~= nil then
			return result:gsub("%s+$", "")
		end
	end
	
	local mason_cmd = mason_bin .. "/" .. cmd
	if vim.loop.fs_stat(mason_cmd) then
		return mason_cmd
	end
	
	return nil
end

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

local configs = load_lsp_configs()
setup_lsps(configs)

vim.api.nvim_create_user_command("LspStatus", lsp_status, {})
vim.api.nvim_create_user_command("LspInstallMissing", lsp_install_missing, {})

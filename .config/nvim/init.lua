vim.cmd("let g:loaded_perl_provider = 0")
vim.cmd("let g:loaded_go_provider = 0")
vim.cmd("let g:loaded_php_provider = 0")
vim.cmd("let g:loaded_composer_provider = 0")
vim.cmd("let g:loaded_julia_provider = 0")
vim.cmd("let g:loaded_javac_provider = 0")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    -- bootstrap lazy.nvim
    -- stylua: ignore
    vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable",
        lazypath })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

require("config.options")

require("lazy").setup({ import = "plugins" }, {
	change_detection = { notify = false },
})

require("config")
vim.diagnostic.config({
	virtual_text = true,
	float = {
		focusable = false,
		border = "single",
		source = "always",
	},
})
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "single" })
vim.lsp.enable({
	"basedpyright",
	-- 'eslint',
	"jsonls",
	"ruff",
	"html",
	"yamlls",
	"lua_ls",
	"rust_analyzer",
	"bashls",
	"marksman",
})

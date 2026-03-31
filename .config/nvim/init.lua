vim.cmd("let g:loaded_perl_provider = 0")
vim.cmd("let g:loaded_go_provider = 0")
vim.cmd("let g:loaded_php_provider = 0")
vim.cmd("let g:loaded_composer_provider = 0")
vim.cmd("let g:loaded_julia_provider = 0")
vim.cmd("let g:loaded_javac_provider = 0")

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
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
require("config.lsp")

vim.diagnostic.config({
	virtual_text = true,
	float = {
		focusable = false,
		border = "single",
		source = "always",
	},
})

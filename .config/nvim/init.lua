-- Provider vars that actually exist in neovim; the others (go/php/julia/etc)
-- in the old block were no-ops. python3 stays enabled via python3_host_prog
-- (see config/init.lua); ruby is uninstalled.
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

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
	rocks = { enabled = false },
})

require("config")
require("config.lsp")

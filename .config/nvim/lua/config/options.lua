vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.g.autoformat = true

local opt = vim.opt

opt.shortmess:append({ W = true, I = true, c = true, C = true })
opt.confirm = true

opt.showcmd = true
-- opt.laststatus = 0
opt.laststatus = 3 -- global statusline

opt.termguicolors = true
opt.clipboard = "unnamedplus"
opt.scrolloff = 12
opt.cursorline = false
opt.guicursor = ""
opt.number = true
opt.relativenumber = true
opt.showmode = false
opt.signcolumn = "yes"
opt.splitbelow = true
opt.splitright = true
opt.swapfile = false
opt.undofile = true
opt.updatetime = 50
opt.wrap = false
opt.smoothscroll = true
opt.grepprg = "rg --vimgrep"
opt.ignorecase = true -- Ignore case
opt.smartcase = true -- Don't ignore case with capitals

-- Tabs
opt.expandtab = true
opt.smartindent = true
opt.shiftwidth = 4
opt.tabstop = 4

-- Folding
opt.foldenable = true
opt.foldtext = ""
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.lsp.foldexpr()"
vim.o.winborder = "single"
opt.fillchars:append({ fold = " " })

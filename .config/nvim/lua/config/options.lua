vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local opt = vim.opt

opt.shortmess:append({ W = true, c = true, C = true })
opt.confirm = true

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
opt.updatetime = 200
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
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.o.winborder = "rounded"
opt.pumblend = 10
opt.fillchars:append({ fold = " " })

vim.diagnostic.config({
	virtual_text = false,
	float = {
		focusable = false,
		border = "rounded",
		source = "always",
	},
})

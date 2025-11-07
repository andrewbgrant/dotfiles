require("config.autocmds")
require("config.keymaps")

vim.cmd("let g:python3_host_prog = '/Users/andrewgrant/.uv_global/bin/python'")

-- Copy current buffer path to clipboard
vim.keymap.set("n", "<leader>cp", function()
	vim.fn.setreg("+", vim.fn.expand("%:p"))
end, { desc = "Copy buffer path to clipboard" })

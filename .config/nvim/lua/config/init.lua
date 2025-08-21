require("config.autocmds")
require("config.keymaps")
require("helpers.git_commit")

vim.cmd("let g:python3_host_prog = '/Users/andrewgrant/.uv_global/bin/python'")

-- Load custom commit-selected command and keymap
vim.keymap.set("v", "<leader>gc", "<:CommitSelected<CR>", { desc = "Git Commit Selected" })

-- Copy current buffer path to clipboard
vim.keymap.set("n", "<leader>cp", function()
	vim.fn.setreg("+", vim.fn.expand("%:p"))
end, { desc = "Copy buffer path to clipboard" })

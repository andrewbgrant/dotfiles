require("config.autocmds")
require("config.keymaps")
require("helpers.git_commit")

-- local py_host = "/Users/andrewgrant/.pyenv/shims/python"
vim.cmd("let g:python3_host_prog = '/Users/andrewgrant/.uv_global/bin/python'")
-- return { python_env_path = "/Users/andrewgrant/.uv_global/bin/python" }
--
-- Load custom commit-selected command and keymap
vim.keymap.set("v", "<leader>gc", "<:CommitSelected<CR>", { desc = "Git Commit Selected" })

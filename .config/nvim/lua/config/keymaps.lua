-- copy current buffer path to clipboard
vim.keymap.set("n", "<leader>pp", function()
	local path
	if vim.bo.filetype == "oil" then
		local ok, oil = pcall(require, "oil")
		path = ok and oil.get_current_dir() or nil
	end
	path = path or vim.fn.expand("%:.")

	vim.fn.setreg("+", path)
	vim.notify("Copied path: " .. path, vim.log.levels.INFO)
end, { desc = "Copy file path to clipboard" })

-- Windows
vim.keymap.set("n", "<leader>wx", "<C-W>c", { desc = "Delete window", remap = true })
vim.keymap.set("n", "<leader>w-", "<C-W>s", { desc = "Split window below", remap = true })
vim.keymap.set("n", "<leader>w|", "<C-W>v", { desc = "Split window right", remap = true })

-- Move to window using the <ctrl> hjkl keys
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to left window", remap = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to lower window", remap = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to upper window", remap = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to right window", remap = true })

-- Clear search with <esc>
vim.keymap.set({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

-- toggle inlay hints
vim.keymap.set("n", "<leader>ph", function()
	vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = "Toggle Inlay Hints" })

-- better indenting
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- lazy
vim.keymap.set("n", "<leader>pl", "<cmd>Lazy<cr>", { desc = "Lazy" })

vim.keymap.set("n", "<leader>pD", function()
	-- Get diagnostics for the current line
	local diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line(".") - 1 })

	-- If there are no diagnostics, notify the user
	if #diagnostics == 0 then
		vim.notify("No diagnostics on this line", vim.log.levels.INFO)
		return
	end

	-- Concatenate all diagnostic messages for the line
	local messages = {}
	for _, diagnostic in ipairs(diagnostics) do
		table.insert(messages, diagnostic.message)
	end
	local message_text = table.concat(messages, "\n")

	-- Copy the message(s) to the clipboard
	vim.fn.setreg("+", message_text)
	vim.notify("Copied diagnostics to clipboard:\n" .. message_text, vim.log.levels.INFO)
end, { desc = "Copy Line Diagnostics" })

-- diagnostic
local diagnostic_goto = function(next, severity)
	local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
	severity = severity and vim.diagnostic.severity[severity] or nil
	return function()
		go({ severity = severity })
	end
end
vim.keymap.set("n", "<leader>pd", function()
	vim.diagnostic.open_float({ border = "rounded" })
end, { desc = "Line Diagnostics" })

vim.keymap.set("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
vim.keymap.set("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })

vim.keymap.set("t", "<esc>", "<c-\\><c-n>", { desc = "Enter Normal Mode" })
vim.keymap.set("t", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Go to left window" })
vim.keymap.set("t", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Go to lower window" })
vim.keymap.set("t", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Go to upper window" })
vim.keymap.set("t", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Go to right window" })

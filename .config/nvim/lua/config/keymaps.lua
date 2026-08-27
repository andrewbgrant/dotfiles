-- handle wrapped text better
vim.keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

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

-- Function to check if a buffer should be excluded
local function is_excluded_buffer(bufnr)
	local bufname = vim.fn.bufname(bufnr)
	local buftype = vim.bo[bufnr].buftype

	-- Exclude specific buffer names (add more patterns as needed)
	local excluded_names = { "copilot%-chat" }
	for _, pattern in ipairs(excluded_names) do
		if string.find(bufname, pattern) then
			return true
		end
	end

	-- Exclude specific buffer types (e.g., terminal)
	local excluded_types = { "terminal", "nofile", "quickfix" }
	for _, type in ipairs(excluded_types) do
		if buftype == type then
			return true
		end
	end

	-- Exclude unlisted buffers if desired
	if not vim.api.nvim_buf_is_loaded(bufnr) or not vim.bo[bufnr].buflisted then
		return true
	end

	return false
end

-- Function to get the next valid buffer
local function get_next_buffer(direction)
	local buflist = vim.api.nvim_list_bufs()
	local current_buf = vim.api.nvim_get_current_buf()
	local len = #buflist

	-- Find the current buffer's index
	local current_idx = 0
	for i, buf in ipairs(buflist) do
		if buf == current_buf then
			current_idx = i
			break
		end
	end

	-- Move forward or backward based on direction
	local step = (direction == "next") and 1 or -1
	for i = 1, len do
		local next_idx = (current_idx + step * i - 1) % len + 1
		local next_buf = buflist[next_idx]
		if not is_excluded_buffer(next_buf) then
			return next_buf
		end
	end

	-- If no valid buffer is found, stay on the current one
	return current_buf
end

-- Keymaps for buffer switching
vim.keymap.set("n", "<S-h>", function()
	local prev_buf = get_next_buffer("prev")
	if prev_buf ~= vim.api.nvim_get_current_buf() then
		vim.api.nvim_set_current_buf(prev_buf)
	end
end, { desc = "Previous Buffer" })

vim.keymap.set("n", "<S-l>", function()
	local next_buf = get_next_buffer("next")
	if next_buf ~= vim.api.nvim_get_current_buf() then
		vim.api.nvim_set_current_buf(next_buf)
	end
end, { desc = "Next Buffer" })

-- Tab management
vim.keymap.set("n", "<leader>wn", "<cmd>tabnew<cr>", { desc = "Create Tab" })
-- vim.keymap.set("n", "<leader>wc", "<cmd>tabclose<cr>", { desc = "Close Tab" })
vim.keymap.set("n", "<leader>w]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
vim.keymap.set("n", "<leader>w[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

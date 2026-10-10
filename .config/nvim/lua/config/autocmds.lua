--- Creates a replaceable group for related user autocommands.
---@param name string
---@return integer
local function augroup(name)
	return vim.api.nvim_create_augroup("user_" .. name, { clear = true })
end

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
	group = augroup("checktime"),
	callback = function()
		if vim.o.buftype ~= "nofile" then
			vim.cmd("checktime")
		end
	end,
})

-- Go to last cursor position when opening a file
vim.api.nvim_create_autocmd("BufReadPost", {
	group = augroup("last_loc"),
	callback = function(event)
		local exclude = { "gitcommit", "oil" }
		local buf = event.buf
		if vim.tbl_contains(exclude, vim.bo[buf].filetype) then
			return
		end
		local mark = vim.api.nvim_buf_get_mark(buf, '"')
		local lcount = vim.api.nvim_buf_line_count(buf)
		if mark[1] > 0 and mark[1] <= lcount then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

-- Close helper windows with 'q'
vim.api.nvim_create_autocmd("FileType", {
	group = augroup("close_with_q"),
	pattern = { "help", "lspinfo", "qf", "notify", "checkhealth", "man", "gitsigns-blame" },
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
	end,
})

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	group = augroup("highlight_yank"),
	callback = function()
		vim.hl.on_yank()
	end,
})

-- resize splits if window got resized (current tab only; all-tab equalize
-- forced unrelated tab layouts to reflow on any window drag)
vim.api.nvim_create_autocmd({ "VimResized" }, {
	group = augroup("resize_splits"),
	callback = function()
		vim.cmd("wincmd =")
	end,
})

-- Fix conceallevel for json files
vim.api.nvim_create_autocmd({ "FileType" }, {
	group = augroup("json_conceal"),
	pattern = { "json", "jsonc", "json5" },
	callback = function()
		vim.opt_local.conceallevel = 0
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	group = augroup("indent_2"),
	pattern = { "c", "javascript", "javascriptreact", "typescript", "typescriptreact", "json" },
	callback = function()
		vim.bo.shiftwidth = 2
		vim.bo.tabstop = 2
		vim.bo.softtabstop = 2
		vim.bo.expandtab = true
	end,
})

vim.api.nvim_create_autocmd("LspAttach", {
	group = augroup("lsp_attach"),
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		-- auto-enable unless the user toggled hints off (<leader>ph sets the flag)
		if client and client:supports_method("textDocument/inlayHint") and not vim.g.disable_inlay_hints then
			pcall(vim.lsp.inlay_hint.enable, true, { bufnr = args.buf })
		end

		local bufnr = args.buf
		local function map(mode, lhs, rhs, desc)
			vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
		end

		map("n", "gy", vim.lsp.buf.type_definition, "Goto Type Definition")
		map("n", "K", function()
			vim.lsp.buf.hover({ border = "rounded" })
		end, "Hover")
		map("n", "gK", function()
			vim.lsp.buf.signature_help({ border = "rounded" })
		end, "Signature Help")
		map("i", "<c-k>", function()
			vim.lsp.buf.signature_help({ border = "rounded" })
		end, "Signature Help")
		map({ "n", "v" }, "<leader>c", vim.lsp.buf.code_action, "Code Action")
	end,
})

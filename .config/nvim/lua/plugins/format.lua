return {
	"stevearc/conform.nvim",
	opts = {},
	event = { "BufWritePre" },
	config = function()
		vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin:" .. vim.env.PATH
		local conform = require("conform")
		conform.setup({
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "ruff_organize_imports", "ruff_format" },
				javascript = { "prettier" },
				typescript = { "prettier" },
				typescriptreact = { "prettier" },
				json = { "prettier" },
				markdown = { "prettier" },
				css = { "prettier" },
				scss = { "prettier" },
				yaml = { "prettier" },
				html = { "prettier" },
				sql = { "sqlfmt" },
				mysql = { "sqlfmt" },
				plsql = { "sqlfmt" },
				sh = { "shfmt" },
			},

			format_on_save = {
				timeout_ms = 3000,
				lsp_format = "fallback",
			},
		})
	end,
}

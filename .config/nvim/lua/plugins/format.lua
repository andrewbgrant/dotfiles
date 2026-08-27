local format_on_save = {
	timeout_ms = 3000,
	lsp_format = "fallback",
}

return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	config = function()
		vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin:" .. vim.fn.expand("~/go/bin") .. ":" .. vim.env.PATH
		require("conform").setup({
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "ruff_organize_imports", "ruff_format" },
				go = { "goimports", "gofumpt" },
				gomod = { "gofumpt" },
				gowork = { "gofumpt" },
				javascript = { "oxfmt" },
				javascriptreact = { "oxfmt" },
				typescript = { "oxfmt" },
				typescriptreact = { "oxfmt" },
				json = { "oxfmt" },
				jsonc = { "oxfmt" },
				graphql = { "oxfmt" },
				json5 = { "oxfmt" },
				markdown = { "oxfmt" },
				css = { "oxfmt" },
				astro = { "prettier" },
				svelte = { "prettier" },
				vue = { "oxfmt" },
				scss = { "oxfmt" },
				yaml = { "oxfmt" },
				html = { "oxfmt" },
				sql = { "sqlfmt" },
				mysql = { "sqlfmt" },
				plsql = { "sqlfmt" },
				sh = { "shfmt" },
			},
			format_on_save = format_on_save,
		})
	end,
}

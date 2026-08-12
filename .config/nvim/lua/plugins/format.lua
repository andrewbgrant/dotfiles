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
				javascript = { "biome", "prettier", stop_after_first = true },
				javascriptreact = { "biome", "prettier", stop_after_first = true },
				typescript = { "biome", "prettier", stop_after_first = true },
				typescriptreact = { "biome", "prettier", stop_after_first = true },
				json = { "biome", "prettier", stop_after_first = true },
				jsonc = { "biome", "prettier", stop_after_first = true },
				graphql = { "biome", "prettier", stop_after_first = true },
				json5 = { "prettier" },
				markdown = { "prettier" },
				css = { "biome", "prettier", stop_after_first = true },
				astro = { "prettier" },
				svelte = { "prettier" },
				vue = { "prettier" },
				scss = { "prettier" },
				yaml = { "prettier" },
				html = { "prettier" },
				sql = { "sqlfmt" },
				mysql = { "sqlfmt" },
				plsql = { "sqlfmt" },
				sh = { "shfmt" },
			},
			format_on_save = format_on_save,
		})
	end,
}

return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = "ConformInfo",
	keys = {
		{
			"<leader>pf",
			function()
				require("conform").format()
			end,
			desc = "Format Buffer",
		},
	},
	config = function()
		vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin:" .. vim.fn.expand("~/go/bin") .. ":" .. vim.env.PATH
		require("conform").setup({
			format_on_save = {
				timeout_ms = 500,
				lsp_format = "fallback",
			},
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "ruff_organize_imports", "ruff_format" },
				go = { "goimports", "gofumpt" },
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
		})
	end,
}

local tools = {
	"bash-language-server",
	"gopls",
	"html-lsp",
	"json-lsp",
	"lemminx",
	"lua-language-server",
	"marksman",
	"oxfmt",
	"oxlint",
	"prettier",
	"rust-analyzer",
	"shellcheck",
	"shfmt",
	"stylua",
	"tailwindcss-language-server",
	"texlab",
	"tsc",
	"yaml-language-server",
}

return {
	{
		"mason-org/mason.nvim",
		cmd = "Mason",
		keys = { { "<leader>pm", "<cmd>Mason<cr>", desc = "Mason" } },
		opts = {},
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		event = "VeryLazy",
		cmd = { "MasonToolsInstall", "MasonToolsInstallSync", "MasonToolsUpdate", "MasonToolsClean" },
		dependencies = { "mason-org/mason.nvim" },
		opts = {
			ensure_installed = tools,
			run_on_start = true,
			start_delay = 3000,
		},
	},
}

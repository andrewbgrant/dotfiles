return {
	{
		"luckasRanarison/tailwind-tools.nvim",
		ft = {
			"typescript",
			"typescriptreact",
			"javascript",
			"javascriptreact",
		},
		name = "tailwind-tools",
		build = ":UpdateRemotePlugins",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
		opts = {
			keymaps = {
				smart_increment = {
					enabled = false,
				},
			},
		},
	},
}

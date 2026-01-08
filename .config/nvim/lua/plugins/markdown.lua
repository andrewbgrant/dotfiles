return {
	{
		"MeanderingProgrammer/render-markdown.nvim",
		ft = { "markdown", "codecompanion" },
		dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.icons" },
		opts = {
			completions = { blink = { enabled = true } },
			code = { width = "block" },
			heading = {
				backgrounds = {
					"NONE",
					"NONE",
					"NONE",
					"NONE",
					"NONE",
					"NONE",
				},
			},
			latex = {
				enabled = true,
				converter = "latex2text",
				highlight = "RenderMarkdownMath",
			},
		},
	},
}

return {
	{
		"saghen/blink.cmp",
		version = "*",
		event = "InsertEnter",
		opts = {
			keymap = { preset = "default" },
			appearance = {
				use_nvim_cmp_as_default = true,
				nerd_font_variant = "mono",
			},
			completion = {
				ghost_text = { enabled = false },
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 20,
					window = { border = "single" },
				},
				menu = {
					scrollbar = false,
					border = "single",
					draw = {
						treesitter = { "lsp" },
					},
				},
			},
			fuzzy = { implementation = "prefer_rust_with_warning" },
			sources = {
				default = {
					"lsp",
					"path",
					"buffer",
				},
			},
		},
		opts_extend = { "sources.default" },
	},
}

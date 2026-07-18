return {
	{
		"saghen/blink.cmp",
		version = "*",
		event = "InsertEnter",
		config = function(_, opts)
			require("blink.cmp").setup(opts)
		end,
		opts = {
			keymap = { preset = "default" },
			appearance = {
				use_nvim_cmp_as_default = true,
				nerd_font_variant = "mono",
			},
			completion = {
				ghost_text = { enabled = false },
				trigger = { prefetch_on_insert = true },
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 20,
					window = { border = "rounded" },
				},
				menu = {
					scrollbar = false,
					border = "rounded",
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
				per_filetype = {
					sql = { "dadbod", "buffer" },
					mysql = { "dadbod", "buffer" },
					plsql = { "dadbod", "buffer" },
				},
				providers = {
					dadbod = {
						name = "Dadbod",
						module = "vim_dadbod_completion.blink",
						score_offset = 85,
					},
				},
			},
		},
		opts_extend = { "sources.default" },
	},
}

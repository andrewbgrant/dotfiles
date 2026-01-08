return {
	{
		"saghen/blink.cmp",
		version = "*",
		event = "InsertEnter",
		config = function(_, opts)
			vim.api.nvim_set_hl(0, "BlinkCmpItemKindMinuet", { fg = "#89b4fa" })
			require("blink.cmp").setup(opts)
		end,
		opts = {
			keymap = { preset = "default" },
			appearance = {
				use_nvim_cmp_as_default = true,
				nerd_font_variant = "mono",
				kind_icons = {
					["Llama.cpp"] = "󱜚",
				},
			},
			completion = {
				ghost_text = { enabled = false },
				trigger = { prefetch_on_insert = false },
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
					"minuet",
				},
				providers = {
					minuet = {
						name = "minuet",
						module = "minuet.blink",
						async = true,
						timeout_ms = 3000,
						score_offset = 50,
					},
				},
			},
		},
		opts_extend = { "sources.default" },
	},
}

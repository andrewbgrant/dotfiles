return {
	{
		"saghen/blink.cmp",
		version = "*",
		event = "InsertEnter",
		dependencies = {
			{ "saghen/blink.compat", version = "*", opts = {} },
		},
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
				trigger = { prefetch_on_insert = true },
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
				per_filetype = {
					sql = { "dadbod", "buffer" },
					mysql = { "dadbod", "buffer" },
					plsql = { "dadbod", "buffer" },
				},
				providers = {
					minuet = {
						name = "minuet",
						module = "minuet.blink",
						async = true,
						timeout_ms = 1500,
						score_offset = 50,
					},
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

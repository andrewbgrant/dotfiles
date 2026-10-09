return {
	{
		"saghen/blink.cmp",
		-- pin to release tags so the prebuilt fuzzy binary is downloaded automatically
		version = "1.*",
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
			signature = { enabled = true },
			completion = {
				list = { max_items = 20 },
				ghost_text = { enabled = false },
				trigger = { prefetch_on_insert = true },
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 500,
					-- window = { border = "rounded" },
				},
				menu = {
					scrollbar = false,
					border = "rounded",
					draw = {
						-- no treesitter label coloring: color lives on the kind icons
						columns = {
							{ "kind_icon", "label", gap = 1 },
						},
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
					sql = { "dadbod_grip", "buffer" },
					mysql = { "dadbod_grip", "buffer" },
					plsql = { "dadbod_grip", "buffer" },
				},
				providers = {
					buffer = {
						min_keyword_length = 3,
						max_items = 5,
					},
					path = {
						min_keyword_length = 2,
					},
					dadbod_grip = {
						name = "Grip SQL",
						module = "dadbod-grip.completion.blink",
						score_offset = 90,
					},
				},
			},
		},
		opts_extend = { "sources.default" },
	},
}

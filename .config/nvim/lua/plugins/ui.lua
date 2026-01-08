return {
	{
		"folke/todo-comments.nvim",
		event = "BufReadPost",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {},
	},

	{
		"echasnovski/mini.hipatterns",
		event = "BufReadPost",
		opts = function()
			local hi = require("mini.hipatterns")
			return {
				tailwind = {
					enabled = true,
					ft = {
						"astro",
						"css",
						"heex",
						"html",
						"html-eex",
						"javascript",
						"javascriptreact",
						"rust",
						"svelte",
						"typescript",
						"typescriptreact",
						"vue",
					},
					style = "full",
				},
				highlighters = {
					hex_color = hi.gen_highlighter.hex_color({ priority = 2000 }),
					shorthand = {
						pattern = "()#%x%x%x()%f[^%x%w]",
						group = function(_, _, data)
							---@type string
							local match = data.full_match
							local r, g, b = match:sub(2, 2), match:sub(3, 3), match:sub(4, 4)
							local hex_color = "#" .. r .. r .. g .. g .. b .. b

							return MiniHipatterns.compute_hex_color_group(hex_color, "bg")
						end,
						extmark_opts = { priority = 2000 },
					},
				},
			}
		end,
	},

	{
		"stevearc/aerial.nvim",
		opts = {
			close_automatic_events = {
				"unfocus",
				"switch_buffer",
			},
			guides = {
				nested_top = " │ ",
				mid_item = " ├─",
				last_item = " └─",
				whitespace = "   ",
			},
			layout = {
				default_direction = "prefer_left",
				placement = "window",
				close_on_select = false,
				max_width = 30,
			},
			show_guides = true,
			open_automatic = function()
				local aerial = require("aerial")
				return vim.api.nvim_win_get_width(0) > 80 and not aerial.was_closed()
			end,
		},
		config = function(_, opts)
			require("aerial").setup(opts)
			vim.keymap.set("n", "<leader>pa", "<cmd>AerialToggle<cr>", { silent = true })
		end,
	},

	{
		"echasnovski/mini.cursorword",
		version = "*",
		event = "BufReadPost",
		opts = {},
		delay = 300,
	},
}

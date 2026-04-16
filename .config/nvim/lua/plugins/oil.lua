return {
	{
		"stevearc/oil.nvim",
		lazy = true,
		opts = {},
		dependencies = { { "echasnovski/mini.icons", opts = {} } },
		config = function()
			require("oil").setup({
				columns = { "permissions", "size", "mtime", "icon" },
				delete_to_trash = true,
				skip_confirm_for_simple_edits = true,
				prompt_save_on_select_new_entry = true,
				default_file_explorer = true,
				win_options = {
					signcolumn = "yes:2",
				},
				view_options = {
					show_hidden = true,
					is_always_hidden = function(name, bufnr)
						local hidden_files = { ".DS_Store", "__pycache__", ".ruff_cache" }
						for _, hidden_file in ipairs(hidden_files) do
							if name == hidden_file then
								return true
							end
						end
						return false
					end,
				},
			})
		end,
		keys = {
			{ "-", "<CMD>Oil<CR>", desc = "Toggle oil (current dir)" },
			{
				"_",
				function()
					require("oil").open(vim.fn.getcwd())
				end,
				desc = "Open oil (project root)",
			},
		},
	},
	{ "malewicz1337/oil-git.nvim", dependencies = { "stevearc/oil.nvim" } },
	-- {
	-- 	"refractalize/oil-git-status.nvim",
	-- 	dependencies = { "stevearc/oil.nvim" },
	-- 	opts = {
	-- 		show_ignored = false,
	-- 		symbols = {
	-- 			index = {
	-- 				["A"] = "+",
	-- 				["D"] = "✗",
	-- 				["M"] = "~",
	-- 				["R"] = "→",
	-- 				["C"] = "⎘",
	-- 				["U"] = "‼",
	-- 				["?"] = "?",
	-- 				["!"] = "",
	-- 				[" "] = " ",
	-- 			},
	-- 			working_tree = {
	-- 				["A"] = "+",
	-- 				["D"] = "✗",
	-- 				["M"] = "~",
	-- 				["R"] = "→",
	-- 				["C"] = "⎘",
	-- 				["U"] = "‼",
	-- 				["?"] = "?",
	-- 				["!"] = "",
	-- 				[" "] = " ",
	-- 			},
	-- 		},
	-- 	},
	-- },
}

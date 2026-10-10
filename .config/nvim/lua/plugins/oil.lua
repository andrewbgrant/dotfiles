return {
	{
		"stevearc/oil.nvim",
		lazy = true,
		opts = {},
		dependencies = {
			{ "echasnovski/mini.icons", opts = {} },
			{ "malewicz1337/oil-git.nvim", opts = {} },
		},
		config = function()
			require("oil").setup({
				-- Unmap oil's buffer-local <C-h>/<C-l> defaults (select-horizontal / refresh)
				-- so global vim-tmux-navigator mappings keep working in oil windows
				keymaps = {
					["<C-h>"] = false,
					["<C-l>"] = false,
					["gx"] = "actions.open_external",
					["gF"] = {
						function()
							local oil = require("oil")
							local dir = oil.get_current_dir()
							local entry = oil.get_cursor_entry()
							if dir and entry then
								vim.system({ "open", "-R", dir .. entry.name })
							end
						end,
						desc = "Reveal in Finder",
					},
				},
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
}

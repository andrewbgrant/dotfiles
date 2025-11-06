return {

	{
		"tpope/vim-fugitive",
		lazy = false,
		config = function() end,

		keys = {
			{ "<leader>ga", ":Git add %<CR>", desc = "Git stage current buffer" },
		},
	},

	{
		"sindrets/diffview.nvim",
		lazy = false,
		keys = {
			{
				"<leader>gd",
				function()
					local success = pcall(vim.cmd, "DiffviewClose")
					if not success then
						vim.cmd("DiffviewOpen")
					end
				end,
				desc = "Toggle Diffview",
			},
			{ "<leader>gdh", "<cmd>DiffviewFileHistory<cr>", desc = "Diffview File History (all)" },
			{ "<leader>gdf", "<cmd>DiffviewFileHistory %<cr>", desc = "Diffview File History (current)" },
			{ "<leader>gdm", "<cmd>DiffviewOpen main<cr>", desc = "Diffview vs main" },
			{ "<leader>gdt", "<cmd>DiffviewToggleFiles<cr>", desc = "Toggle Files Panel" },
			{ "<leader>gdr", "<cmd>DiffviewRefresh<cr>", desc = "Refresh Diffview" },
		},
	},

	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			current_line_blame = false,
			signs = {
				add = { text = "▎" },
				change = { text = "▎" },
				delete = { text = "▎" },
				topdelete = { text = "▎" },
				changedelete = { text = "▎" },
				untracked = { text = "▎" },
			},
			signs_staged = {
				add = { text = "▎" },
				change = { text = "▎" },
				delete = { text = "▎" },
				topdelete = { text = "▎" },
				changedelete = { text = "▎" },
			},
			on_attach = function(buffer)
				local gs = package.loaded.gitsigns
				local function map(mode, l, r, desc)
					vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
				end
				map({ "n", "v" }, "<leader>gs", gs.stage_hunk, "Stage Hunk")
				map("n", "<leader>gb", function()
					gs.blame_line({ full = true })
				end)
				map({ "n", "v" }, "<leader>gr", gs.reset_hunk, "Reset Hunk")
				map({ "n", "v" }, "<leader>gp", gs.preview_hunk, "Preview Hunk")
                -- stylua: ignore start
                map("n", "]h", function()
                    if vim.wo.diff then
                        vim.cmd.normal({ "]c", bang = true })
                    else
                        gs.nav_hunk("next")
                    end
                end, "Next Hunk")
                map("n", "[h", function()
                    if vim.wo.diff then
                        vim.cmd.normal({ "[c", bang = true })
                    else
                        gs.nav_hunk("prev")
                    end
                end, "Prev Hunk")
			end,
		},
	},
}

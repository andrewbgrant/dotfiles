return {
	{
		"esmuellert/codediff.nvim",
		dependencies = { "MunifTanjim/nui.nvim" },
		cmd = "CodeDiff",
		keys = {
			{ "<leader>gd", "<cmd>CodeDiff<cr>", desc = "Diff" },
			{ "<leader>gp", "<cmd>CodeDiff main...<cr>", desc = "PR Diff (merge-base)" },
			{ "<leader>gD", "<cmd>CodeDiff main<cr>", desc = "Diff vs main" },
			{ "<leader>gf", "<cmd>CodeDiff file HEAD<cr>", desc = "File vs HEAD" },
			{ "<leader>gF", "<cmd>CodeDiff file HEAD~1<cr>", desc = "File vs HEAD~1" },
			{ "<leader>gt", "<cmd>CodeDiff history origin/main..HEAD<cr>", desc = "PR Review (commits)" },
			{ "<leader>gh", "<cmd>CodeDiff history %<cr>", desc = "File History" },
			{ "<leader>gH", "<cmd>CodeDiff history<cr>", desc = "File History (all)" },
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
				end, "Blame Line")
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

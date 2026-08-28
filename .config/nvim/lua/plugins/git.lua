--- Opens a branch picker and sends the selected revision to CodeDiff.
--- Local and remote refs are included so the comparison base does not need a local tracking branch.
---@param history boolean Whether to review each commit from the selected branch through HEAD.
local function pick_branch_diff(history)
	Snacks.picker.git_branches({
		all = true,
		title = history and "Review From Branch" or "Diff Against Branch",
		--- Closes the picker before opening CodeDiff with the selected Git revision.
		---@param picker snacks.Picker
		---@param item snacks.picker.finder.Item?
		confirm = function(picker, item)
			picker:close()
			if not item then
				return
			end

			local revision = item.branch or item.commit
			if not revision then
				return
			end

			local args = history and { "history", revision .. "..HEAD" } or { revision }
			vim.api.nvim_cmd({ cmd = "CodeDiff", args = args }, {})
		end,
	})
end

--- Compares the working tree against a branch selected from Snacks.
local function diff_against_branch()
	pick_branch_diff(false)
end

--- Reviews the commits between a selected base branch and HEAD.
local function review_from_branch()
	pick_branch_diff(true)
end

return {
	{
		"esmuellert/codediff.nvim",
		dependencies = { "MunifTanjim/nui.nvim" },
		cmd = "CodeDiff",
		init = function()
			vim.api.nvim_create_autocmd("User", {
				pattern = "CodeDiffOpen",
				callback = function()
					for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
						vim.wo[win].cursorline = false
					end
				end,
			})
		end,
		opts = {
			explorer = {
				position = "left",
				width = 45,
				view_mode = "tree",
				flatten_dirs = false,
			},
			history = {
				view_mode = "tree",
			},
			keymaps = {
				view = {
					stage_hunk = "<leader>gs",
					unstage_hunk = "<leader>gu",
				},
			},
		},
		keys = {
			{ "<leader>gd", "<cmd>CodeDiff<cr>", desc = "Diff" },
			{ "<leader>gD", diff_against_branch, desc = "Diff vs Branch" },
			{ "<leader>gf", "<cmd>CodeDiff file HEAD<cr>", desc = "File vs HEAD" },
			{ "<leader>gF", "<cmd>CodeDiff file HEAD~1<cr>", desc = "File vs HEAD~1" },
			{ "<leader>gt", review_from_branch, desc = "Review From Branch" },
			{ "<leader>gh", "<cmd>CodeDiff history %<cr>", desc = "File History" },
			{ "<leader>gH", "<cmd>CodeDiff history<cr>", desc = "File History (all)" },
		},
	},

	{
		"NeogitOrg/neogit",
		cmd = "Neogit",
		dependencies = {
			"esmuellert/codediff.nvim",
			"folke/snacks.nvim",
		},
		opts = {
			treesitter_diff_highlight = true,
			word_diff_highlight = true,
			disable_context_highlighting = true,
			integrations = {
				codediff = true,
				diffview = false,
				snacks = true,
			},
			diff_viewer = "codediff",
		},
		keys = {
			{ "<leader>gg", "<cmd>Neogit<cr>", desc = "Neogit" },
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
				local function map(mode, lhs, rhs, desc)
					vim.keymap.set(mode, lhs, rhs, { buffer = buffer, desc = desc })
				end

				map("n", "<leader>gs", gs.stage_hunk, "Stage Hunk")
				map("v", "<leader>gs", function()
					gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, "Stage Lines")
				map("n", "<leader>gb", function()
					gs.blame_line({ full = true })
				end, "Blame Line")
				map("n", "<leader>gr", gs.reset_hunk, "Reset Hunk")
				map("v", "<leader>gr", function()
					gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, "Reset Lines")
				map("n", "<leader>gp", gs.preview_hunk, "Preview Hunk")
				map("n", "]h", function()
					if vim.wo.diff then
						vim.cmd.normal({ "]c", bang = true })
					else
						gs.nav_hunk("next", { target = "all" })
					end
				end, "Next Hunk")

				map("n", "[h", function()
					if vim.wo.diff then
						vim.cmd.normal({ "[c", bang = true })
					else
						gs.nav_hunk("prev", { target = "all" })
					end
				end, "Prev Hunk")
			end,
		},
	},
}

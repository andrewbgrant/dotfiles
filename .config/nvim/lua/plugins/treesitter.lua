return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter").setup({
				install_dir = vim.fn.stdpath("data") .. "/site",
			})

			vim.api.nvim_create_autocmd("FileType", {
				callback = function()
					pcall(vim.treesitter.start)
					if vim.bo.filetype ~= "" then
						pcall(function()
							vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
						end)
					end
				end,
			})
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter-context",
		lazy = false,
		opts = { enable = true },
		keys = {
			{
				"<leader>pc",
				function()
					require("treesitter-context").toggle()
				end,
				desc = "TSContext",
			},
		},
		config = function(_, opts)
			require("treesitter-context").setup(opts)
			local function highlight_context()
				vim.api.nvim_set_hl(0, "TreesitterContext", { bg = "#303035" })
				vim.api.nvim_set_hl(0, "TreesitterContextLineNumber", { fg = "#a6a6a6", bg = "#303035" })
			end
			vim.api.nvim_create_autocmd("ColorScheme", { callback = highlight_context })
			highlight_context()
		end,
	},

}

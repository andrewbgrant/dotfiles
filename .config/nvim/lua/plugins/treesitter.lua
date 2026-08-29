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
		opts = { enable = false },
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
			vim.api.nvim_set_hl(0, "treesittercontext", { bg = "#202020" })
		end,
	},

}

return {
	{
		dir = "~/Developer/voyager-nvim/voyager.nvim",
		lazy = true,
		priority = 1000,
		config = function()
			require("voyager").setup({})
			-- vim.cmd.colorscheme("voyager")
		end,
	},

	{
		dir = "~/Developer/spacecowboy.nvim",
		-- "andrewbgrant/spacecowboy.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("spacecowboy").setup({})
			vim.cmd.colorscheme("spacecowboy")
		end,
	},
}

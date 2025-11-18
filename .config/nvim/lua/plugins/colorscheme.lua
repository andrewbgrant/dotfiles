return {
	{
		dir = "~/Developer/voyager-nvim/voyager.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("voyager").setup({})
			vim.cmd.colorscheme("voyager")
		end,
	},
}

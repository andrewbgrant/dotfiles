return {
	{
		dir = "~/Developer/voyager-nvim/voyager.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("voyager").setup({})
			vim.cmd.colorscheme("voyager")
			vim.api.nvim_set_hl(0, "LspInlayHint", { fg = "#5c6370", italic = true })
		end,
	},
}

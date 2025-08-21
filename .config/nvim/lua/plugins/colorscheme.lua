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
	-- {
	-- 	"mcauley-penney/techbase.nvim",
	-- 	config = function()
	-- 		vim.cmd.colorscheme("techbase")
	-- 	end,
	-- 	priority = 1000,
	-- },

	{
		"folke/tokyonight.nvim",
		lazy = true,
		cmd = "Colorscheme tokyonight",
		-- priority = 1000,
		-- config = function()
		--     require("tokyonight").setup({
		--         style = "storm",
		--         transparent = true,
		--         styles = {
		--             sidebars = "transparent",
		--             floats = "transparent",
		--         },
		--     })
		--     vim.cmd.colorscheme("tokyonight")
		--     vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
		-- end,
	},
}

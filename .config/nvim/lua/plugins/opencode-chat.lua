return {
	dir = vim.fn.expand("~/Developer/opencode-chat.nvim"),
	name = "opencode-chat",
	keys = {
		{ "<leader>at", desc = "Toggle OpenCode Chat" },
		{ "<leader>am", desc = "Select OpenCode Model" },
	},
	cmd = { "OpenCodeChat", "OpenCodeClear", "OpenCodeModel" },
	config = function()
		require("opencode-chat").setup({
			width = 80,
			keymaps = {
				clear = false,
			},
		})
	end,
}

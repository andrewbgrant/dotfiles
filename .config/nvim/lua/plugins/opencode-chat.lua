return {
	dir = vim.fn.expand("~/Developer/opencode-chat.nvim"),
	name = "opencode-chat",
	keys = {
		{
			"<leader>ac",
			function()
				require("opencode-chat").toggle()
			end,
			desc = "Toggle OpenCode Chat",
		},
		{
			"<leader>am",
			function()
				require("opencode-chat").select_model()
			end,
			desc = "Select OpenCode Model",
		},
		{
			"<leader>an",
			function()
				require("opencode-chat").new_session()
			end,
			desc = "New OpenCode Session",
		},
	},
	cmd = { "OpenCodeToggle", "OpenCodeModel", "OpenCodeNew" },
	opts = {
		width = 80,
		keymaps = false,
		model = {
			provider = "github-copilot",
			model = "gpt-5-mini",
		},
	},
}

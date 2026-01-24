return {
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		config = function()
			require("copilot").setup({
				suggestion = {
					enabled = true,
					auto_trigger = true,
					keymap = {
						accept = false,
						accept_word = false,
						accept_line = "<C-l>",
						next = false,
						prev = false,
						dismiss = "<C-e>",
					},
				},
				panel = { enabled = false },
				filetypes = {
					markdown = true,
					help = true,
				},
			})

			vim.keymap.set("i", "<Tab>", function()
				if require("copilot.suggestion").is_visible() then
					require("copilot.suggestion").accept()
				else
					vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, true, true), "n", false)
				end
			end, { desc = "Accept copilot or insert tab" })
		end,
	},
}

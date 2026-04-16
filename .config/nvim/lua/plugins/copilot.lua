return {
	"github/copilot.vim",
	cmd = "Copilot",
	event = "InsertEnter",
	config = function()
		vim.g.copilot_no_tab_map = true

		vim.api.nvim_create_autocmd("BufRead", {
			pattern = ".env*",
			callback = function()
				vim.b.copilot_enabled = false
			end,
		})

		vim.keymap.set("i", "<C-l>", 'copilot#Accept("")', { expr = true, replace_keycodes = false })
		vim.keymap.set("i", "<M-]>", "<Plug>(copilot-next)")
		vim.keymap.set("i", "<M-[>", "<Plug>(copilot-prev)")
		vim.keymap.set("i", "<C-]>", "<Plug>(copilot-dismiss)")
	end,
}

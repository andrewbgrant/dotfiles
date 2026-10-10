return {
	{
		"joryeugene/dadbod-grip.nvim",
		version = "*",
		keys = {
			{ "<leader>D", "<cmd>GripConnect<cr>", desc = "Database" },
		},
		opts = {
			ai = false,
			timeout = 60000,
			completion = false,
			connections_path = vim.fn.expand("~/.dbenv/connections.json"),
			discovery = false,
			keymaps = {
				er_diagram = false,
				tab_4 = false,
			},
			picker = "snacks",
		},
		config = function(_, opts)
			-- Homebrew's keg-only MySQL client is not on the default PATH.
			local mysql_bin = "/opt/homebrew/opt/mysql-client/bin"
			local path = vim.env.PATH or ""
			if vim.fn.isdirectory(mysql_bin) == 1 and not vim.tbl_contains(vim.split(path, ":"), mysql_bin) then
				vim.env.PATH = mysql_bin .. ":" .. path
			end

			require("dadbod-grip").setup(opts)

			-- Grip normally writes history, saved queries, and filters to each
			-- project's .grip directory. Keep that state global and out of repos.
			local global_grip_dir = vim.fn.stdpath("data") .. "/grip"
			require("dadbod-grip.paths").grip_dir = function()
				return global_grip_dir
			end

			-- Grip has no option to disable local data-file discovery. Clearing
			-- this registry prevents its connection picker from scanning the
			-- current directory for CSV, JSON, Parquet, and spreadsheet files.
			require("dadbod-grip.filetypes").extensions = {}
		end,
	},
}

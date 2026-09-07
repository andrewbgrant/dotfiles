return {
	{
		"joryeugene/dadbod-grip.nvim",
		version = "*",
		keys = {
			{ "<leader>D", "<cmd>GripConnect<cr>", desc = "Database" },
			{
				"<leader>Dg",
				function()
					require("dadbod-grip").open_smart()
				end,
				desc = "Database grid",
			},
			{ "<leader>Dq", "<cmd>GripQuery<cr>", desc = "Database query" },
			{ "<leader>Ds", "<cmd>GripSchema<cr>", desc = "Database schema" },
			{ "<leader>Dt", "<cmd>GripTables<cr>", desc = "Database tables" },
			{ "<leader>Dh", "<cmd>GripHistory<cr>", desc = "Database history" },
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

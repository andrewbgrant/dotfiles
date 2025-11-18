return {
	{
		"nvim-treesitter/nvim-treesitter",
		event = { "BufReadPost", "BufNewFile" },
		build = ":TSUpdate",
		config = function()
			local config = require("nvim-treesitter.configs")
			config.setup({
				auto_install = true,
				ensure_installed = { "latex" },
				highlight = { enable = true },
				indent = { enable = true },
			})
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter-context",
		opts = { enable = false },
		keys = {
			{
				"<leader>pc",
				function()
					require("treesitter-context").toggle()
				end,
				desc = "Toggle Treesitter Context",
			},
		},
		config = function(_, opts)
			require("treesitter-context").setup(opts)
			vim.api.nvim_set_hl(0, "treesittercontext", { bg = "#202020" })
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		after = "nvim-treesitter",
		event = "VeryLazy",
		config = function()
			-- When in diff mode, we want to use the default
			-- vim text objects c & C instead of the treesitter ones.
			local move = require("nvim-treesitter.textobjects.move") ---@type table<string,fun(...)>
			local configs = require("nvim-treesitter.configs")
			for name, fn in pairs(move) do
				if name:find("goto") == 1 then
					move[name] = function(q, ...)
						if vim.wo.diff then
							local config = configs.get_module("textobjects.move")[name] ---@type table<string,string>
							for key, query in pairs(config or {}) do
								if q == query and key:find("[%]%[][cC]") then
									vim.cmd("normal! " .. key)
									return
								end
							end
						end
						return fn(q, ...)
					end
				end
			end
		end,
	},

	{
		"mason-org/mason.nvim",
		cmd = "Mason",
		keys = { { "<leader>pm", "<cmd>Mason<cr>", desc = "Mason" } },
		opts = {},
	},

	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "mason-org/mason.nvim" },
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("mason-lspconfig").setup({
				automatic_enable = true,
				ensure_installed = {
					"basedpyright",
					"bashls",
					"eslint",
					"lua_ls",
					"jsonls",
					"ruff",
					"html",
					"yamlls",
					"rust_analyzer",
					"marksman",
					"ts_ls",
					"texlab",
				},
			})
		end,
	},
}

return {
	{
		"smjonas/inc-rename.nvim",
		opts = {},
	},
	{
		"folke/ts-comments.nvim",
		opts = {},
		event = "VeryLazy",
		enabled = vim.fn.has("nvim-0.10.0") == 1,
	},

	{
		"folke/flash.nvim",
		lazy = "VeryLazy",
		opts = {},
        -- stylua: ignore
        keys = {
            { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
            { "S", mode = { "n", "o", "x" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
            { "r", mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
            { "R", mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
        },
	},

	{
		"pmizio/typescript-tools.nvim",
		ft = { "typescript", "typescriptreact" },
		dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
		opts = {},
		config = function()
			require("typescript-tools").setup({
				on_attach = function(client, bufnr)
					client.server_capabilities.documentFormattingProvider = false
					client.server_capabilities.documentRangeFormattingProvider = false
				end,
				settings = {
					jsx_close_tag = {
						enable = true,
						filetypes = { "javascriptreact", "typescriptreact" },
					},
					expose_as_code_action = {
						"fix_all",
						"add_missing_imports",
						"remove_unused",
						"remove_unused_imports",
						"organize_imports",
					},
				},
			})
		end,
	},
	{
		"echasnovski/mini.ai",
		event = "VeryLazy",
		opts = function()
			local ai = require("mini.ai")
			return {
				n_lines = 500,
				custom_textobjects = {
					o = ai.gen_spec.treesitter({ -- code block
						a = { "@block.outer", "@conditional.outer", "@loop.outer" },
						i = { "@block.inner", "@conditional.inner", "@loop.inner" },
					}),
					f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }), -- function
					c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }), -- class
					t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" }, -- tags
					d = { "%f[%d]%d+" }, -- digits
					e = { -- Word with case
						{
							"%u[%l%d]+%f[^%l%d]",
							"%f[%S][%l%d]+%f[^%l%d]",
							"%f[%P][%l%d]+%f[^%l%d]",
							"^[%l%d]+%f[^%l%d]",
						},
						"^().*()$",
					},
					u = ai.gen_spec.function_call(), -- u for "Usage"
					U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }), -- without dot in function name
				},
			}
		end,
	},

	{
		"luckasRanarison/tailwind-tools.nvim",
		ft = {
			"typescript",
			"typescriptreact",
			"javascript",
			"javascriptreact",
		},
		name = "tailwind-tools",
		build = ":UpdateRemotePlugins",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
		opts = {
			keymaps = {
				smart_increment = { -- increment tailwindcss units using <C-a> and <C-x>
					enabled = false, -- disable since we use the c-x keymap for deleting a buffer
				},
			},
		},
	},

	{
		"alex-popov-tech/store.nvim",
		dependencies = {
			"OXY2DEV/markview.nvim", -- optional, for pretty readme preview / help window
		},
		cmd = "Store",
		keys = {
			{ "<leader>s", "<cmd>Store<cr>", desc = "Open Plugin Store" },
		},
		opts = {
			-- optional configuration here
		},
	},
}

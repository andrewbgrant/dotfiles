return {

	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		opts = {
			bigfile = { enabled = true },
			quickfile = { enabled = true },
			bufdelete = { enabled = true },
			statuscolumn = { enabled = true },
			lazygit = {
				enabled = true,
				win = {
					style = "lazygit", -- keep the style (optional)
					width = 0.97, -- fraction of editor width (1 or <= 1)
					height = 0.97, -- fraction of editor height
					border = "rounded", -- or "none" to remove the border
				},
			},
			input = { enabled = true },
			image = { enabled = true },
			terminal = {
				enabled = true,
				keys = {
					term_normal = {
						"<esc>",
						mode = "t",
						expr = true,
						desc = "escape to normal mode",
					},
				},
			},
			picker = {
				enabled = true,
				ui_select = true,
				formatters = {
					file = {
						filename_first = true,
						filename_only = false,
						icon_width = 2,
						truncate = 56, -- truncate the file path to (roughly) this length
						git_status_hl = true, -- use the git status highlight group for the filename
					},
				},
			},
			notifier = {
				enabled = true,
				style = "minimal",
			},
		},

        -- stylua: ignore
        keys = {
            { "<c-x>",            function() Snacks.bufdelete() end,                                                  desc = "delete buffer" },
            { "<c-d>",            function() Snacks.bufdelete.other() end,                                            desc = "delete all other buffer" },
            { "<leader>lg",       function() Snacks.lazygit() end,                                                    desc = "lazygit" },

            -- Top Pickers & Explorer
            { "<leader><leader>", function() Snacks.picker.smart({ exclude = { "*.xlsx", "*.csv" } }) end,            desc = "Smart Find Files" },
            { "<leader>ff",       function() Snacks.picker.files({ exclude = { "*.xlsx", "*.csv" } }) end,            desc = "Find Files" },
            { "<leader>b",        function() Snacks.picker.buffers({ layout = "select", sort_lastused = false }) end, desc = "Buffers" },
            { "<leader>fc",       function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end,             desc = "Find Config File" },
            -- Grep
            { "<leader>fg",       function() Snacks.picker.grep() end,                                                desc = "Grep" },
            { "<leader>fG",       function() Snacks.picker.grep_buffers() end,                                        desc = "Grep Buffers" },
            -- search
            { "<leader>fd",       function() Snacks.picker.diagnostics({ severity = { vim.diagnostic.severity.ERROR, vim.diagnostic.severity.WARN, vim.diagnostic.severity.INFO } }) end, desc = "Diagnostics" },
            { "<leader>fD",       function() Snacks.picker.diagnostics_buffer({ severity = { vim.diagnostic.severity.ERROR, vim.diagnostic.severity.WARN, vim.diagnostic.severity.INFO } }) end, desc = "Buffer Diagnostics" },
            { "<leader>fh",       function() Snacks.picker.help() end,                                                desc = "Help Pages" },
            { "<leader>n",        function() Snacks.picker.notifications() end,                                       desc = "noitifications" },
            -- LSP
            { "<leader>fs",       function() Snacks.picker.lsp_symbols() end,                                         desc = "LSP Symbols" },
            { "<leader>fS",       function() Snacks.picker.lsp_workspace_symbols() end,                               desc = "LSP Workspace Symbols" },
            { "<leader>fr",       function() Snacks.picker.lsp_references() end,                                      nowait = true,                   desc = "References" },
            { "<leader>fi",       function() Snacks.picker.lsp_implementations() end,                                 desc = "Goto Implementation" },
            { "gd",               function() Snacks.picker.lsp_definitions() end,                                     desc = "Goto Definition" },
            { "gD",               function() Snacks.picker.lsp_declarations() end,                                    desc = "Goto Declaration" },


            { "<leader>t",        function() Snacks.terminal() end,                                                   desc = "Terminal" },

            { "<leader>sk",       function() Snacks.picker.keymaps() end,                                             desc = "Keymaps" },

            {
                "<leader>o",
                function()
                    require("lazy").load({ plugins = { "oil.nvim" } })
                    local find_command = {
                        "fd",
                        "--type",
                        "d",
                        "--color",
                        "never",
                    }

                    vim.fn.jobstart(find_command, {
                        stdout_buffered = true,
                        on_stdout = function(_, data)
                            if data then
                                local filtered = vim.tbl_filter(function(el)
                                    return el ~= ""
                                end, data)

                                local items = {}
                                for _, v in ipairs(filtered) do
                                    table.insert(items, { text = v })
                                end

                                Snacks.picker.pick({
                                    source = "directories",
                                    items = items,
                                    layout = { preset = "select" },
                                    format = "text",
                                    confirm = function(picker, item)
                                        picker:close()
                                        vim.cmd("Oil " .. item.text)
                                    end,
                                })
                            end
                        end,
                    })
                end,
                desc = "Fuzzy Find Directories"
            },

        },
	},
}

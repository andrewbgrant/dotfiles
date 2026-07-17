--- Keeps LSP symbols focused on named code structure.
---
--- TypeScript servers report anonymous callbacks as ordinary Function symbols,
--- which makes the picker noisy even after filtering by SymbolKind. The parent
--- walk preserves useful descendants while skipping generic callback wrappers.
---@param item snacks.picker.finder.Item
---@return boolean
local function keep_lsp_symbol(item)
	local parent = item.parent
	local parent_name = parent and parent.name or ""
	while parent and (parent_name == "<function>" or parent_name:match("%f[%w]callback$")) do
		parent = parent.parent
		parent_name = parent and parent.name or ""
	end
	item.parent = parent

	local name = item.name or ""
	return name ~= "<function>" and not name:match("%f[%w]callback$")
end

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
			gh = {},
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
				layout = {
					preset = "default",
					layout = {
						width = 0.92,
					},
				},
				formatters = {
					file = {
						filename_first = true,
						filename_only = false,
						icon_width = 2,
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
            -- { "<c-d>",            function() Snacks.bufdelete.other() end,                                            desc = "delete all other buffer" },
            { "<leader>lg",        function() Snacks.lazygit() end,                                                    desc = "Lazygit" },

            -- Top Pickers & Explorer
            { "<leader><leader>", function() Snacks.picker.smart({ exclude = { "*.xlsx", "*.csv" }, filter = { cwd = true } }) end, desc = "Find Files" },
            { "<leader>ff",       function() Snacks.picker.files({ exclude = { "*.xlsx", "*.csv" } }) end,            desc = "Find Files" },
            { "<leader>b",        function() Snacks.picker.buffers({ layout = "select", sort_lastused = false }) end, desc = "Buffers" },
            { "<leader>fc",       function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end,             desc = "Find Config File" },
            { "<leader>fj",       function() Snacks.picker.jumps() end,                                               desc = "Jumps" },
            -- Grep
            { "<leader>fg",       function() Snacks.picker.grep() end,                                                desc = "Grep" },
            { "<leader>fG",       function() Snacks.picker.grep_buffers() end,                                        desc = "Grep Buffers" },
            -- search
            { "<leader>fd",       function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
            { "<leader>fD",       function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },
            { "<leader>fh",       function() Snacks.picker.help() end,                                                desc = "Help Pages" },
            { "<leader>n",        function() Snacks.picker.notifications() end,                                       desc = "noitifications" },
            -- LSP
            { "<leader>fs",       function() Snacks.picker.lsp_symbols({
                filter = {
                    default = {
                        "Class",
                        "Enum",
                        "Field",
                        "Function",
                        "Interface",
                        "Method",
                        "Module",
                        "Namespace",
                        "Package",
                        "Struct",
                        "Trait",
                    },
                },
                transform = keep_lsp_symbol,
            }) end,                                         desc = "LSP Symbols" },
            { "<leader>fS",       function() Snacks.picker.lsp_workspace_symbols() end,                               desc = "LSP Workspace Symbols" },
            { "<leader>fr",       function() Snacks.picker.lsp_references() end,                                      nowait = true,                   desc = "References" },
            { "<leader>fi",       function() Snacks.picker.lsp_implementations() end,                                 desc = "Goto Implementation" },
            { "gd",               function() Snacks.picker.lsp_definitions() end,                                     desc = "Goto Definition" },
            { "gD",               function() Snacks.picker.lsp_declarations() end,                                    desc = "Goto Declaration" },

            { "<leader>gi", function() Snacks.picker.gh_issue() end, desc = "GitHub Issues (open)" },
            { "<leader>gI", function() Snacks.picker.gh_issue({ state = "all" }) end, desc = "GitHub Issues (all)" },
            { "<leader>gp", function() Snacks.picker.gh_pr() end, desc = "GitHub Pull Requests (open)" },
            { "<leader>gP", function() Snacks.picker.gh_pr({ state = "all" }) end, desc = "GitHub Pull Requests (all)" },

            -- Directory-scoped search (Oil or current buffer's directory)
            {
                "<leader>.",
                function()
                    local dir
                    local ok, oil = pcall(require, "oil")
                    if ok then
                        dir = oil.get_current_dir()
                    end
                    dir = dir or vim.fn.expand("%:p:h")
                    Snacks.picker.files({ cwd = dir })
                end,
                desc = "Find Files (current dir)"
            },
            {
                "<leader>,",
                function()
                    local dir
                    local ok, oil = pcall(require, "oil")
                    if ok then
                        dir = oil.get_current_dir()
                    end
                    dir = dir or vim.fn.expand("%:p:h")
                    Snacks.picker.grep({ dirs = { dir } })
                end,
                desc = "Grep (current dir)"
            },

            { "<leader>t",        function() Snacks.terminal() end,                                                   desc = "Terminal" },

            { "<leader>fk",       function() Snacks.picker.keymaps() end,                                             desc = "Keymaps" },

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
                desc = "Open Directories"
            },

        },
	},
}

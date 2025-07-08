return {
    { 'brenoprata10/nvim-highlight-colors', event = "BufReadPost", opts = {} },

    { "christoomey/vim-tmux-navigator",     lazy = true,           event = "VimEnter" },

    -- { -- faster movements in j and k
    --     "PHSix/faster.nvim",
    --     event = { "VimEnter *" },
    --     config = function()
    --         vim.api.nvim_set_keymap("n", "j", "<Plug>(faster_move_j)", { noremap = false, silent = true })
    --         vim.api.nvim_set_keymap("n", "k", "<Plug>(faster_move_k)", { noremap = false, silent = true })
    --         -- if you need map in visual mode
    --         vim.api.nvim_set_keymap("v", "j", "<Plug>(faster_vmove_j)", { noremap = false, silent = true })
    --         vim.api.nvim_set_keymap("v", "k", "<Plug>(faster_vmove_k)", { noremap = false, silent = true })
    --     end,
    -- },

    {
        "folke/todo-comments.nvim",
        event = "BufReadPost",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {},
    },

    -- {
    --     "shortcuts/no-neck-pain.nvim",
    --     lazy = true,
    --     version = "*",
    --     keys = {
    --         { "<leader>pz", "<cmd>NoNeckPain<cr>", mode = { "n", "v" }, desc = "Toggle Chat Window" },
    --     },
    --     opts = {
    --         buffers = {
    --             right = {
    --                 enabled = false,
    --             },
    --         },
    --     },
    -- },
    --
    {
        "MeanderingProgrammer/render-markdown.nvim",
        lazy = "InsertEnter",
        ft = { "markdown", "codecompanion" },
        dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.icons" },
        opts = {
            completions = { blink = { enabled = true } },
            code = { width = 'block' },
            heading = {
                backgrounds = {
                    'NONE',
                    'NONE',
                    'NONE',
                    'NONE',
                    'NONE',
                    'NONE',
                },

            },

        },
    },

    {
        "echasnovski/mini.hipatterns",
        lazy = true,
        ft = {
            "astro",
            "css",
            "heex",
            "html",
            "html-eex",
            "javascript",
            "javascriptreact",
            "rust",
            "svelte",
            "typescript",
            "typescriptreact",
            "vue",
        },
        opts = function()
            local hi = require("mini.hipatterns")
            return {
                tailwind = {
                    enabled = true,
                    ft = {
                        "astro",
                        "css",
                        "heex",
                        "html",
                        "html-eex",
                        "javascript",
                        "javascriptreact",
                        "rust",
                        "svelte",
                        "typescript",
                        "typescriptreact",
                        "vue",
                    },
                    -- full: the whole css class will be highlighted
                    -- compact: only the color will be highlighted
                    style = "full",
                },
                highlighters = {
                    hex_color = hi.gen_highlighter.hex_color({ priority = 2000 }),
                    shorthand = {
                        pattern = "()#%x%x%x()%f[^%x%w]",
                        group = function(_, _, data)
                            ---@type string
                            local match = data.full_match
                            local r, g, b = match:sub(2, 2), match:sub(3, 3), match:sub(4, 4)
                            local hex_color = "#" .. r .. r .. g .. g .. b .. b

                            return MiniHipatterns.compute_hex_color_group(hex_color, "bg")
                        end,
                        extmark_opts = { priority = 2000 },
                    },
                },
            }
        end,
    },
}

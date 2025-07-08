return {
    {
        "nvim-treesitter/nvim-treesitter",
        event = { "BufReadPost", "BufNewFile" },
        build = ":TSUpdate",
        config = function()
            local config = require("nvim-treesitter.configs")
            config.setup({
                auto_install = true,
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
        "mason-org/mason.nvim",
        cmd = "Mason",
        keys = { { "<leader>pm", "<cmd>Mason<cr>", desc = "Mason" } },
        build = ":MasonUpdate",
        opts = {},
    },

    {
        "williamboman/mason-lspconfig.nvim",
        event = "VeryLazy",
        lazy = true,
        opts = {
            auto_install = true,
            ensure_installed = {
                "basedpyright",
                "bashls",
                "eslint",
                "lua_ls",
                "jsonls",
                "ruff",
                "tailwindcss",
                "html",
                "yamlls",
                "rust_analyzer",
                "marksman",
            }
        }
    },
}

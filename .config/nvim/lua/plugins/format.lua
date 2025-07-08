return {
    "stevearc/conform.nvim",
    opts = {},
    event = { "BufWritePre" },
    config = function()
        local conform = require("conform")
        conform.setup({
            formatters_by_ft = {
                lua = { "stylua" },
                python = { "ruff_format" },
                javascript = { "prettier" },
                typescript = { "prettier" },
                typescriptreact = { "prettier" },
                json = { "prettier" },
                markdown = { "prettier" },
                css = { "prettier" },
                scss = { "prettier" },
                yaml = { "prettier" },
                html = { "prettier" },
                sql = { "sqlfmt" },
                sh = { "shfmt" },
            },

            format_on_save = {
                timeout_ms = 3000,
                lsp_format = "fallback",
            },
        })
    end,
}

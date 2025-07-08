return {
    {
        "kristijanhusak/vim-dadbod-ui",
        lazy = true,
        cmd = {
            "DBUI",
            "DBUIToggle",
            "DBUIAddConnection",
            "DBUIFindBuffer",
        },
        dependencies = {
            { "tpope/vim-dadbod" },
            { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" } },
        },
        keys = { { "<leader>D", "<cmd>DBUIToggle<cr>", desc = "Database" } },
        init = function()
            vim.g.db_ui_use_nerd_fonts = true
            vim.g.db_ui_auto_execute_table_helpers = 1
            vim.g.db_ui_show_database_icon = true
            vim.g.db_ui_save_location = "~/dbclient/.dbenv"
            vim.g.db_ui_use_nvim_notify = true
            vim.g.db_ui_execute_on_save = false
        end,
    },
}

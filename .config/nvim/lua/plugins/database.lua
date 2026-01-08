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
        keys = {
            {
                "<leader>D",
                function()
                    for _, tabnr in ipairs(vim.api.nvim_list_tabpages()) do
                        for _, winnr in ipairs(vim.api.nvim_tabpage_list_wins(tabnr)) do
                            local bufnr = vim.api.nvim_win_get_buf(winnr)
                            if vim.bo[bufnr].filetype == "dbui" then
                                vim.api.nvim_set_current_tabpage(tabnr)
                                return
                            end
                        end
                    end
                    vim.cmd("tabnew | DBUI")
                end,
                desc = "Database",
            },
        },
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

return {
    {
        "stevearc/oil.nvim",
        lazy = true,
        opts = {},
        config = function()
            require("oil").setup({
                columns = { "permissions", "size", "mtime", "icon" },
                delete_to_trash = true,
                skip_confirm_for_simple_edits = true,
                prompt_save_on_select_new_entry = true,
                view_options = {
                    show_hidden = true,
                    is_always_hidden = function(name, bufnr)
                        local hidden_files = { ".DS_Store", "__pycache__", ".ruff_cache" }
                        for _, hidden_file in ipairs(hidden_files) do
                            if name == hidden_file then
                                return true
                            end
                        end
                        return false
                    end,
                },
            })
        end,
        keys = {
            { "-", "<CMD>Oil<CR>",                                      desc = "Toggle oil (current dir)" },
            { "_", function() require("oil").open(vim.fn.getcwd()) end, desc = "Open oil (project root)" },
        },
    },
}

local colors = {
    bg = "#222227",
    text = "#C5C5C5",
    inactive_bg = "#000000",
    diagerror = "#F44747",
    diagwarn = "#FF8800",
    diaghint = "#4FC1FF",
    diaginfo = "#FFCC66",
}


local my_theme = {
    normal = {
        a = { bg = colors.bg, fg = colors.text },
        b = { bg = colors.bg, fg = colors.text },
        c = { bg = colors.bg, fg = colors.text },
        y = { bg = colors.bg, fg = colors.text },
    },
    inactive = {
        a = { bg = colors.inactive_bg, fg = colors.text },
        b = { bg = colors.inactive_bg, fg = colors.text },
        c = { bg = colors.inactive_bg, fg = colors.text },
    },
}

return {

    {
        "nvim-lualine/lualine.nvim",
        event = "VimEnter",
        config = function()
            require("lualine").setup({
                options = {
                    icons_enabled = true,
                    theme = my_theme,
                    section_separators = { left = "", right = "" },
                    component_separators = { left = "", right = "" },
                    globalstatus = true,
                },

                sections = {
                    lualine_a = { { "mode", right_padding = 4 } },
                    lualine_b = {

                        {
                            "filename",
                            path = 1,
                            symbols = {
                                modified = "", -- Text to show when the file is modified.
                                readonly = "[-]", -- Text to show when the file is non-modifiable or readonly.
                                unnamed = "[No Name]", -- Text to show for unnamed buffers.
                                newfile = "[New]", -- Text to show for newly created file before first write
                            },
                        },

                        {
                            "diagnostics",
                            sources = { "nvim_diagnostic" },
                            symbols = { error = " ", warn = " ", info = " " },
                            diagnostics_color = {
                                error = { fg = colors.diagerror },
                                warn = { fg = colors.diagwarn },
                                hint = { fg = colors.diaghint },
                                info = { fg = colors.diaginfo },
                            },
                        },
                    },
                    lualine_c = {},
                    lualine_x = { { "diff" } },
                    lualine_y = { { "branch", left_padding = 2 } },
                    lualine_z = {},
                },
                inactive_sections = {
                    lualine_a = {},
                    lualine_b = {
                        {
                            "filename",
                            path = 1,
                            symbols = {
                                modified = "", -- Text to show when the file is modified.
                                readonly = "[-]", -- Text to show when the file is non-modifiable or readonly.
                                unnamed = "[No Name]", -- Text to show for unnamed buffers.
                                newfile = "[New]", -- Text to show for newly created file before first write
                            },
                        },
                    },
                    lualine_c = {},
                    lualine_x = {},
                    lualine_y = {},
                    lualine_z = {},
                },
            })
        end,
    },
}

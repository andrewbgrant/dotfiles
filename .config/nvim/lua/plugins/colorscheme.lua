return {
    {
        dir = "~/Developer/voyager-nvim/voyager.nvim",
        lazy = false,
        config = function()
            require("voyager").setup({})
            vim.cmd.colorscheme("voyager")
        end,
    },
    {
        "folke/tokyonight.nvim",
        cmd = "Colorscheme tokyonight",
        priority = 1000,
        -- config = function()
        --     require("tokyonight").setup({
        --         style = "storm",
        --         transparent = true,
        --         styles = {
        --             sidebars = "transparent",
        --             floats = "transparent",
        --         },
        --     })
        --     vim.cmd.colorscheme("tokyonight")
        --     vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
        -- end,
    },
}

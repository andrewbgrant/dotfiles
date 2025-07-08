return {
    {
        "saghen/blink.cmp",
        version = "*",
        event = "InsertEnter",
        dependencies = { "fang2hou/blink-copilot", },
        opts = {
            keymap = { preset = "default" },
            appearance = {
                use_nvim_cmp_as_default = true,
                nerd_font_variant = "mono",
            },
            completion = {
                ghost_text = { enabled = false },
                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 2,
                    window = { border = "single" },
                },
                menu = {
                    scrollbar = false,
                    border = "single",
                    draw = {
                        treesitter = { "lsp" },
                    },
                },
            },

            fuzzy = { implementation = "prefer_rust_with_warning" },
            sources = {
                default = {
                    "lsp",
                    "copilot",
                    "path",
                    "buffer",
                },
                providers = {
                    copilot = {
                        name = "copilot",
                        module = "blink-copilot",
                        score_offset = 100,
                        async = true,
                        transform_items = function(_, items)
                            local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
                            local kind_idx = #CompletionItemKind + 1
                            CompletionItemKind[kind_idx] = "Copilot"
                            for _, item in ipairs(items) do
                                item.kind = kind_idx
                            end
                            return items
                        end,
                    },
                },
            },
        },
        opts_extend = { "sources.default" },
    },
}

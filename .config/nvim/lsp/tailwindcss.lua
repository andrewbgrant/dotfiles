return {
    name = "tailwindcss",
    cmd = { "tailwindcss-language-server", "--stdio" },
    filetypes = { "html", "css", "scss", "javascript", "javascriptreact", "typescript", "typescriptreact" },
    root_markers = { "package.json", "tailwind.config.js", "tailwind.config.cjs", ".git" },
    settings = {
        tailwindCSS = {
            classAttributes = { "class", "className", "ngClass" },
            lint = { cssConflict = "warning", invalidApply = "error", },
        },
    },
}

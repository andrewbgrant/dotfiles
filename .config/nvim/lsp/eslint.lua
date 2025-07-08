return {
    cmd = { "vscode-eslint-language-server", "--stdio" },
    filetypes = {
        "javascript",
        "javascriptreact",
        "javascript.jsx",
        "typescript",
        "typescriptreact",
        "typescript.jsx",
        "svelte",
    },
    root_markers = {
        "package.json",
        ".git",
        ".eslintrc",
        ".eslintrc.js",
        ".eslintrc.cjs",
        ".eslintrc.yaml",
        ".eslintrc.yml",
        ".eslintrc.json",
        "eslint.config.js",
        "eslint.config.mjs",
        "eslint.config.cjs",
        "eslint.config.ts",
        "eslint.config.mts",
        "eslint.config.cts",
    },
    --- See https://github.com/Microsoft/vscode-eslint#settings-options for documentation
    settings = {
        useESLintClass = false,
        quiet = false, -- Ignore warnings
        validate = "on",
        format = true,
        nodePath = "",
        codeActionsOnSave = {
            enable = false,
            mode = "all",
        },
        problems = {
            shortenToSingleLine = false,
        },
        experimental = {
            useFlatConfig = false,
        },
        packageManager = nil,
        onIgnoredFiles = "off",
        workingDirectories = { mode = "auto" },
    },
}

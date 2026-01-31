return {
    name = "bashls",
    cmd = { "bash-language-server", "start" },
    filetypes = { "sh", "bash" },
    root_markers = { ".git", ".bashrc", ".bash_profile" },
    single_file_support = true,
    settings = {
        bashIde = {
            enableSourceErrorDiagnostics = true,
            shellcheckPath = "shellcheck",
        }
    }
}

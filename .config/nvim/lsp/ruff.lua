return {
    name = "ruff",
    cmd = { "ruff", "server" },
    filetypes = { "python" },
    root_markers = { "pyproject.toml", "setup.py", ".git" },
}

return {
	name = "rust_analyzer",
	-- Use the installed standalone server, not a rustup shim missing its component.
	cmd = { vim.fn.stdpath("data") .. "/mason/bin/rust-analyzer" },
	filetypes = { "rust" },
	root_markers = { "Cargo.toml", ".git" },
	settings = { ["rust-analyzer"] = { diagnostics = { enable = true } } },
}

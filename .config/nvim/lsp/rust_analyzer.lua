return {
	name = "rust_analyzer",
	cmd = { "rust-analyzer" },
	filetypes = { "rust" },
	root_markers = { "Cargo.toml", ".git" },
	settings = { ["rust-analyzer"] = { diagnostics = { enable = true } } },
}

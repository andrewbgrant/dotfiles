return {
	name = "oxlint",
	cmd = { "oxlint", "--lsp" },
	filetypes = {
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
		"vue",
		"svelte",
		"astro",
	},
	root_markers = {
		".oxlintrc.json",
		".oxlintrc.jsonc",
		"oxlint.config.ts",
		"package.json",
		".git",
	},
}

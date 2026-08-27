local tsc_path = vim.fn.stdpath("data") .. "/mason/bin/tsc"

return {
	name = "tsc",
	cmd = { tsc_path, "--lsp", "--stdio" },
	filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
	root_markers = {
		"tsconfig.json",
		"jsconfig.json",
		"package.json",
		".git",
	},
}

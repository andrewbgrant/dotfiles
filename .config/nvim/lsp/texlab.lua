return {
	name = "texlab",
	cmd = { "texlab" },
	filetypes = { "tex", "plaintex", "bib" },
	root_markers = { ".latexmkrc", ".git" },
	single_file_support = true,
	settings = {
		texlab = {
			build = {
				executable = "latexmk",
				args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
				onSave = false,
			},
			forwardSearch = {
				executable = nil,
				args = {},
			},
		},
	},
}

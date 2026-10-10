return {
	name = "pyrefly",
	cmd = { "pyrefly", "lsp" },
	filetypes = { "python" },
	root_markers = {
		"pyrefly.toml",
		"pyproject.toml",
		"setup.py",
		"setup.cfg",
		"requirements.txt",
		"Pipfile",
		"pyrightconfig.json",
		".git",
	},
	init_options = {
		pyrefly = {
			typeCheckingMode = "default",
			diagnosticMode = "openFilesOnly",
			extraSearchPaths = {
				"/Users/andrewgrant/Library/CloudStorage/OneDrive-SharedLibraries-Crossroads/CG Team Site - Documents/4. Operations/crpy/config",
			},
		},
		analysis = {
			inlayHints = {
				variableTypes = true,
				functionReturnTypes = true,
				callArgumentNames = "all",
			},
		},
	},
	on_init = function(client, _)
		client.server_capabilities.semanticTokensProvider = nil
	end,
}

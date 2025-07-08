return {
    cmd = { 'basedpyright-langserver', '--stdio' },
    filetypes = { 'python' },
    root_markers = {
        'pyproject.toml',
        'setup.py',
        'setup.cfg',
        'requirements.txt',
        'Pipfile',
        'pyrightconfig.json',
        '.git',
    },
    settings = {
        python = {
            autoSearchPaths = true,
        },
        basedpyright = {
            disableOrganizeImports = true,
            disableTaggedHints = false,
            analysis = {
                extraPaths = {
                    "/Users/andrewgrant/Library/CloudStorage/OneDrive-SharedLibraries-Crossroads/CG Team Site - Documents/4. Operations/crpy/config",
                },
                typeCheckingMode = "standard",
                autoSearchPaths = true,
                diagnosticMode = "openFilesOnly",
                diagnosticSeverityOverrides = {
                    reportDuplicateImport = true,
                    reportUnusedImport = false,
                    reportUnusedVariable = false,
                    reportUndefinedVariable = false,
                    reportConstantRedefinition = true,
                    reportPrivateUsage = true,
                    reportInconsistentConstructor = "warning",
                    reportUnnecessaryCast = "warning",
                    reportUnnecessaryComparison = "warning",
                    reportUnnecessaryContains = "warning",
                    reportUnnecessaryIsInstance = "warning",
                },
            },
        },
    },
    on_init = function(client, _)
        client.server_capabilities.semanticTokensProvider = nil
    end,
}

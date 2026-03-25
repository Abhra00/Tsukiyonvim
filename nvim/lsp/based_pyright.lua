-- Install with
-- mac: brew install basedpyright
-- Arch: paru -S basedpyright
---@type vim.lsp.Config
return {
    cmd = { 'basedpyright-langserver', '--stdio' },
    filetypes = { 'python' },
    root_markers = { 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', '.git' },
    settings = {
        basedpyright = {
            analysis = {
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = 'openFilesOnly',
                typeCheckingMode = 'standard',
                -- Disable diagnostics handled by ruff
                ignore = { '*' },
            },
        },
    },
}

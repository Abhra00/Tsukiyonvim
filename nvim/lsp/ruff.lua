-- Install with
-- mac: brew install ruff
-- Arch: pacman -S ruff
---@type vim.lsp.Config
return {
    cmd = { 'ruff', 'server' },
    filetypes = { 'python' },
    root_markers = { 'pyproject.toml', 'ruff.toml', '.ruff.toml', '.git' },
    settings = {
        ruff = {
            lint = {
                enable = true,
            },
            format = {
                enable = true,
            },
            -- Disable hover in favor of basedpyright
            showSyntaxErrors = false,
        },
    },
}

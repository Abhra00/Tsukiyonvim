-- Mason
-- Install lsps, linters, formatters
return {
    'williamboman/mason.nvim',
    cmd = 'Mason',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
        ui = {
            icons = {
                package_installed = '✓',
                package_pending = '➜',
                package_uninstalled = '✗',
            },
        },
    },
}

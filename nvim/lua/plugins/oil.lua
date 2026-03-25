-- Oil
-- File explorer

return {
    'stevearc/oil.nvim',
    dependencies = { { 'nvim-mini/mini.icons', opts = {} } },
    lazy = false,
    keys = {
        { '<Leader>e', '<Cmd>Oil --float<CR>', desc = 'File explorer (OIL)', mode = { 'n' } },
    },
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
        view_options = {
            show_hidden = true,
        },
        float = {
            border = 'single',
            padding = 2,
            max_width = 0.5,
            max_height = 0.5,
            win_options = {
                winblend = 0,
            },
        },
        confirmation = {
            border = 'single',
            padding = 2,
            max_width = 0.5,
            max_height = 0.5,
            win_options = {
                winblend = 0,
            },
        },
    },
}

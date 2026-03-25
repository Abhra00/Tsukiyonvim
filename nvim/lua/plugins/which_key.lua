-- Which-key
-- Gives hints of keymaps
return {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    opts_extend = { 'spec' },
    opts = {
        preset = 'helix',
        defaults = {},
        win = {
            border = 'single',
        },
        spec = {
            {
                mode = { 'n', 'x' },
                { '<Leader>d', group = 'debug' },
                { '<Leader>f', group = 'file/find' },
                { '<Leader>g', group = 'git' },
                { '<Leader>gh', group = 'hunks' },
                { '<Leader>s', group = 'search' },
                { '<Leader>t', group = 'tabs' },
                { '<leader>u', group = 'ui' },
                { '<leader>x', group = 'diagnostics/quickfix' },
                { '[', group = 'prev' },
                { ']', group = 'next' },
                { 'gs', group = 'surround' },
                { 'gr', group = 'lsp' },
                { 'z', group = 'fold' },
                {
                    '<Leader>b',
                    group = 'buffer',
                    expand = function()
                        return require('which-key.extras').expand.buf()
                    end,
                },
                {
                    '<Leader>w',
                    group = 'windows',
                    proxy = '<c-w>',
                    expand = function()
                        return require('which-key.extras').expand.win()
                    end,
                },
                -- better descriptions
                { 'gx', desc = 'Open with system app' },
            },
        },
    },
    keys = {
        {
            '<Leader>?',
            function()
                require('which-key').show { global = false }
            end,
            desc = 'Buffer Keymaps (which-key)',
        },
        {
            '<C-w><space>',
            function()
                require('which-key').show { keys = '<c-w>', loop = true }
            end,
            desc = 'Window Hydra Mode (which-key)',
        },
    },
    config = function(_, opts)
        local wk = require 'which-key'
        wk.setup(opts)
        if not vim.tbl_isempty(opts.defaults) then
            vim.notify('which-key: opts.defaults is deprecated. Please use opts.spec instead.', vim.log.levels.WARN)
            wk.register(opts.defaults)
        end
    end,
}

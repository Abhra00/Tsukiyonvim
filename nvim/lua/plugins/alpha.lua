-- Alpha
-- Sexy dashboard
return {
    'goolord/alpha-nvim',
    event = 'VimEnter',
    enabled = true,
    opts = function()
        local dashboard = require 'alpha.themes.dashboard'
        local header = require('utils.headers').cat

        dashboard.section.header.val = header

        dashboard.section.buttons.val = {
            dashboard.button('f', ' ' .. ' FIND FILE', '<cmd> FzfLua files <cr>'),
            dashboard.button('g', '󰊆 ' .. ' FIND TEXT', '<cmd> FzfLua live_grep <cr>'),
            dashboard.button('l', '󰏗 ' .. ' LAZY', '<cmd> Lazy <cr>'),
            dashboard.button('q', ' ' .. ' QUIT', '<cmd> qa <cr>'),
        }

        for _, button in ipairs(dashboard.section.buttons.val) do
            button.opts.hl = 'AlphaButtons'
            button.opts.hl_shortcut = 'AlphaShortcut'
        end

        dashboard.section.header.opts.hl = 'AlphaHeader'
        dashboard.section.buttons.opts.hl = 'AlphaButtons'
        dashboard.section.footer.opts.hl = 'AlphaFooter'
        dashboard.opts.layout[1].val = 0

        return dashboard
    end,
    config = function(_, dashboard)
        if vim.o.filetype == 'lazy' then
            vim.cmd.close()
            vim.api.nvim_create_autocmd('User', {
                once = true,
                pattern = 'AlphaReady',
                callback = function()
                    require('lazy').show()
                end,
            })
        end

        require('alpha').setup(dashboard.opts)

        vim.api.nvim_create_autocmd('User', {
            once = true,
            pattern = 'LazyVimStarted',
            callback = function()
                local stats = require('lazy').stats()
                local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
                dashboard.section.footer.val = ' Neovim loaded '
                    .. stats.loaded
                    .. '/'
                    .. stats.count
                    .. ' plugins in '
                    .. ms
                    .. 'ms'
                pcall(vim.cmd.AlphaRedraw)
            end,
        })
    end,
}

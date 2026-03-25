-- Mini_plugins
-- A library of 40+ independent Lua modules.

return {
    { 'nvim-mini/mini.ai', version = false, event = 'VeryLazy', opts = {} },
    { 'nvim-mini/mini.comment', version = false, event = 'VeryLazy', opts = {} },
    { 'nvim-mini/mini.move', version = false, event = 'VeryLazy', opts = {} },
    { 'nvim-mini/mini.pairs', version = false, event = 'VeryLazy', opts = {} },
    { 'nvim-mini/mini.trailspace', version = false, event = 'VeryLazy', opts = {} },
    -- Setup mini bufremove
    {
        'nvim-mini/mini.bufremove',
        opts = {},
        keys = {
            {
                '<leader>bd',
                function()
                    require('mini.bufremove').delete(0, false)
                end,
                desc = 'Delete current buffer',
            },
        },
    },
    -- Set up mini surround and change keybinds
    {
        'nvim-mini/mini.surround',
        version = false,
        event = 'VeryLazy',
        opts = {
            mappings = {
                add = 'gsa', -- Add surrounding in Normal and Visual modes
                delete = 'gsd', -- Delete surrounding
                find = 'gsf', -- Find surrounding (to the right)
                find_left = 'gsF', -- Find surrounding (to the left)
                highlight = 'gsh', -- Highlight surrounding
                replace = 'gsr', -- Replace surrounding
                update_n_lines = 'gsn', -- Update `n_lines`
            },
        },
    },
    -- Set up mini icons and make it act as web-dev icons
    {
        'nvim-mini/mini.icons',
        lazy = true,
        opts = {
            file = {
                ['.keep'] = { glyph = '󰊢', hl = 'MiniIconsGrey' },
                ['devcontainer.json'] = { glyph = '', hl = 'MiniIconsAzure' },
            },
            filetype = {
                c = { glyph = '', hl = 'MiniIconsAzure' },
                cpp = { glyph = '', hl = 'MiniIconsBlue' },
                sh = { glyph = '', hl = 'MiniIconsGreen' },
                fish = { glyph = '󰈺', hl = 'MiniIconsPurple' },
                dotenv = { glyph = '', hl = 'MiniIconsYellow' },
            },
        },
        init = function()
            package.preload['nvim-web-devicons'] = function()
                require('mini.icons').mock_nvim_web_devicons()
                return package.loaded['nvim-web-devicons']
            end
        end,
    },
    -- Set up mini hipatterns
    {
        'nvim-mini/mini.hipatterns',
        event = 'BufReadPost',
        version = false,
        config = function()
            local hipatterns = require 'mini.hipatterns'
            hipatterns.setup {
                -- stylua: ignore
                highlighters = {
                    fixme = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
                    hack  = { pattern = '%f[%w]()HACK()%f[%W]',  group = 'MiniHipatternsHack' },
                    todo  = { pattern = '%f[%w]()TODO()%f[%W]',  group = 'MiniHipatternsTodo' },
                    note  = { pattern = '%f[%w]()NOTE()%f[%W]',  group = 'MiniHipatternsNote' },
                    hex_color = hipatterns.gen_highlighter.hex_color(),
                },
            }
        end,
    },
}

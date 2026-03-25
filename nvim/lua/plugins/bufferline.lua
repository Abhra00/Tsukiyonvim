-- Bufferline
-- Pretty bufferline.
return {
    'akinsho/bufferline.nvim',
    event = 'VeryLazy',
    opts = {
        options = {
            indicator = { style = 'underline' },
            show_close_icon = false,
            show_buffer_close_icons = false,
            truncate_names = false,
            close_command = function(bufnr)
                require('mini.bufremove').delete(bufnr, false)
            end,
            diagnostics = 'nvim_lsp',
            diagnostics_indicator = function(_, _, diag)
                local icons = require('utils.icons').diagnostics
                local indicator = (diag.error and icons.ERROR .. ' ' or '') .. (diag.warning and icons.WARN or '')
                return vim.trim(indicator)
            end,
        },
    },
    keys = {
        -- Buffer navigation.
        { '<S-h>', '<cmd>BufferLineCyclePrev<cr>', desc = 'Prev Buffer' },
        { '<S-l>', '<cmd>BufferLineCycleNext<cr>', desc = 'Next Buffer' },
        { '[b', '<cmd>BufferLineCyclePrev<cr>', desc = 'Prev Buffer' },
        { ']b', '<cmd>BufferLineCycleNext<cr>', desc = 'Next Buffer' },
        { '[B', '<cmd>BufferLineMovePrev<cr>', desc = 'Move buffer prev' },
        { ']B', '<cmd>BufferLineMoveNext<cr>', desc = 'Move buffer next' },
        { '<leader>bp', '<cmd>BufferLinePick<cr>', desc = 'Pick a buffer to open' },
        { '<leader>bc', '<cmd>BufferLinePickClose<cr>', desc = 'Select a buffer to close' },
        { '<leader>bo', '<cmd>BufferLineCloseOthers<cr>', desc = 'Close other buffers' },
    },
}

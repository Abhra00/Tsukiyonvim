-- Grug-far
-- Effective find and replace
return {
    'MagicDuck/grug-far.nvim',
    cmd = 'GrugFar',
    keys = {
        {
            '<leader>sr',
            function()
                local grug = require 'grug-far'
                grug.open { transient = true }
            end,
            desc = 'Search and Replace',
            mode = { 'n', 'v' },
        },
    },
    opts = {
        -- Disable folding.
        folding = { enabled = false },
        -- Don't numerate the result list.
        resultLocation = { showNumberLabel = false },
    },
}

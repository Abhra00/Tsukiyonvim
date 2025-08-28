return {
  'goolord/alpha-nvim',
  event = 'VimEnter',
  opts = function()
    local dashboard = require 'alpha.themes.dashboard'
    local header = require 'config.headers'

    -- ASCII Logo Header
    local logo = header.tsukinvim
    dashboard.section.header.val = vim.split(logo, '\n')

    -- Dashboard Buttons
    dashboard.section.buttons.val = {
      dashboard.button('f', '󰭎  Find file', '<cmd>Telescope find_files<cr>'),
      dashboard.button('n', '󰪷  New file', '<cmd>ene<cr>'),
      dashboard.button('r', '  Recent files', '<cmd>Telescope oldfiles<cr>'),
      dashboard.button('g', '󰉿  Find text', '<cmd>Telescope live_grep<cr>'),
      dashboard.button('c', '  Config', "<cmd>lua require('telescope.builtin').find_files({ cwd = '~/.config/nvim' })<cr>"),
      dashboard.button('l', '󰒲  Lazy', '<cmd>Lazy<cr>'),
      dashboard.button('q', '  Quit', '<cmd>qa<cr>'),
    }

    for _, button in ipairs(dashboard.section.buttons.val) do
      button.opts.hl = 'AlphaButtons'
      button.opts.hl_shortcut = 'AlphaShortcut'
    end
    dashboard.section.header.opts.hl = 'AlphaHeader'
    dashboard.section.buttons.opts.hl = 'AlphaButtons'
    dashboard.section.footer.opts.hl = 'AlphaFooter'
    dashboard.opts.layout[1].val = 5
    return dashboard
  end,
  config = function(_, dashboard)
    -- close Lazy and re-open when the dashboard is ready
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

    -- Setup alpha
    require('alpha').setup(dashboard.opts)

    -- Footer with lazy stats after Alpha is ready, deferred 100ms for accuracy
    vim.api.nvim_create_autocmd('User', {
      pattern = 'AlphaReady',
      once = true,
      callback = function()
        vim.defer_fn(function()
          local stats = require('lazy').stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
          dashboard.section.footer.val = ' Neovim loaded ' .. stats.loaded .. '/' .. stats.count .. ' plugins in 󰪢 ' .. ms .. 'ms'
          pcall(vim.cmd.AlphaRedraw)
        end, 100) -- 100ms delay
      end,
    })
  end,
}

return {
  {
    'nvim-mini/mini.icons',
    version = false,
    lazy = true,
    opts = {
      default = {
        file = { glyph = '󰪷', hl = 'MiniIconsYellow' },
        filetype = { glyph = '󰪷', hl = 'MiniIconsYellow' },
        extension = { glyph = '󰪷', hl = 'MiniIconsYellow' },
      },
      file = {
        ['.keep'] = { glyph = '󰊢', hl = 'MiniIconsGrey' },
        ['devcontainer.json'] = { glyph = '', hl = 'MiniIconsAzure' },
      },
      filetype = {
        dotenv = { glyph = '', hl = 'MiniIconsYellow' },
        bash = { glyph = '', hl = 'MiniIconsGreen' },
        sh = { glyph = '', hl = 'MiniIconsGreen' },
      },
    },
    init = function()
      package.preload['nvim-web-devicons'] = function()
        require('mini.icons').mock_nvim_web_devicons()
        return package.loaded['nvim-web-devicons']
      end
    end,
  },
  {
    'nvim-mini/mini.ai',
    version = false,
    event = 'VeryLazy',
    opts = {},
  },
  {
    'nvim-mini/mini.surround',
    version = false,
    event = 'VeryLazy',
    config = function()
      require('mini.surround').setup {
        mappings = {
          add = 'gsa', -- Add surrounding in Normal and Visual modes
          delete = 'gsd', -- Delete surrounding
          find = 'gsf', -- Find surrounding (to the right)
          find_left = 'gsF', -- Find surrounding (to the left)
          highlight = 'gsh', -- Highlight surrounding
          replace = 'gsr', -- Replace surrounding
          update_n_lines = 'gsn', -- Update `n_lines`
        },
      }
    end,
  },
  {
    'nvim-mini/mini.indentscope',
    event = { 'BufReadPost', 'BufNewFile' },
    version = false,
    opts = {
      symbol = '│',
    },
  },
  {
    'nvim-mini/mini.pairs',
    event = 'VeryLazy',
    version = false,
    opts = {},
  },
}

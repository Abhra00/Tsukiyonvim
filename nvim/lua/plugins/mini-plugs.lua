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
  {
    'nvim-mini/mini.files',
    version = false,
    keys = {
      {
        '<leader>of',
        function()
          require('mini.files').open(vim.uv.cwd(), true)
        end,
        desc = '[O]pen [F]ile Explorer (cwd)',
      },
      {
        '<leader>oF',
        function()
          require('mini.files').open(vim.api.nvim_buf_get_name(0), true)
        end,
        desc = '[O]pen [F]ile Explorer (Current Dir)',
      },
    },
    opts = {
      windows = {
        preview = true,
        width_focus = 50,
        width_nofocus = 25,
        width_preview = 50,
      },
    },
    config = function(_, opts)
      require('mini.files').setup(opts)
      -- setup git status for mini-files
      require('utils.mini-files-git').setup()
    end,
  },
}

return {
  'nvim-lualine/lualine.nvim',
  event = 'VeryLazy',
  init = function()
    vim.g.lualine_laststatus = vim.o.laststatus
    if vim.fn.argc(-1) > 0 then
      -- set an empty statusline till lualine loads
      vim.o.statusline = ' '
    else
      -- hide the statusline on the starter page
      vim.o.laststatus = 0
    end
  end,
  opts = function()
    -- PERF: we don't need this lualine require madness 🤷
    local lualine_require = require 'lualine_require'
    lualine_require.require = require

    -- restore last status
    vim.o.laststatus = vim.g.lualine_laststatus

    -- import icons file
    local icons = require 'config.icons'

    -- Use short names for modes
    local mode_map = {
      ['NORMAL'] = 'N',
      ['O-PENDING'] = 'N?',
      ['INSERT'] = 'I',
      ['VISUAL'] = 'V',
      ['V-BLOCK'] = 'VB',
      ['V-LINE'] = 'VL',
      ['V-REPLACE'] = 'VR',
      ['REPLACE'] = 'R',
      ['COMMAND'] = '!',
      ['SHELL'] = 'SH',
      ['TERMINAL'] = 'T',
      ['EX'] = 'X',
      ['S-BLOCK'] = 'SB',
      ['S-LINE'] = 'SL',
      ['SELECT'] = 'S',
      ['CONFIRM'] = 'Y?',
      ['MORE'] = 'M',
    }

    local mode = {
      'mode',
      fmt = function(str)
        return ' ' .. mode_map[str] or str
      end,
    }

    local filename = {
      'filename',
      file_status = true, -- displays file status (readonly status, modified status)
      path = 0, -- 0 = just filename, 1 = relative path, 2 = absolute path
      icon = { icons.ui.File, color = { fg = vim.g.base16_gui0E, bg = vim.g.base16_gui02 } }, -- show an icon
      color = { fg = vim.g.base16_gui05, bg = vim.g.base16_gui02 },
    }

    local hide_in_width = function()
      return vim.fn.winwidth(0) > 100
    end

    local diagnostics = {
      'diagnostics',
      sources = { 'nvim_diagnostic' },
      sections = { 'error', 'warn' },
      symbols = {
        error = icons.diagnostics.BoldError,
        warn = icons.diagnostics.BoldWarning,
        info = icons.diagnostics.BoldInformation,
        hint = icons.diagnostics.BoldHint,
      },
      colored = true,
      color = { bg = vim.g.base16_gui01 },
      update_in_insert = false,
      always_visible = false,
      cond = hide_in_width,
    }

    local diff = {
      'diff',
      colored = true,
      symbols = {
        added = icons.git.LineAdded,
        modified = icons.git.LineModified,
        removed = icons.git.LineRemoved,
      }, -- changes diff symbols
      cond = hide_in_width,
      color = { bg = vim.g.base16_gui02 },
    }

    -- Define provider function for current working directory
    local function rootdir_component()
      local file_path = vim.fn.expand '%:p:h'
      local name = vim.fn.fnamemodify(file_path, ':t')
      return name
    end

    -- Define provider function  for location component
    local function location_component()
      local line = vim.fn.line '.'
      local col = vim.fn.charcol '.'
      return string.format('%s%d:%-d', icons.ui.Location, line, col)
    end

    -- Define provider function for location component
    local function progress_component()
      local chars = setmetatable({
        ' ',
        ' ',
        ' ',
        ' ',
        ' ',
        ' ',
        ' ',
        ' ',
        ' ',
        ' ',
        ' ',
        ' ',
        ' ',
        ' ',
        ' ',
        ' ',
        ' ',
        ' ',
        ' ',
        ' ',
        ' ',
        ' ',
        ' ',
        ' ',
        ' ',
        ' ',
        ' ',
        ' ',
      }, {
        __index = function()
          return ' '
        end,
      })

      local cur = vim.fn.line '.'
      local total = vim.fn.line '$'
      local ratio = cur / total
      local pos = math.floor(ratio * 100)

      if pos <= 5 then
        return ' TOP'
      elseif pos >= 95 then
        return ' BOT'
      else
        return chars[math.floor(ratio * #chars)] .. pos .. '%%'
      end
    end
    -- Define the provider function for setting progress section colors
    local function progress_color()
      local cur = vim.fn.line '.'
      local total = vim.fn.line '$'
      local pos = math.floor(cur / total * 100)

      local bg = vim.g.base16_gui01

      if pos <= 5 then
        return { fg = vim.g.base16_gui0B, bg = bg, gui = 'bold' }
      elseif pos >= 95 then
        return { fg = vim.g.base16_gui08, bg = bg, gui = 'bold' }
      else
        return { fg = vim.g.base16_gui0D, bg = bg }
      end
    end

    local opts = {
      options = {
        icons_enabled = true,
        theme = require 'config.lualine-theme', -- Set my tsukiyoarchy theme
        globalstatus = vim.o.laststatus == 3,
        -- Some useful glyphs:
        -- https://www.nerdfonts.com/cheat-sheet
        --          
        section_separators = { left = '', right = '' },
        component_separators = { left = '', right = '' },
        disabled_filetypes = { statusline = { 'alpha' } },
        always_divide_middle = true,
      },
      sections = {
        lualine_a = { mode },
        lualine_b = {
          {
            rootdir_component,
            icon = { icons.ui.EmptyFolderOpen, color = { fg = vim.g.base16_gui0D, bg = vim.g.base16_gui02 } },
            color = { fg = vim.g.base16_gui05, bg = vim.g.base16_gui02 },
          },
          filename,
        },
        lualine_c = {
          {
            'branch',
            icon = { icons.git.Branch, color = { fg = vim.g.base16_gui0E } },
            color = { fg = vim.g.base16_gui05, bg = vim.g.base16_gui01 },
          },
          function()
            return '%='
          end, -- alignment split
          {
            'lsp_status',
            color = { fg = vim.g.base16_gui00, bg = vim.g.base16_gui09, gui = 'bold' },
            icon = icons.ui.Settings,
            symbols = {
              -- Standard unicode symbols to cycle through for LSP progress:
              spinner = {
                ' ',
                ' ',
                ' ',
                ' ',
                ' ',
                ' ',
                ' ',
                ' ',
                ' ',
                ' ',
                ' ',
                ' ',
                ' ',
                ' ',
                ' ',
                ' ',
                ' ',
                ' ',
                ' ',
                ' ',
                ' ',
                ' ',
                ' ',
                ' ',
                ' ',
                ' ',
                ' ',
                ' ',
              },
              -- Standard unicode symbol for when LSP is done:
              done = ' ',
              -- Delimiter inserted between LSP names:
              separator = '',
            },
            -- List of LSP names to ignore (e.g., `null-ls`):
            ignore_lsp = { 'null-ls' },
          },
        },
        lualine_x = {
          diagnostics,
          diff,
          { 'fileformat', symbols = { unix = '' }, color = { bg = vim.g.base16_gui02, fg = vim.g.base16_gui0E } },
          { 'encoding', cond = hide_in_width, color = { bg = vim.g.base16_gui02, fg = vim.g.base16_gui0B } },
          { 'filetype', cond = hide_in_width, color = { bg = vim.g.base16_gui02, fg = vim.g.base16_gui05 } },
        },
        lualine_y = { { location_component, color = { fg = vim.g.base16_gui09, bg = vim.g.base16_gui02 } } },
        lualine_z = { { progress_component, color = progress_color } },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { { 'filename', path = 1 } },
        lualine_x = { { 'location', padding = 0 } },
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {},
      extensions = { 'fugitive' },
    }
    return opts
  end,
}

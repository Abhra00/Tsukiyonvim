---NOTE: LUALINE TSUKIYOARCHY THEME USING BASE16 COLORS

-- Use base16 colors defined by your colorscheme
local c = vim.g

local theme = {
  normal = {
    a = { bg = c.base16_gui01, fg = c.base16_gui0D, gui = 'bold' }, -- blue fg
    b = { bg = c.base16_gui01, fg = c.base16_gui05 },
    c = { bg = 'NONE', fg = c.base16_gui05 },
  },
  insert = {
    a = { bg = c.base16_gui01, fg = c.base16_gui0B, gui = 'bold' }, -- green fg
    b = { bg = 'NONE', fg = c.base16_gui05 },
    c = { bg = 'NONE', fg = c.base16_gui05 },
  },
  visual = {
    a = { bg = c.base16_gui01, fg = c.base16_gui0E, gui = 'bold' }, -- purple fg
    b = { bg = 'NONE', fg = c.base16_gui05 },
    c = { bg = 'NONE', fg = c.base16_gui05 },
  },
  replace = {
    a = { bg = c.base16_gui01, fg = c.base16_gui09, gui = 'bold' }, -- red fg
    b = { bg = 'NONE', fg = c.base16_gui05 },
    c = { bg = 'NONE', fg = c.base16_gui05 },
  },
  command = {
    a = { bg = c.base16_gui01, fg = c.base16_gui08, gui = 'bold' }, -- orange fg
    b = { bg = 'NONE', fg = c.base16_gui05 },
    c = { bg = 'NONE', fg = c.base16_gui05 },
  },
  inactive = {
    a = { bg = 'NONE', fg = c.base16_gui03, gui = 'bold' },
    b = { bg = 'NONE', fg = c.base16_gui03 },
    c = { bg = 'NONE', fg = c.base16_gui03 },
  },
}

return theme

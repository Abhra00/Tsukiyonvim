-- Setup config & colors for base16 nvim

-- Make sure the file exist
local ok, wal_colors = pcall(dofile, os.getenv 'HOME' .. '/.cache/wal/colors-base16-nvim.lua')
if not ok then
  vim.notify('Failed to load wal colors', vim.log.levels.ERROR)
  return
end

-- Setup config
require('base16-colorscheme').with_config {
  telescope = false,
  indentblankline = false,
  cmp = false,
  notify = false,
}

-- Setup colors
require('base16-colorscheme').setup(wal_colors)

-- Set colorscheme name so plugins recognize it
vim.g.colors_name = 'base16-wal'

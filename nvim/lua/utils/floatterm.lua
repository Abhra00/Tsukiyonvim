local M = {}

-- Table to store terminal instances keyed by command
---@type table<string, LazyFloat?>
local terminals = {}

--- Opens an interactive floating terminal.
--- Reuses existing terminal if same command is requested.
---
---@param cmd? string          Command to run in the terminal (optional, default shell if nil)
---@param opts? LazyCmdOptions Additional options (size, ft, persistent, etc)
function M.float_term(cmd, opts)
  opts = vim.tbl_deep_extend('force', {
    ft = 'lazyterm',                    -- filetype for terminal buffers
    size = { width = 0.7, height = 0.7 }, -- default floating window size (70%)
    persistent = true,                  -- keep terminal buffer around
  }, opts or {})

  local key = cmd or 'shell'
  local term = terminals[key]

  if term and term:buf_valid() then
    term:toggle()
  else
    term = require('lazy.util').float_term(cmd, opts)
    vim.b[term.buf].lazyterm_cmd = cmd
    terminals[key] = term
  end
end

--- Close all opened floating terminals
function M.close_all()
  for _, term in pairs(terminals) do
    if term and term:buf_valid() then
      term:close()
    end
  end
  terminals = {}
end

return M


return {
  'numToStr/Comment.nvim',
  dependencies = {
    -- plugin to allow us to automatically comment tsx elements with the comment plugin
    'JoosepAlviste/nvim-ts-context-commentstring',
  },
  keys = {
    { '<leader>/', '<Plug>(comment_toggle_linewise_current)', mode = 'n', desc = 'Comment Line' },
    { '<leader>/', '<Plug>(comment_toggle_linewise_visual)',  mode = 'v', desc = 'Comment Selected' },
  },
  config = function()
    local comment = require 'Comment'
    local ts_context_comment_string = require 'ts_context_commentstring.integrations.comment_nvim'

    comment.setup {
      pre_hook = ts_context_comment_string.create_pre_hook(),
    }
  end,
}


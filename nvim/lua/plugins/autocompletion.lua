-- Get icons
local icons = require 'config.icons'

return {
  {
    'saghen/blink.compat',
    -- use the latest release, via version = '*', if you also use the latest release for blink.cmp
    version = '*',
    -- lazy.nvim will automatically load the plugin when it's required by blink.cmp
    lazy = true,
    -- make sure to set opts so that lazy.nvim calls blink.compat's setup
    opts = {},
  },
  {
    'saghen/blink.cmp',
    event = 'InsertEnter',
    lazy = true,
    -- optional: provides snippets for the snippet source
    dependencies = {
      'rafamadriz/friendly-snippets',
      'Kaiser-Yang/blink-cmp-dictionary',
      'moyiz/blink-emoji.nvim',
      'ray-x/cmp-sql',
    },

    -- use a release tag to download pre-built binaries
    version = '1.*',
    -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
    -- build = 'cargo build --release',
    -- If you use nix, you can build from source using latest nightly rust with:
    -- build = 'nix run .#build-plugin',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
      -- 'super-tab' for mappings similar to vscode (tab to accept)
      -- 'enter' for enter to accept
      -- 'none' for no mappings
      --
      -- All presets have the following mappings:
      -- C-space: Open menu or open docs if already open
      -- C-n/C-p or Up/Down: Select next/previous item
      -- C-e: Hide menu
      -- C-k: Toggle signature help (if signature.enabled = true)
      --
      -- See :h blink-cmp-config-keymap for defining your own keymap
      keymap = {
        preset = 'default',
        ['<C-Z>'] = { 'accept', 'fallback' },
      },

      appearance = {
        -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = 'mono',

        kind_icons = {
          Class = icons.kind.Class,
          Color = icons.kind.Colors,
          Constant = icons.kind.Constant,
          Constructor = icons.kind.Constructor,
          Enum = icons.kind.Enum,
          EnumMember = icons.kind.EnumMember,
          Event = icons.kind.Event,
          Field = icons.kind.Field,
          File = icons.kind.File,
          Folder = icons.kind.Folder,
          Function = icons.kind.Function,
          Interface = icons.kind.Interface,
          Keyword = icons.kind.Keyword,
          Method = icons.kind.Method,
          Module = icons.kind.Module,
          Operator = icons.kind.Operator,
          Property = icons.kind.Property,
          Reference = icons.kind.Reference,
          Snippet = icons.kind.Snippet,
          Struct = icons.kind.Struct,
          Text = icons.kind.Text,
          TypeParameter = icons.kind.TypeParameter,
          Unit = icons.kind.Unit,
          Value = icons.kind.Value,
          Variable = icons.kind.Variable,
        },
      },

      -- Some opts for my own taste
      completion = {
        list = {
          max_items = 50, -- Limit items for better performance
        },
        menu = {
          border = vim.g.border_style,
          scrolloff = 1,
          scrollbar = true,
          -- draw = {
          --   padding = { 0, 0 }, -- side padding
          --   components = {
          --     kind_icon = {
          --       text = function(ctx)
          --         return ' ' .. ctx.kind_icon .. ctx.icon_gap .. ' '
          --       end,
          --     },
          --   },
          -- },
        },
        documentation = {
          auto_show_delay_ms = 0,
          auto_show = true,
          window = {
            scrollbar = true,
            border = vim.g.border_style,
          },
        },
      },
      signature = { enabled = false },

      -- Default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, due to `opts_extend`
      sources = {
        default = { 'lazydev', 'lsp', 'path', 'snippets', 'buffer', 'sql', 'emoji', 'dictionary' },
        providers = {
          -- Highest priority: Development-specific completions
          lazydev = {
            name = 'LazyDev',
            module = 'lazydev.integrations.blink',
            score_offset = 100, -- Keep highest for Neovim development
          },

          -- High priority: LSP completions (most accurate and contextual)
          lsp = {
            name = 'LSP',
            module = 'blink.cmp.sources.lsp',
            score_offset = 90, -- Just below lazydev
            max_items = 30, -- Allow plenty of LSP suggestions
          },

          -- Medium-high priority: Snippets (useful but not always contextual)
          snippets = {
            name = 'Snippets',
            module = 'blink.cmp.sources.snippets',
            score_offset = 60,
            max_items = 8, -- Limit to avoid overwhelming
          },

          -- Medium priority: Path completions (high when relevant)
          path = {
            name = 'Path',
            module = 'blink.cmp.sources.path',
            score_offset = 50, -- High when typing paths
            max_items = 15,
            fallbacks = { 'buffer' }, -- Only fallback to buffer, not snippets
            opts = {
              trailing_slash = false,
              label_trailing_slash = true,
              get_cwd = function(context)
                return vim.fn.expand(('#%d:p:h'):format(context.bufnr))
              end,
              show_hidden_files_by_default = true,
            },
          },

          -- Medium priority: Buffer text (contextual but can be noisy)
          buffer = {
            name = 'Buffer',
            module = 'blink.cmp.sources.buffer',
            score_offset = 40,
            max_items = 8, -- Limit buffer suggestions to reduce noise
            min_keyword_length = 2, -- Avoid single character matches
          },

          -- Lower priority: Dictionary (helpful for writing but not code)
          dictionary = {
            module = 'blink-cmp-dictionary',
            name = 'Dict',
            score_offset = 20,
            enabled = true,
            max_items = 8, -- Limit to top suggestions only
            min_keyword_length = 3,
            should_show_items = function()
              return vim.tbl_contains({ 'markdown', 'text', 'gitcommit', 'org', 'rst' }, vim.bo.filetype)
            end,
            opts = {
              dictionary_directories = { vim.fn.expand '~/.config/nvim/dictionaries' },
              dictionary_files = {
                vim.fn.expand '~/.config/nvim/spell/en.utf-8.add',
              },
            },
          },

          -- Lower priority: Emoji (fun but not essential)
          emoji = {
            module = 'blink-emoji',
            name = 'Emoji',
            score_offset = 15,
            max_items = 5, -- Just a few emoji suggestions
            opts = { insert = true },
            should_show_items = function()
              return vim.tbl_contains({ 'gitcommit', 'markdown', 'org', 'text' }, vim.bo.filetype)
            end,
          },

          -- Contextual priority: SQL (high when in SQL files, hidden otherwise)
          sql = {
            name = 'sql',
            module = 'blink.compat.source',
            score_offset = 80, -- High priority in SQL files
            max_items = 20,
            opts = {},
            should_show_items = function()
              return vim.tbl_contains({ 'sql', 'mysql', 'plsql', 'pgsql' }, vim.bo.filetype)
            end,
          },
        },
      },

      cmdline = {
        enabled = true,
      },

      -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
      -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
      -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
      --
      -- See the fuzzy documentation for more information
      fuzzy = { implementation = 'prefer_rust_with_warning' },
    },
    opts_extend = { 'sources.default' },
  },
}

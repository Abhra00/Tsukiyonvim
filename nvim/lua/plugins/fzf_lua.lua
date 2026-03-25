-- Fzf lua
-- Picker, finder, etc.

-- fzf-lua config (LazyVim's config rewritten without LazyVim dependencies)
local icons = require 'utils.icons'

local function symbols_filter(entry, ctx)
    if ctx.symbols_filter == nil then
        ctx.symbols_filter = {
            'Class',
            'Function',
            'Method',
            'Constructor',
            'Interface',
            'Module',
            'Struct',
            'Trait',
            'Enum',
            'Field',
            'Property',
        }
    end
    return vim.tbl_contains(ctx.symbols_filter, entry.kind)
end

-- Helper to open fzf-lua with optional opts
local function pick(command, opts)
    return function()
        opts = opts or {}
        require('fzf-lua')[command](opts)
    end
end

return {
    'ibhagwan/fzf-lua',
    cmd = 'FzfLua',
    opts = function()
        local fzf = require 'fzf-lua'
        local config = fzf.config
        local actions = fzf.actions

        -- Quickfix / navigation keymaps inside fzf window
        config.defaults.keymap.fzf['ctrl-q'] = 'select-all+accept'
        config.defaults.keymap.fzf['ctrl-u'] = 'half-page-up'
        config.defaults.keymap.fzf['ctrl-d'] = 'half-page-down'
        config.defaults.keymap.fzf['ctrl-x'] = 'jump'
        config.defaults.keymap.fzf['ctrl-f'] = 'preview-page-down'
        config.defaults.keymap.fzf['ctrl-b'] = 'preview-page-up'
        config.defaults.keymap.builtin['<c-f>'] = 'preview-page-down'
        config.defaults.keymap.builtin['<c-b>'] = 'preview-page-up'

        -- Trouble integration
        local ok, _ = pcall(require, 'trouble')
        if ok then
            config.defaults.actions.files['ctrl-t'] = require('trouble.sources.fzf').actions.open
        end

        -- Toggle root dir / cwd
        config.defaults.actions.files['ctrl-r'] = function(_, ctx)
            local o = vim.deepcopy(ctx.__call_opts)
            o.root = o.root == false
            o.cwd = nil
            o.buf = ctx.__CTX.bufnr
            require('fzf-lua')[ctx.__INFO.cmd](o)
        end
        config.defaults.actions.files['alt-c'] = config.defaults.actions.files['ctrl-r']
        config.set_action_helpstr(config.defaults.actions.files['ctrl-r'], 'toggle-root-dir')

        -- Image previewer
        local img_previewer = { 'chafa', '{file}', '--format=symbols' }

        return {
            { 'border-fused', 'hide' },
            'default-title',
            fzf_colors = {
                ['bg'] = { 'bg', 'FzfLuaNormal' },
                ['hl+'] = { 'fg', 'FzfLuaFzfMatch' },
                ['gutter'] = { 'bg', 'FzfLuaNormal' },
                ['info'] = { 'fg', 'FzfLuaFzfInfo' },
                ['scrollbar'] = { 'bg', 'FzfLuaNormal' },
                ['separator'] = { 'fg', 'FzfLuaFzfSeparator' },
                ['pointer'] = { 'fg', 'FzfLuaFzfPointer' },
                ['prompt'] = { 'fg', 'FzfLuaFzfPrompt' },
            },
            fzf_opts = {
                ['--no-scrollbar'] = true,
            },
            defaults = {
                prompt = ' ' .. icons.misc.prompt .. '  ',
                header_prefix = icons.misc.keyboard .. ' ',
                git_icons = true,
                formatter = 'path.dirname_first',
            },
            previewers = {
                builtin = {
                    extensions = {
                        ['png'] = img_previewer,
                        ['jpg'] = img_previewer,
                        ['jpeg'] = img_previewer,
                        ['gif'] = img_previewer,
                        ['webp'] = img_previewer,
                    },
                },
            },
            -- vim.ui.select configuration
            ui_select = function(fzf_opts, items)
                return vim.tbl_deep_extend('force', fzf_opts, {
                    prompt = ' ',
                    winopts = {
                        title = ' ' .. vim.trim((fzf_opts.prompt or 'Select'):gsub('%s*:%s*$', '')) .. ' ',
                        title_pos = 'center',
                    },
                }, fzf_opts.kind == 'codeaction' and {
                    winopts = {
                        layout = 'vertical',
                        height = math.floor(math.min(vim.o.lines * 0.8 - 16, #items + 4) + 0.5) + 16,
                        width = 0.5,
                        preview = {
                            layout = 'vertical',
                            vertical = 'down:15,border-top',
                            hidden = 'hidden',
                        },
                    },
                } or fzf_opts.kind == 'luasnip' and {
                    prompt = ' Snippet choice: ',
                    winopts = {
                        relative = 'cursor',
                        height = 0.35,
                        width = 0.3,
                    },
                } or {
                    winopts = {
                        width = 0.5,
                        height = math.floor(math.min(vim.o.lines * 0.8, #items + 4) + 0.5),
                    },
                })
            end,
            winopts = {
                width = 0.8,
                height = 0.8,
                row = 0.5,
                col = 0.5,
                border = 'single',
                preview = {
                    border = 'single',
                    scrollbar = false,
                },
            },
            files = {
                cwd_prompt = false,
                actions = {
                    ['alt-i'] = { actions.toggle_ignore },
                    ['alt-h'] = { actions.toggle_hidden },
                },
            },
            grep = {
                actions = {
                    ['alt-i'] = { actions.toggle_ignore },
                    ['alt-h'] = { actions.toggle_hidden },
                },
            },
            lsp = {
                symbols = {
                    symbol_hl = function(s)
                        return 'TroubleIcon' .. s
                    end,
                    symbol_fmt = function(s)
                        local icon = icons.symbol_kinds[s] or ''
                        return icon .. ' ' .. s:lower() .. '\t'
                    end,
                    child_prefix = false,
                },
                code_actions = {
                    previewer = nil,
                },
            },
        }
    end,
    config = function(_, opts)
        if opts[1] == 'default-title' then
            local function fix(t)
                t.prompt = t.prompt ~= nil and ' ' or nil
                for _, v in pairs(t) do
                    if type(v) == 'table' then
                        fix(v)
                    end
                end
                return t
            end
            opts = vim.tbl_deep_extend('force', fix(require 'fzf-lua.profiles.default-title'), opts)
            opts[1] = nil
        end
        require('fzf-lua').setup(opts)
    end,
    init = function()
        vim.ui.select = function(...)
            require('lazy').load { plugins = { 'fzf-lua' } }
            require('fzf-lua').register_ui_select()
            return vim.ui.select(...)
        end
    end,
    keys = {
        { '<C-j>', '<C-j>', ft = 'fzf', mode = 't', nowait = true },
        { '<C-k>', '<C-k>', ft = 'fzf', mode = 't', nowait = true },
        { '<Leader>,', '<Cmd>FzfLua buffers sort_mru=true sort_lastused=true<CR>', desc = 'Switch Buffer' },
        { '<Leader>/', pick 'live_grep', desc = 'Grep (Root Dir)' },
        { '<Leader>:', '<Cmd>FzfLua command_history<CR>', desc = 'Command History' },
        { '<Leader><space>', pick 'files', desc = 'Find Files (Root Dir)' },
        -- find
        { '<Leader>fb', '<Cmd>FzfLua buffers sort_mru=true sort_lastused=true<CR>', desc = 'Buffers' },
        { '<Leader>fB', '<Cmd>FzfLua buffers<CR>', desc = 'Buffers (all)' },
        { '<Leader>fc', pick('files', { cwd = vim.fn.stdpath 'config' }), desc = 'Find Config File' },
        { '<Leader>ff', pick 'files', desc = 'Find Files (Root Dir)' },
        { '<Leader>fF', pick('files', { cwd = vim.uv.cwd() }), desc = 'Find Files (cwd)' },
        { '<Leader>fg', '<Cmd>FzfLua git_files<CR>', desc = 'Find Files (git-files)' },
        { '<Leader>fr', '<Cmd>FzfLua oldfiles<CR>', desc = 'Recent' },
        { '<Leader>fR', pick('oldfiles', { cwd = vim.uv.cwd() }), desc = 'Recent (cwd)' },
        -- git
        { '<Leader>gc', '<Cmd>FzfLua git_commits<CR>', desc = 'Commits' },
        { '<Leader>gd', '<Cmd>FzfLua git_diff<CR>', desc = 'Git Diff (hunks)' },
        { '<Leader>gl', '<Cmd>FzfLua git_commits<CR>', desc = 'Commits' },
        { '<Leader>gs', '<Cmd>FzfLua git_status<CR>', desc = 'Status' },
        { '<Leader>gS', '<Cmd>FzfLua git_stash<CR>', desc = 'Git Stash' },
        -- search
        { '<Leader>s"', '<Cmd>FzfLua registers<CR>', desc = 'Registers' },
        { '<Leader>s/', '<Cmd>FzfLua search_history<CR>', desc = 'Search History' },
        { '<Leader>sa', '<Cmd>FzfLua autocmds<CR>', desc = 'Auto Commands' },
        { '<Leader>sb', '<Cmd>FzfLua lines<CR>', desc = 'Buffer Lines' },
        { '<Leader>sc', '<Cmd>FzfLua command_history<CR>', desc = 'Command History' },
        { '<Leader>sC', '<Cmd>FzfLua commands<CR>', desc = 'Commands' },
        { '<Leader>sd', '<Cmd>FzfLua diagnostics_workspace<CR>', desc = 'Diagnostics' },
        { '<Leader>sD', '<Cmd>FzfLua diagnostics_document<CR>', desc = 'Buffer Diagnostics' },
        { '<Leader>sg', pick 'live_grep', desc = 'Grep (Root Dir)' },
        { '<Leader>sG', pick('live_grep', { cwd = vim.uv.cwd() }), desc = 'Grep (cwd)' },
        { '<Leader>sh', '<Cmd>FzfLua help_tags<CR>', desc = 'Help Pages' },
        { '<Leader>sH', '<Cmd>FzfLua highlights<CR>', desc = 'Search Highlight Groups' },
        { '<Leader>sj', '<Cmd>FzfLua jumps<CR>', desc = 'Jumplist' },
        { '<Leader>sk', '<Cmd>FzfLua keymaps<CR>', desc = 'Key Maps' },
        { '<Leader>sl', '<Cmd>FzfLua loclist<CR>', desc = 'Location List' },
        { '<Leader>sM', '<Cmd>FzfLua man_pages<CR>', desc = 'Man Pages' },
        { '<Leader>sm', '<Cmd>FzfLua marks<CR>', desc = 'Jump to Mark' },
        { '<Leader>sR', '<Cmd>FzfLua resume<CR>', desc = 'Resume' },
        { '<Leader>sq', '<Cmd>FzfLua quickfix<CR>', desc = 'Quickfix List' },
        { '<Leader>sw', pick 'grep_cword', desc = 'Word (Root Dir)' },
        { '<Leader>sW', pick('grep_cword', { cwd = vim.uv.cwd() }), desc = 'Word (cwd)' },
        { '<Leader>sw', pick 'grep_visual', mode = 'x', desc = 'Selection (Root Dir)' },
        { '<Leader>sW', pick('grep_visual', { cwd = vim.uv.cwd() }), mode = 'x', desc = 'Selection (cwd)' },
        { '<Leader>uC', pick 'colorschemes', desc = 'Colorscheme with Preview' },
        {
            '<Leader>ss',
            function()
                require('fzf-lua').lsp_document_symbols { regex_filter = symbols_filter }
            end,
            desc = 'Goto Symbol',
        },
        {
            '<Leader>sS',
            function()
                require('fzf-lua').lsp_live_workspace_symbols { regex_filter = symbols_filter }
            end,
            desc = 'Goto Symbol (Workspace)',
        },
        -- Complete path
        {
            '<C-x><C-f>',
            function()
                require('fzf-lua').complete_path {
                    winopts = {
                        height = 0.4,
                        width = 0.5,
                        relative = 'cursor',
                    },
                }
            end,
            desc = 'Fuzzy complete path',
            mode = 'i',
        },
    },
}

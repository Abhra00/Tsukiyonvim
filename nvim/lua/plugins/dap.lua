-- Nvim dap
-- Adds debugging inside nevim

local arrows = require('utils.icons').arrows

-- Set up icons.
local icons = {
    Stopped = { '', 'DiagnosticWarn', 'DapStoppedLine' },
    Breakpoint = '',
    BreakpointCondition = '',
    BreakpointRejected = { '', 'DiagnosticError' },
    LogPoint = arrows.right,
}
for name, sign in pairs(icons) do
    sign = type(sign) == 'table' and sign or { sign }
    vim.fn.sign_define('Dap' .. name, {
        -- stylua: ignore
        text = sign[1] --[[@as string]] .. ' ',
        texthl = sign[2] or 'DiagnosticInfo',
        linehl = sign[3],
        numhl = sign[3],
    })
end

-- Debugging.
return {
    {
        'mfussenegger/nvim-dap',
        dependencies = {
            {
                'igorlfs/nvim-dap-view',
                opts = {
                    winbar = {
                        sections = { 'scopes', 'breakpoints', 'threads', 'exceptions', 'repl', 'console' },
                        default_section = 'scopes',
                    },
                    windows = { size = 18 },
                    -- When jumping through the call stack, try to switch to the buffer if already open in
                    -- a window, else use the last window to open the buffer.
                    switchbuf = 'usetab,uselast',
                },
            },
            -- Virtual text.
            {
                'theHamsta/nvim-dap-virtual-text',
                opts = { virt_text_pos = 'eol' },
            },
            -- Lua adapter.
            {
                'jbyuki/one-small-step-for-vimkind',
                keys = {
                    {
                        '<Leader>dl',
                        function()
                            require('osv').launch { port = 8086 }
                        end,
                        desc = 'Launch Lua adapter',
                    },
                },
            },
            -- Python adapter.
            {
                'mfussenegger/nvim-dap-python',
                ft = 'python',
                config = function()
                    -- Detect python from virtualenv or system
                    local python = (function()
                        local venv = os.getenv 'VIRTUAL_ENV'
                        if venv then
                            return venv .. '/bin/python'
                        end
                        local cwd = vim.fn.getcwd()
                        if vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
                            return cwd .. '/.venv/bin/python'
                        end
                        return vim.fn.exepath 'python3' or vim.fn.exepath 'python' or 'python'
                    end)()

                    require('dap-python').setup(python)
                end,
                keys = {
                    {
                        '<Leader>dm',
                        function()
                            require('dap-python').test_method()
                        end,
                        desc = 'Debug method',
                        ft = 'python',
                    },
                    {
                        '<Leader>dC',
                        function()
                            require('dap-python').test_class()
                        end,
                        desc = 'Debug class',
                        ft = 'python',
                    },
                },
            },
        },
        keys = {
            {
                '<Leader>db',
                function()
                    require('dap').toggle_breakpoint()
                end,
                desc = 'Toggle breakpoint',
            },
            {
                '<Leader>dB',
                '<Cmd>FzfLua dap_breakpoints<CR>',
                desc = 'List breakpoints',
            },
            {
                '<Leader>dc',
                function()
                    require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
                end,
                desc = 'Breakpoint condition',
            },
            {
                '<F5>',
                function()
                    require('dap').continue()
                end,
                desc = 'Continue',
            },
            {
                '<F10>',
                function()
                    require('dap').step_over()
                end,
                desc = 'Step over',
            },
            {
                '<F11>',
                function()
                    require('dap').step_into()
                end,
                desc = 'Step into',
            },
            {
                '<F12>',
                function()
                    require('dap').step_out()
                end,
                desc = 'Step Out',
            },
        },
        config = function()
            local dap = require 'dap'
            local dv = require 'dap-view'

            vim.api.nvim_create_autocmd('FileType', {
                group = vim.api.nvim_create_augroup('mariasolos/dap_options', { clear = true }),
                desc = 'Set options for DAP UI',
                pattern = 'dap-view',
                callback = function()
                    vim.wo[0][0].listchars = 'space: ,tab:   '
                end,
            })

            -- Automatically open the UI when a new debug session is created.
            dap.listeners.before.attach['dap-view-config'] = function()
                dv.open()
            end
            dap.listeners.before.launch['dap-view-config'] = function()
                dv.open()
            end
            dap.listeners.before.event_terminated['dap-view-config'] = function()
                dv.close()
            end
            dap.listeners.before.event_exited['dap-view-config'] = function()
                dv.close()
            end

            -- Lua configurations.
            dap.adapters.nlua = function(callback, config)
                callback { type = 'server', host = config.host or '127.0.0.1', port = config.port or 8086 }
            end
            dap.configurations['lua'] = {
                {
                    type = 'nlua',
                    request = 'attach',
                    name = 'Attach to running Neovim instance',
                },
            }

            -- C configurations.
            dap.configurations['c'] = {
                {
                    name = 'Launch file',
                    type = 'codelldb',
                    request = 'launch',
                    program = function()
                        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
                    end,
                    cwd = '${workspaceFolder}',
                    stopOnEntry = false,
                },
            }
            dap.adapters.codelldb = {
                type = 'executable',
                command = 'codelldb',
            }
        end,
    },
}

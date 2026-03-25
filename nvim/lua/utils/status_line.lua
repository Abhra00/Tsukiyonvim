-- My own statusline

-- Get icons
local icons = require 'utils.icons'

local M = {}

-- Don't show the command that produced the quickfix list.
vim.g.qf_disable_statusline = 1

-- Show the mode in my custom component instead.
vim.o.showmode = false

-- Mode strings
-- Note that: \19 = ^S and \22 = ^V.
local MODE_STRINGS = {
    ['n'] = 'NORMAL',
    ['no'] = 'OP-PENDING',
    ['nov'] = 'OP-PENDING',
    ['noV'] = 'OP-PENDING',
    ['no\22'] = 'OP-PENDING',
    ['niI'] = 'NORMAL',
    ['niR'] = 'NORMAL',
    ['niV'] = 'NORMAL',
    ['nt'] = 'NORMAL',
    ['ntT'] = 'NORMAL',
    ['v'] = 'VISUAL',
    ['vs'] = 'VISUAL',
    ['V'] = 'VISUAL',
    ['Vs'] = 'VISUAL',
    ['\22'] = 'VISUAL',
    ['\22s'] = 'VISUAL',
    ['s'] = 'SELECT',
    ['S'] = 'SELECT',
    ['\19'] = 'SELECT',
    ['i'] = 'INSERT',
    ['ic'] = 'INSERT',
    ['ix'] = 'INSERT',
    ['R'] = 'REPLACE',
    ['Rc'] = 'REPLACE',
    ['Rx'] = 'REPLACE',
    ['Rv'] = 'VIRT REPLACE',
    ['Rvc'] = 'VIRT REPLACE',
    ['Rvx'] = 'VIRT REPLACE',
    ['c'] = 'COMMAND',
    ['cv'] = 'VIM EX',
    ['ce'] = 'EX',
    ['r'] = 'PROMPT',
    ['rm'] = 'MORE',
    ['r?'] = 'CONFIRM',
    ['!'] = 'SHELL',
    ['t'] = 'TERMINAL',
}

-- Clock icons
local CLOCK_ICONS = {
    '󱑊', -- 12
    '󱐿', -- 1
    '󱑀', -- 2
    '󱑁', -- 3
    '󱑂', -- 4
    '󱑃', -- 5
    '󱑄', -- 6
    '󱑅', -- 7
    '󱑆', -- 8
    '󱑇', -- 9
    '󱑈', -- 10
    '󱑉', -- 11
}

-- Define separators
local separators = {
    block = '█',
    slant_right = '',
    slant_left = '',
}

--- Keeps track of the highlight groups I've already created.
---@type table<string, boolean>
local statusline_hls = {}

---@param hl string
---@return string
function M.get_or_create_hl(hl)
    local hl_name = 'Statusline' .. hl

    if not statusline_hls[hl] then
        -- If not in the cache, create the highlight group using the icon's foreground color
        -- and the statusline's background color.
        local bg_hl = vim.api.nvim_get_hl(0, { name = 'StatusLine' })
        local fg_hl = vim.api.nvim_get_hl(0, { name = hl })
        vim.api.nvim_set_hl(0, hl_name, { bg = ('#%06x'):format(bg_hl.bg), fg = ('#%06x'):format(fg_hl.fg) })
        statusline_hls[hl] = true
    end

    return hl_name
end

--- Current mode.
---@return string
function M.mode_component()
    -- Get the respective string to display.
    local mode = MODE_STRINGS[vim.api.nvim_get_mode().mode] or 'UNKNOWN'

    -- Prefix icon
    local prefix_icon = ''

    -- Set the highlight group.
    local hl = 'Other'
    if mode:find 'NORMAL' then
        hl = 'Normal'
    elseif mode:find 'PENDING' then
        hl = 'Pending'
    elseif mode:find 'VISUAL' then
        hl = 'Visual'
    elseif mode:find 'INSERT' or mode:find 'SELECT' then
        hl = 'Insert'
    elseif mode:find 'COMMAND' or mode:find 'TERMINAL' or mode:find 'EX' then
        hl = 'Command'
    end

    -- Construct the component.
    return table.concat {
        string.format('%%#StatuslineModeSeparator%s#%s', hl, separators.block),
        string.format('%%#StatuslineMode%s#%s ', hl, prefix_icon .. ' ' .. mode),
        string.format('%%#StatuslineModeSeparator%s#%s', hl, separators.slant_right),
    }
end

--- Git status component for statusline
---@return string
function M.git_component()
    -- Get statusline buffer number
    local stbufnr = vim.api.nvim_win_get_buf(vim.g.statusline_winid or 0)

    -- Early return if not a git repository or no git status available
    if not vim.b[stbufnr].gitsigns_head or not vim.b[stbufnr].gitsigns_status_dict then
        return ''
    end

    -- Get git status
    local git_status = vim.b[stbufnr].gitsigns_status_dict

    -- Define empty components table
    local components = {}

    -- Branch name
    if git_status.head then
        table.insert(components, string.format('%%#StatuslineGitBranch#%s', icons.git.branch .. ' ' .. git_status.head))
    end

    -- Added files
    if git_status.added and git_status.added > 0 then
        table.insert(components, string.format('%%#StatuslineGitAdded#%s %d', icons.git.added, git_status.added))
    end

    -- Changed files
    if git_status.changed and git_status.changed > 0 then
        table.insert(components, string.format('%%#StatuslineGitChanged#%s %d', icons.git.changed, git_status.changed))
    end

    -- Removed files
    if git_status.removed and git_status.removed > 0 then
        table.insert(components, string.format('%%#StatuslineGitRemoved#%s %d', icons.git.removed, git_status.removed))
    end

    -- Join all components with space separator
    return table.concat(components, ' ')
end

--- The current debugging status (if any).
---@return string?
function M.dap_component()
    if not package.loaded['dap'] or require('dap').status() == '' then
        return nil
    end

    return string.format('%%#StatuslineDapStatus#%s  %s', icons.misc.bug, require('dap').status())
end

-- Utilities for lsp progress status
---@type table<number, {token:lsp.ProgressToken, msg:string, done:boolean}[]>
local progress = vim.defaulttable()
local spinner_frames = {
    '󰪞',
    '󰪟',
    '󰪠',
    '󰪡',
    '󰪢',
    '󰪣',
    '󰪤',
    '󰪥',
}
local spinner_index = 1

vim.api.nvim_create_autocmd('LspProgress', {
    group = vim.api.nvim_create_augroup('bugs/statusline', { clear = true }),
    desc = 'Update LSP progress in statusline',
    ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
    callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        local value = ev.data.params.value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
        if not client or type(value) ~= 'table' then
            return
        end

        local p = progress[client.id]
        for i = 1, #p + 1 do
            if i == #p + 1 or p[i].token == ev.data.params.token then
                p[i] = {
                    token = ev.data.params.token,
                    msg = ('%s%s'):format(value.title or '', value.message and (' %s'):format(value.message) or ''),
                    done = value.kind == 'end',
                }
                break
            end
        end

        progress[client.id] = vim.tbl_filter(function(v)
            return not v.done
        end, p)

        vim.cmd.redrawstatus()
    end,
})

-- Timer to animate spinner
local timer = vim.uv.new_timer()
timer:start(
    0,
    100,
    vim.schedule_wrap(function()
        spinner_index = (spinner_index % #spinner_frames) + 1
        vim.cmd.redrawstatus()
    end)
)

--- The middle status component showing LSP state or NEOVIM
---@return string
function M.lsp_status_component()
    local bufnr = vim.api.nvim_win_get_buf(vim.g.statusline_winid or 0)
    local clients = vim.lsp.get_clients { bufnr = bufnr }

    -- Check if any client has active progress
    for _, client in ipairs(clients) do
        local p = progress[client.id]
        if p and #p > 0 then
            -- Show spinner with first active message
            return string.format(
                '%%#StatuslineSpinnerRunning#%s %%#StatuslineLspClient#%s %%#StatuslineLspTitle#%s',
                spinner_frames[spinner_index],
                client.name,
                p[1].msg
            )
        end
    end

    -- No active progress - show attached client or NEOVIM
    local display_name = #clients > 0 and clients[1].name or 'NEOVIM'
    return string.format('%%#StatuslineProgressDone# %%#StatuslineLspClient#%s', display_name)
end

--- Shows DAP status when debugging, otherwise LSP status.
---@return string
function M.center_component()
    return M.dap_component() or M.lsp_status_component()
end

--- The buffer's filetype and encoding
---@return string
function M.filetype_and_encoding_component()
    local MiniIcons = require 'mini.icons'
    -- Special icons for some filetypes.
    local special_icons = {
        DiffviewFileHistory = { icons.misc.git, 'Number' },
        DiffviewFiles = { icons.misc.git, 'Number' },
        ['ccc-ui'] = { icons.misc.palette, 'Comment' },
        ['dap-view'] = { icons.misc.bug, 'Special' },
        ['grug-far'] = { icons.misc.search, 'Constant' },
        codecompanion = { icons.misc.robot, 'Conditional' },
        fzf = { icons.misc.terminal, 'Special' },
        gitcommit = { icons.misc.git, 'Number' },
        gitrebase = { icons.misc.git, 'Number' },
        lazy = { icons.symbol_kinds.Method, 'Special' },
        lazyterm = { icons.misc.terminal, 'Special' },
        minifiles = { icons.symbol_kinds.Folder, 'Directory' },
        qf = { icons.misc.search, 'Conditional' },
        lsp_renamer = { icons.misc.renamer, 'Special' },
    }
    local filetype = vim.bo.filetype
    if filetype == '' then
        filetype = '[VOID]'
    end
    local icon, icon_hl
    if special_icons[filetype] then
        icon, icon_hl = unpack(special_icons[filetype])
    else
        icon, icon_hl = MiniIcons.get('filetype', filetype)
    end
    icon_hl = M.get_or_create_hl(icon_hl)

    -- Get the file encoding and prettify it
    local encoding = vim.opt.fileencoding:get()
    local encoding_part = encoding ~= ''
            and table.concat {
                string.format('%%#StatuslineGeneralSeparator#%s', separators.slant_left),
                '%#StatuslineFiletypeAndEncodingSeparator# X ',
                string.format('%%#StatuslineGeneralSeparator#%s', separators.slant_right),
                string.format('%%#StatuslineGeneralSeparator#%s', separators.slant_left),
                '%#StatuslineEncodingIcon# 󰦝 ',
                string.format('%%#StatuslineWhite#%s ', encoding),
                string.format('%%#StatuslineGeneralSeparator#%s', separators.slant_right),
            }
        or ''

    return table.concat {
        string.format('%%#StatuslineGeneralSeparator#%s', separators.slant_left),
        string.format('%%#%s# %s %%#StatuslineWhite#%s ', icon_hl, icon, filetype),
        string.format('%%#StatuslineGeneralSeparator#%s', separators.slant_right),
        encoding_part,
    }
end

--- Two Dummy component for consistent ui look
function M.dummy_component_right()
    return string.format('%%#StatuslineGeneralSeparator#%s', separators.slant_right)
end
function M.dummy_component_left()
    return string.format('%%#StatuslineGeneralSeparator#%s%%#StatusLine#', separators.slant_left)
end

--- Diagnostic counts for the current buffer.
---@return string
function M.diagnostic_component()
    local counts = { ERROR = 0, WARN = 0, INFO = 0, HINT = 0 }

    for _, diagnostic in ipairs(vim.diagnostic.get(0)) do
        local severity = vim.diagnostic.severity[diagnostic.severity]
        if counts[severity] then
            counts[severity] = counts[severity] + 1
        end
    end

    local components = {}

    if counts.ERROR > 0 then
        table.insert(components, string.format('%%#DiagnosticError#%s %d', icons.diagnostics.ERROR, counts.ERROR))
    end
    if counts.WARN > 0 then
        table.insert(components, string.format('%%#DiagnosticWarn#%s %d', icons.diagnostics.WARN, counts.WARN))
    end
    if counts.INFO > 0 then
        table.insert(components, string.format('%%#DiagnosticInfo#%s %d', icons.diagnostics.INFO, counts.INFO))
    end
    if counts.HINT > 0 then
        table.insert(components, string.format('%%#DiagnosticHint#%s %d', icons.diagnostics.HINT, counts.HINT))
    end

    return table.concat(components, ' ')
end

--- The current line, total line count, and column position.
---@return string
function M.position_component()
    return table.concat {
        string.format('%%#StatuslineGeneralSeparator#%s', separators.slant_left),
        '%#StatuslinePositionCurrentLineNumber# %2l',
        '%#StatuslinePositionSeparator# X ',
        '%#StatuslinePositionCurrentColumnNumber#%-2c ',
        string.format('%%#StatuslineGeneralSeparator#%s', separators.slant_right),
        string.format('%%#StatuslineGeneralSeparator#%s', separators.slant_left),
        '%#StatuslinePositionPercentage# %P',
        '%#StatuslinePositionSeparator# ● ',
        '%#StatuslinePositionTotalLineCount#%L ',
        string.format('%%#StatuslineGeneralSeparator#%s', separators.slant_right),
    }
end

--- Current time
---@return string
function M.time_component()
    -- Get clock icon based on current hour
    local hour = tonumber(os.date '%H')
    local icon = CLOCK_ICONS[(hour % 12) + 1]
    local time = icon .. ' ' .. os.date '%R'

    -- Construct the bubble-like component.
    return table.concat {
        string.format('%%#StatuslineTimeSeparator#%s', separators.slant_left),
        string.format('%%#StatuslineTimeText# %s', time),
        string.format('%%#StatuslineTimeSeparator#%s', separators.block),
    }
end

--- Renders the statusline.
---@return string
function M.render()
    ---@param components string[]
    ---@return string
    local function concat_components(components)
        return vim.iter(components):skip(1):fold(components[1], function(acc, component)
            return #component > 0 and string.format('%s  %s', acc, component) or acc
        end)
    end

    return table.concat {
        concat_components {
            M.mode_component(),
            M.dummy_component_left(),
            M.git_component(),
        },
        '%#StatusLine#%=',
        M.center_component(),
        '%#StatusLine#%=',
        concat_components {
            M.diagnostic_component(),
            M.dummy_component_right(),
            M.filetype_and_encoding_component(),
            M.position_component(),
            M.time_component(),
        },
    }
end

vim.o.statusline = "%!v:lua.require'utils.status_line'.render()"

return M

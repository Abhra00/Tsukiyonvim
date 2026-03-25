-- Winbar
--- Fancy window bar that shows the current file path with document symbols

-- For convenience
local folder_icon = require('utils.icons').misc.directory

local M = {}

-- Initialize trouble statusline once at module load time.
local trouble_symbols = nil

local function get_trouble_symbols()
    if trouble_symbols then
        return trouble_symbols
    end
    local ok, trouble = pcall(require, 'trouble')
    if not ok then
        return nil
    end
    trouble_symbols = trouble.statusline {
        mode = 'lsp_document_symbols',
        groups = {},
        title = false,
        filter = { range = true },
        format = '{kind_icon}{symbol.name:Normal}',
        hl_group = 'WinBarSegmentNormal',
    }
    return trouble_symbols
end

local function trouble_component()
    local symbols = get_trouble_symbols()
    if not symbols or not symbols.has() then
        return ''
    end
    return string.format(' %%#WinbarSeparator#❯ %s', symbols.get())
end

---@return string
function M.render()
    -- Get the path and expand variables.
    local path = vim.fs.normalize(vim.fn.expand '%:p' --[[@as string]])
    -- No special styling for diff views.
    if vim.startswith(path, 'diffview') then
        return string.format('%%#Winbar#%s', path)
    end
    -- Replace slashes by arrows.
    local separator = ' %#WinbarSeparator#❯ '
    local prefix, prefix_path = '', ''
    -- If the window gets too narrow, shorten the path and drop the prefix.
    if vim.api.nvim_win_get_width(0) < math.floor(vim.o.columns / 3) then
        path = vim.fn.pathshorten(path)
    else
        -- For some special folders, add a prefix instead of the full path (making
        -- sure to pick the longest prefix).
        ---@type table<string, string>
        local special_dirs = {
            CODE = vim.g.projects_dir,
            DOTFILES = vim.env.XDG_CONFIG_HOME,
            GIT = vim.g.work_projects_dir,
            HOME = vim.env.HOME,
        }
        for dir_name, dir_path in pairs(special_dirs) do
            if vim.startswith(path, vim.fs.normalize(dir_path)) and #dir_path > #prefix_path then
                prefix, prefix_path = dir_name, dir_path
            end
        end
        if prefix ~= '' then
            path = path:gsub('^' .. vim.pesc(prefix_path), '')
            prefix = string.format('%%#WinBarDir#%s %s%s', folder_icon, prefix, separator)
        end
    end
    -- Remove leading slash.
    path = path:gsub('^/', '')
    -- Split path into segments
    local segments = vim.split(path, '/')
    local is_modified = vim.bo.modified
    -- Build the path with special styling for the filename
    local parts = {}
    for i, segment in ipairs(segments) do
        if i == #segments then
            -- Last segment (filename) - use special highlight if modified
            if is_modified then
                table.insert(parts, string.format('%%#WinBarSegmentModified#%s', segment))
            else
                table.insert(parts, string.format('%%#WinBarSegmentNormal#%s', segment))
            end
        else
            -- Directory segments
            table.insert(parts, string.format('%%#WinBarSegmentNormal#%s', segment))
        end
    end
    return table.concat {
        ' ',
        prefix,
        table.concat(parts, separator),
        trouble_component(),
    }
end

vim.api.nvim_create_autocmd('BufWinEnter', {
    group = vim.api.nvim_create_augroup('bugs/winbar', { clear = true }),
    desc = 'Attach winbar',
    callback = function(args)
        if
            not vim.api.nvim_win_get_config(0).zindex -- Not a floating window
            and vim.bo[args.buf].buftype == '' -- Normal buffer
            and vim.api.nvim_buf_get_name(args.buf) ~= '' -- Has a file name
            and not vim.wo[0].diff -- Not in diff mode
        then
            vim.wo.winbar = "%{%v:lua.require'utils.winbar'.render()%}"
        end
    end,
})

return M

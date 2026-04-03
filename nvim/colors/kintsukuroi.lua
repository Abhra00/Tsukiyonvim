-- Kintsukuroi colors

-- Reset highlighting.
vim.cmd.highlight 'clear'
if vim.fn.exists 'syntax_on' then
    vim.cmd.syntax 'reset'
end

-- Set termguicolors
vim.o.termguicolors = true

-- Set colorscheme name
vim.g.colors_name = 'kintsukuroi'

-- Define colors
local colors = {
    black = '#0b0a09',
    bg = '#141210',
    fg = '#e5c9a0',
    red = '#c06c5c',
    green = '#78997a',
    yellow = '#c09d59',
    blue = '#7f91b2',
    magenta = '#b380b0',
    cyan = '#7b9695',
    white = '#d8be97',
    grey = '#4d463e',
    bright_red = '#d97a68',
    bright_green = '#85b695',
    bright_yellow = '#d8b164',
    bright_blue = '#a3a9ce',
    bright_magenta = '#cf9bc2',
    bright_cyan = '#89b3b6',
    bright_white = '#f2d5a9',
    pink = '#d88095',
    orange = '#d8834c',
    warm_green = '#afc060',
    rose = '#c2556a',
    flared_grey = '#725639',
    visual = '#322720',
    gutter_fg = '#5a4e45',
    comment = '#5a5147',
    nontext = '#3f3933',
    selection = '#26221e',
    transparent_black = '#322d28',
    transparent_cyan = '#2e3b3c',
    transparent_green = '#2d3c31',
    transparent_red = '#4b2a24',
    transparent_yellow = '#473a21',
    transparent_pink = '#4a2c32',
}

-- Terminal colors
vim.g.terminal_color_0 = colors.transparent_black
vim.g.terminal_color_1 = colors.red
vim.g.terminal_color_2 = colors.green
vim.g.terminal_color_3 = colors.yellow
vim.g.terminal_color_4 = colors.blue
vim.g.terminal_color_5 = colors.magenta
vim.g.terminal_color_6 = colors.cyan
vim.g.terminal_color_7 = colors.white
vim.g.terminal_color_8 = colors.grey
vim.g.terminal_color_9 = colors.bright_red
vim.g.terminal_color_10 = colors.bright_green
vim.g.terminal_color_11 = colors.bright_yellow
vim.g.terminal_color_12 = colors.bright_blue
vim.g.terminal_color_13 = colors.bright_magenta
vim.g.terminal_color_14 = colors.bright_cyan
vim.g.terminal_color_15 = colors.bright_white
vim.g.terminal_color_background = colors.bg
vim.g.terminal_color_foreground = colors.fg

-- Groups used for my sexy statusline.
---@type table<string, vim.api.keyset.highlight>
local statusline_groups = {}
for mode, color in pairs {
    Normal = 'blue',
    Pending = 'rose',
    Visual = 'yellow',
    Insert = 'green',
    Command = 'cyan',
    Other = 'orange',
} do
    statusline_groups['StatuslineMode' .. mode] = { fg = colors.black, bg = colors[color] }
    statusline_groups['StatuslineModeSeparator' .. mode] = { fg = colors[color], bg = colors.bg }
end
statusline_groups = vim.tbl_extend('error', statusline_groups, {
    StatuslineGeneralSeparator = { fg = colors.transparent_black, bg = colors.bg },
    StatuslineWhite = { fg = colors.bright_white, bg = colors.transparent_black },
    StatuslineComment = { fg = colors.gutter_fg, bg = colors.transparent_black },
    StatuslineDapStatus = { fg = colors.orange, bg = colors.transparent_black },
    StatuslineSpinnerRunning = { fg = colors.bright_red, bg = colors.transparent_black, bold = true },
    StatuslineProgressDone = { fg = colors.warm_green, bg = colors.transparent_black, bold = true },
    StatuslineLspClient = { fg = colors.cyan, bg = colors.transparent_black, bold = true },
    StatuslineLspTitle = { fg = colors.grey, bg = colors.transparent_black, italic = true },
    StatuslineGitBranch = { fg = colors.blue, bg = colors.transparent_black },
    StatuslineGitAdded = { fg = colors.green, bg = colors.transparent_black },
    StatuslineGitChanged = { fg = colors.yellow, bg = colors.transparent_black },
    StatuslineGitRemoved = { fg = colors.red, bg = colors.transparent_black },
    StatuslineFiletypeAndEncodingSeparator = { fg = colors.red, bg = colors.transparent_black, bold = true },
    StatuslineEncodingIcon = { fg = colors.pink, bg = colors.transparent_black },
    StatuslinePositionSeparator = { fg = colors.grey, bg = colors.transparent_black, bold = true },
    StatuslinePositionCurrentLineNumber = { fg = colors.red, bg = colors.transparent_black, bold = true },
    StatuslinePositionCurrentColumnNumber = { fg = colors.cyan, bg = colors.transparent_black, bold = true },
    StatuslinePositionTotalLineCount = { fg = colors.warm_green, bg = colors.transparent_black, bold = true },
    StatuslinePositionPercentage = { fg = colors.blue, bg = colors.transparent_black, bold = true },
    StatuslineTimeSeparator = { fg = colors.orange, bg = colors.bg },
    StatuslineTimeText = { fg = colors.black, bg = colors.orange },
})

-- Set highlights
---@type table<string, vim.api.keyset.highlight>
local groups = vim.tbl_extend('error', statusline_groups, {
    -- Builtins.
    Boolean = { fg = colors.cyan },
    Character = { fg = colors.green },
    ColorColumn = { bg = colors.selection },
    Comment = { fg = colors.comment, italic = true },
    Conceal = { fg = colors.comment },
    Conditional = { fg = colors.magenta },
    Constant = { fg = colors.yellow },
    CurSearch = { fg = colors.black, bg = colors.pink },
    Cursor = { fg = colors.black, bg = colors.white },
    CursorColumn = { bg = colors.transparent_black },
    CursorLine = { bg = colors.selection },
    CursorLineNr = { fg = colors.flared_grey, bold = true },
    Define = { fg = colors.blue },
    Directory = { fg = colors.cyan },
    EndOfBuffer = { fg = colors.bg },
    Error = { fg = colors.bright_red },
    ErrorMsg = { fg = colors.bright_red },
    FloatBorder = { fg = colors.comment, bg = colors.bg },
    FoldColumn = { fg = colors.comment, bg = colors.bg },
    Folded = { bg = colors.transparent_black },
    Function = { fg = colors.bright_green },
    Identifier = { fg = colors.cyan },
    IncSearch = { link = 'CurSearch' },
    Include = { fg = colors.blue },
    Keyword = { fg = colors.magenta },
    Label = { fg = colors.cyan },
    LineNr = { fg = colors.flared_grey },
    Macro = { fg = colors.blue },
    MatchParen = { sp = colors.fg, underline = true },
    NonText = { fg = colors.nontext },
    Normal = { fg = colors.fg, bg = colors.bg },
    NormalFloat = { fg = colors.fg, bg = colors.bg },
    Number = { fg = colors.orange },
    Pmenu = { fg = colors.white, bg = colors.bg },
    PmenuSbar = { bg = colors.transparent_yellow },
    PmenuSel = { fg = colors.cyan, bg = colors.selection },
    PmenuThumb = { bg = colors.selection },
    PreCondit = { fg = colors.cyan },
    PreProc = { fg = colors.yellow },
    Question = { fg = colors.blue },
    Repeat = { fg = colors.magenta },
    Search = { fg = colors.bg, bg = colors.orange },
    SignColumn = { bg = colors.bg },
    Special = { fg = colors.rose },
    SpecialComment = { fg = colors.comment, italic = true },
    SpecialKey = { fg = colors.nontext },
    SpellBad = { sp = colors.bright_red, underline = true },
    SpellCap = { sp = colors.yellow, underline = true },
    SpellLocal = { sp = colors.yellow, underline = true },
    SpellRare = { sp = colors.yellow, underline = true },
    Statement = { fg = colors.blue },
    StatusLine = { fg = colors.white, bg = colors.transparent_black },
    StorageClass = { fg = colors.magenta },
    String = { fg = colors.yellow },
    Structure = { fg = colors.yellow },
    Substitute = { fg = colors.pink, bg = colors.transparent_pink },
    Title = { fg = colors.cyan },
    Todo = { fg = colors.blue, bold = true },
    Type = { fg = colors.cyan },
    TypeDef = { fg = colors.yellow },
    Underlined = { fg = colors.cyan, underline = true },
    VertSplit = { fg = colors.white },
    Visual = { bg = colors.visual },
    VisualNOS = { fg = colors.visual },
    WarningMsg = { fg = colors.yellow },
    WildMenu = { fg = colors.transparent_black, bg = colors.white },

    -- Treesitter.
    -- Identifiers
    ['@variable'] = { fg = colors.fg },
    ['@variable.builtin'] = { fg = colors.blue },
    ['@variable.parameter'] = { fg = colors.orange },
    ['@variable.parameter.builtin'] = { fg = colors.bright_blue },
    ['@variable.member'] = { fg = colors.orange },

    -- Constants
    ['@constant'] = { fg = colors.bright_yellow },
    ['@constant.builtin'] = { fg = colors.bright_yellow },
    ['@constant.macro'] = { fg = colors.yellow },

    -- Modules
    ['@module'] = { fg = colors.orange },
    ['@module.builtin'] = { fg = colors.bright_blue },
    ['@label'] = { fg = colors.cyan },

    -- Literals
    ['@string'] = { fg = colors.yellow },
    ['@string.documentation'] = { fg = colors.yellow },
    ['@string.regexp'] = { fg = colors.bright_red },
    ['@string.escape'] = { fg = colors.rose },
    ['@string.special'] = { fg = colors.rose },
    ['@string.special.symbol'] = { fg = colors.rose },
    ['@string.special.path'] = { fg = colors.yellow },
    ['@string.special.url'] = { fg = colors.yellow, underline = true },
    ['@character'] = { fg = colors.green },
    ['@character.special'] = { fg = colors.rose },
    ['@boolean'] = { fg = colors.bright_blue },
    ['@number'] = { fg = colors.orange },
    ['@number.float'] = { fg = colors.bright_green },

    -- Types
    ['@type'] = { fg = colors.bright_cyan },
    ['@type.builtin'] = { fg = colors.cyan },
    ['@type.definition'] = { fg = colors.bright_cyan },
    ['@type.qualifier'] = { fg = colors.magenta },
    ['@attribute'] = { fg = colors.cyan },
    ['@attribute.builtin'] = { fg = colors.cyan },
    ['@property'] = { fg = colors.blue },

    -- Functions
    ['@function'] = { fg = colors.bright_green },
    ['@function.builtin'] = { fg = colors.cyan },
    ['@function.call'] = { fg = colors.bright_green },
    ['@function.macro'] = { fg = colors.warm_green },
    ['@function.method'] = { fg = colors.bright_green },
    ['@function.method.call'] = { fg = colors.bright_green },
    ['@constructor'] = { fg = colors.cyan },
    ['@operator'] = { fg = colors.magenta },

    -- Keywords
    ['@keyword'] = { fg = colors.magenta },
    ['@keyword.coroutine'] = { fg = colors.magenta },
    ['@keyword.function'] = { fg = colors.cyan },
    ['@keyword.operator'] = { fg = colors.magenta },
    ['@keyword.import'] = { fg = colors.blue },
    ['@keyword.type'] = { fg = colors.magenta },
    ['@keyword.modifier'] = { fg = colors.magenta },
    ['@keyword.repeat'] = { fg = colors.magenta },
    ['@keyword.return'] = { fg = colors.rose },
    ['@keyword.debug'] = { fg = colors.rose },
    ['@keyword.exception'] = { fg = colors.rose },
    ['@keyword.conditional'] = { fg = colors.magenta },
    ['@keyword.conditional.ternary'] = { fg = colors.magenta },
    ['@keyword.directive'] = { fg = colors.blue },
    ['@keyword.directive.define'] = { fg = colors.blue },
    -- Legacy keyword captures
    ['@keyword.include'] = { fg = colors.blue },
    ['@keyword.function.ruby'] = { fg = colors.cyan },

    -- Punctuation
    ['@punctuation.delimiter'] = { fg = colors.fg },
    ['@punctuation.bracket'] = { fg = colors.fg },
    ['@punctuation.special'] = { fg = colors.cyan },

    -- Comments
    ['@comment'] = { fg = colors.comment, italic = true },
    ['@comment.documentation'] = { fg = colors.comment, italic = true },
    ['@comment.error'] = { fg = colors.bright_red, bold = true },
    ['@comment.warning'] = { fg = colors.yellow, bold = true },
    ['@comment.todo'] = { fg = colors.cyan, bold = true },
    ['@comment.note'] = { fg = colors.green, bold = true },

    -- Markup (markdown, rst, etc.) — prose context, italics appropriate here
    ['@markup'] = { fg = colors.orange },
    ['@markup.strong'] = { fg = colors.orange, bold = true },
    ['@markup.italic'] = { fg = colors.yellow, italic = true },
    ['@markup.strikethrough'] = { fg = colors.comment, strikethrough = true },
    ['@markup.underline'] = { fg = colors.rose, underline = true },
    ['@markup.heading'] = { fg = colors.magenta, bold = true, italic = true },
    ['@markup.heading.1'] = { fg = colors.magenta, bold = true, italic = true },
    ['@markup.heading.2'] = { fg = colors.blue, bold = true, italic = true },
    ['@markup.heading.3'] = { fg = colors.cyan, bold = true, italic = true },
    ['@markup.heading.4'] = { fg = colors.green, bold = true, italic = true },
    ['@markup.heading.5'] = { fg = colors.yellow, bold = true, italic = true },
    ['@markup.heading.6'] = { fg = colors.orange, bold = true, italic = true },
    ['@markup.quote'] = { fg = colors.comment, italic = true },
    ['@markup.math'] = { fg = colors.blue },
    ['@markup.environment'] = { fg = colors.magenta },
    ['@markup.environment.name'] = { fg = colors.cyan },
    ['@markup.link'] = { fg = colors.orange, bold = true },
    ['@markup.link.label'] = { fg = colors.blue },
    ['@markup.link.url'] = { fg = colors.yellow, underline = true },
    ['@markup.raw'] = { fg = colors.yellow },
    ['@markup.raw.block'] = { fg = colors.yellow },
    ['@markup.list'] = { fg = colors.cyan },
    ['@markup.list.checked'] = { fg = colors.warm_green },
    ['@markup.list.unchecked'] = { fg = colors.comment },

    -- Diff
    ['@diff.plus'] = { fg = colors.green },
    ['@diff.minus'] = { fg = colors.red },
    ['@diff.delta'] = { fg = colors.yellow },

    -- Tags (HTML, JSX, etc.)
    ['@tag'] = { fg = colors.cyan },
    ['@tag.builtin'] = { fg = colors.cyan },
    ['@tag.attribute'] = { fg = colors.green },
    ['@tag.delimiter'] = { fg = colors.cyan },

    -- Misc
    ['@error'] = { fg = colors.bright_red },
    ['@annotation'] = { fg = colors.yellow },
    ['@structure'] = { fg = colors.blue },
    ['@parameter.reference'] = { fg = colors.orange },
    ['@none'] = {},

    -- Semantic tokens.
    ['@lsp.type.class'] = { fg = colors.bright_cyan },
    ['@lsp.type.comment'] = { fg = colors.comment, italic = true },
    ['@lsp.type.decorator'] = { fg = colors.warm_green },
    ['@lsp.type.enum'] = { fg = colors.bright_cyan },
    ['@lsp.type.enumMember'] = { fg = colors.bright_yellow },
    ['@lsp.type.function'] = { fg = colors.bright_green },
    ['@lsp.type.interface'] = { fg = colors.bright_cyan },
    ['@lsp.type.keyword'] = { fg = colors.magenta },
    ['@lsp.type.macro'] = { fg = colors.warm_green },
    ['@lsp.type.method'] = { fg = colors.bright_green },
    ['@lsp.type.modifier'] = { fg = colors.magenta },
    ['@lsp.type.namespace'] = { fg = colors.orange },
    ['@lsp.type.number'] = { fg = colors.orange },
    ['@lsp.type.operator'] = { fg = colors.magenta },
    ['@lsp.type.parameter'] = { fg = colors.orange },
    ['@lsp.type.property'] = { fg = colors.blue },
    ['@lsp.type.regexp'] = { fg = colors.bright_red },
    ['@lsp.type.string'] = { fg = colors.yellow },
    ['@lsp.type.struct'] = { fg = colors.bright_cyan },
    ['@lsp.type.type'] = { fg = colors.bright_cyan },
    ['@lsp.type.typeParameter'] = { fg = colors.cyan },
    ['@lsp.type.variable'] = { fg = colors.fg },
    -- Semantic token modifiers
    ['@lsp.typemod.function.defaultLibrary'] = { fg = colors.cyan },
    ['@lsp.typemod.variable.defaultLibrary'] = { fg = colors.blue },
    ['@lsp.typemod.variable.readonly'] = { fg = colors.bright_yellow },
    ['@lsp.typemod.keyword.async'] = { fg = colors.magenta },
    -- Legacy semantic captures
    ['@class'] = { fg = colors.bright_cyan },
    ['@decorator'] = { fg = colors.warm_green },
    ['@enum'] = { fg = colors.bright_cyan },
    ['@enumMember'] = { fg = colors.bright_yellow },
    ['@event'] = { fg = colors.cyan },
    ['@interface'] = { fg = colors.bright_cyan },
    ['@modifier'] = { fg = colors.magenta },
    ['@regexp'] = { fg = colors.bright_red },
    ['@struct'] = { fg = colors.bright_cyan },
    ['@typeParameter'] = { fg = colors.cyan },

    -- LSP.
    DiagnosticDeprecated = { strikethrough = true, fg = colors.fg },
    DiagnosticError = { fg = colors.red },
    DiagnosticFloatingError = { fg = colors.red },
    DiagnosticFloatingHint = { fg = colors.cyan },
    DiagnosticFloatingInfo = { fg = colors.cyan },
    DiagnosticFloatingWarn = { fg = colors.yellow },
    DiagnosticHint = { fg = colors.cyan },
    DiagnosticInfo = { fg = colors.cyan },
    DiagnosticUnderlineError = { undercurl = true, sp = colors.red },
    DiagnosticUnderlineHint = { undercurl = true, sp = colors.cyan },
    DiagnosticUnderlineInfo = { undercurl = true, sp = colors.cyan },
    DiagnosticUnderlineWarn = { undercurl = true, sp = colors.yellow },
    DiagnosticUnnecessary = { fg = colors.grey },
    DiagnosticVirtualTextError = { fg = colors.red, bg = colors.transparent_red },
    DiagnosticVirtualTextHint = { fg = colors.cyan, bg = colors.transparent_cyan },
    DiagnosticVirtualTextInfo = { fg = colors.cyan, bg = colors.transparent_cyan },
    DiagnosticVirtualTextWarn = { fg = colors.yellow, bg = colors.transparent_yellow },
    DiagnosticWarn = { fg = colors.yellow },
    LspCodeLens = { fg = colors.cyan, underline = true },
    LspFloatWinBorder = { fg = colors.comment },
    LspInlayHint = { fg = colors.rose, italic = true },
    LspReferenceRead = { bg = colors.transparent_cyan },
    LspReferenceText = {},
    LspReferenceWrite = { bg = colors.transparent_red },
    LspSignatureActiveParameter = { bold = true, underline = true, sp = colors.fg },

    -- Lsp renamer
    LspRenamerTitle = { fg = colors.black, bg = colors.red },
    LspRenamerNormal = { bg = colors.bg },
    LspRenamerBorder = { fg = colors.red },

    -- Diffs.
    DiffAdd = { fg = colors.green, bg = colors.transparent_green },
    DiffChange = { fg = colors.white, bg = colors.transparent_yellow },
    DiffDelete = { fg = colors.red, bg = colors.transparent_red },
    DiffText = { fg = colors.orange, bg = colors.transparent_yellow, bold = true },
    DiffviewFolderSign = { fg = colors.cyan },
    DiffviewNonText = { fg = colors.flared_grey },
    diffAdded = { fg = colors.bright_green, bold = true },
    diffChanged = { fg = colors.bright_yellow, bold = true },
    diffRemoved = { fg = colors.bright_red, bold = true },

    -- Command line.
    MoreMsg = { fg = colors.bright_white, bold = true },
    MsgArea = { fg = colors.cyan },
    MsgSeparator = { fg = colors.flared_grey },

    -- Winbar styling.
    WinBar = { fg = colors.fg, bg = colors.transparent_black },
    WinBarNC = { fg = colors.fg, bg = colors.transparent_black },
    WinBarSegmentNormal = { bg = colors.transparent_black, fg = colors.bright_white },
    WinBarSegmentModified = { bg = colors.transparent_black, fg = colors.bright_red, bold = true },
    WinBarDir = { fg = colors.orange, bg = colors.transparent_black },
    WinBarSeparator = { fg = colors.rose, bg = colors.transparent_black },

    -- Quickfix window.
    QuickFixLine = { italic = true, bg = colors.transparent_red },

    -- Yankflash.
    Yankflash = { bg = colors.orange, fg = colors.black },

    -- Alpha
    AlphaButtons = { fg = colors.magenta },
    AlphaShortcut = { fg = colors.orange },
    AlphaHeader = { fg = colors.cyan },
    AlphaFooter = { fg = colors.yellow, italic = true },

    -- Blink cmp
    BlinkCmpKindClass = { link = '@type' },
    BlinkCmpKindColor = { link = 'DevIconCss' },
    BlinkCmpKindConstant = { link = '@constant' },
    BlinkCmpKindConstructor = { link = '@type' },
    BlinkCmpKindEnum = { link = '@variable.member' },
    BlinkCmpKindEnumMember = { link = '@variable.member' },
    BlinkCmpKindEvent = { link = '@constant' },
    BlinkCmpKindField = { link = '@variable.member' },
    BlinkCmpKindFile = { link = 'Directory' },
    BlinkCmpKindFolder = { link = 'Directory' },
    BlinkCmpKindFunction = { link = '@function' },
    BlinkCmpKindInterface = { link = '@type' },
    BlinkCmpKindKeyword = { link = '@keyword' },
    BlinkCmpKindMethod = { link = '@function.method' },
    BlinkCmpKindModule = { link = '@module' },
    BlinkCmpKindOperator = { link = '@operator' },
    BlinkCmpKindProperty = { link = '@property' },
    BlinkCmpKindReference = { link = '@parameter.reference' },
    BlinkCmpKindSnippet = { link = '@markup' },
    BlinkCmpKindStruct = { link = '@structure' },
    BlinkCmpKindText = { link = '@markup' },
    BlinkCmpKindTypeParameter = { link = '@variable.parameter' },
    BlinkCmpKindUnit = { link = '@variable.member' },
    BlinkCmpKindValue = { link = '@variable.member' },
    BlinkCmpKindVariable = { link = '@variable' },
    BlinkCmpLabelDeprecated = { link = 'DiagnosticDeprecated' },
    BlinkCmpLabelDescription = { fg = colors.grey, italic = true },
    BlinkCmpLabelDetail = { fg = colors.grey, bg = colors.bg },
    BlinkCmpMenu = { bg = colors.bg },
    BlinkCmpMenuBorder = { bg = colors.bg },

    -- Bufferline.
    BufferLineBufferSelected = { bg = colors.bg, underline = true, sp = colors.blue },
    BufferLineFill = { bg = colors.bg },
    TabLine = { fg = colors.comment, bg = colors.bg },
    TabLineFill = { bg = colors.bg },
    TabLineSel = { bg = colors.blue },

    -- Fzf_lua
    FzfLuaBorder = { fg = colors.comment, bg = colors.bg },
    FzfLuaCursor = { link = 'IncSearch' },
    FzfLuaDirPart = { link = 'Comment' },
    FzfLuaFilePart = { link = 'FzfLuaFzfNormal' },
    FzfLuaFzfCursorLine = { link = 'Visual' },
    FzfLuaFzfInfo = { fg = colors.pink },
    FzfLuaFzfMatch = { fg = colors.orange },
    FzfLuaFzfNormal = { fg = colors.fg },
    FzfLuaFzfPointer = { fg = colors.orange },
    FzfLuaFzfPrompt = { fg = colors.orange, bg = colors.bg },
    FzfLuaFzfSeparator = { fg = colors.comment, bg = colors.bg },
    FzfLuaCmdBuf = { fg = colors.cyan },
    FzfLuaBufId = { fg = colors.comment },
    FzfLuaBufFlagAlt = { fg = colors.cyan },
    FzfLuaBufFlagCur = { fg = colors.rose },
    FzfLuaHeaderBind = { fg = colors.warm_green, italic = true },
    FzfLuaHeaderText = { link = 'Title' },
    FzfLuaNormal = { fg = colors.fg, bg = colors.bg },
    FzfLuaPath = { link = 'Directory' },
    FzfLuaPathColNr = { fg = colors.orange },
    FzfLuaPreviewTitle = { fg = colors.rose, bg = colors.bg },
    FzfLuaTitle = { fg = colors.orange, bg = colors.bg },

    -- Gitsigns.
    GitSignsAdd = { fg = colors.bright_green },
    GitSignsChange = { fg = colors.cyan },
    GitSignsCurrentLineBlame = { fg = colors.rose },
    GitSignsDelete = { fg = colors.bright_red },
    GitSignsStagedAdd = { fg = colors.orange },
    GitSignsStagedChange = { fg = colors.orange },
    GitSignsStagedDelete = { fg = colors.orange },

    -- Grugfar.
    GrugFarHelpHeader = { fg = colors.comment },
    GrugFarHelpHeaderKey = { fg = colors.warm_green, italic = true },
    GrugFarInputLabel = { fg = colors.blue },
    GrugFarInputPlaceholder = { fg = colors.flared_grey },
    GrugFarResultsChangeIndicator = { fg = colors.yellow },
    GrugFarResultsHeader = { fg = colors.orange },
    GrugFarResultsLineColumn = { fg = colors.flared_grey },
    GrugFarResultsLineNo = { fg = colors.grey },
    GrugFarResultsMatch = { fg = colors.black, bg = colors.red },
    GrugFarResultsStats = { fg = colors.blue },

    -- Indent-blankline.
    IblScope = { fg = colors.magenta, bold = true },

    -- Lazy.
    LazyDimmed = { fg = colors.grey },

    -- Mini-hipatterns.
    MiniHipatternsFixme = { bg = colors.rose, fg = colors.black },
    MiniHipatternsHack = { bg = colors.pink, fg = colors.black },
    MiniHipatternsTodo = { bg = colors.orange, fg = colors.black },
    MiniHipatternsNote = { bg = colors.warm_green, fg = colors.black },

    -- Mini-icons.
    MiniIconsGrey = { fg = colors.fg },
    MiniIconsPurple = { fg = colors.bright_magenta },
    MiniIconsBlue = { fg = colors.bright_blue },
    MiniIconsAzure = { fg = colors.warm_green },
    MiniIconsCyan = { fg = colors.cyan },
    MiniIconsGreen = { fg = colors.green },
    MiniIconsYellow = { fg = colors.yellow },
    MiniIconsOrange = { fg = colors.orange },
    MiniIconsRed = { fg = colors.red },

    -- Mini-trailspace.
    MiniTrailspace = { fg = colors.red, bg = colors.transparent_red },

    -- Treesitter-context
    TreesitterContextBottom = { underline = true, sp = colors.flared_grey },

    -- Trouble
    TroubleText = { fg = colors.comment },
    TroubleCount = { fg = colors.cyan, bg = colors.transparent_cyan },
    TroubleNormal = { fg = colors.fg, bg = colors.bg },

    -- Which-key
    WhichKey = { fg = colors.cyan },
    WhichKeyGroup = { fg = colors.orange },
    WhichKeyDesc = { fg = colors.magenta },
    WhichKeySeparator = { fg = colors.comment },
    WhichKeyValue = { fg = colors.comment },
})

for group, opts in pairs(groups) do
    vim.api.nvim_set_hl(0, group, opts)
end

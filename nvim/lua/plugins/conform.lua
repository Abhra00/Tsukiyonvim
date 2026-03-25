-- Conform
-- Auto formatting.
return {
    'stevearc/conform.nvim',
    event = 'BufWritePre',
    opts = {
        -- Leave me alone.
        notify_on_error = false,
        notify_no_formatters = false,
        formatters_by_ft = {
            c = { 'clang-format', timeout_ms = 500, lsp_format = 'fallback' },
            cpp = { 'clang-format', timeout_ms = 500, lsp_format = 'fallback' },
            css = { 'prettier' },
            html = { 'prettier', name = 'dprint', timeout_ms = 500, lsp_format = 'fallback' },
            javascript = { 'prettier', name = 'dprint', timeout_ms = 500, lsp_format = 'fallback' },
            javascriptreact = { 'prettier', name = 'dprint', timeout_ms = 500, lsp_format = 'fallback' },
            json = { 'prettier', name = 'dprint', timeout_ms = 500, lsp_format = 'fallback' },
            jsonc = { 'prettier', name = 'dprint', timeout_ms = 500, lsp_format = 'fallback' },
            less = { 'prettier' },
            lua = { 'stylua' },
            markdown = { 'prettier' },
            python = { 'ruff_organize_imports', 'ruff_format', timeout_ms = 500, lsp_format = 'fallback' },
            rust = { name = 'rust_analyzer', timeout_ms = 500, lsp_format = 'prefer' },
            scss = { 'prettier' },
            sh = { 'shfmt' },
            typescript = { 'prettier', name = 'dprint', timeout_ms = 500, lsp_format = 'fallback' },
            typescriptreact = { 'prettier', name = 'dprint', timeout_ms = 500, lsp_format = 'fallback' },
            yaml = { 'prettier' },
            ['_'] = { 'trim_whitespace', 'trim_newlines' },
        },
        format_on_save = function()
            -- Skip formatting if triggered from my special save command.
            if vim.g.skip_formatting then
                vim.g.skip_formatting = false
                return nil
            end

            -- Stop if we disabled auto-formatting.
            if not vim.g.autoformat then
                return nil
            end

            return {}
        end,
        formatters = {
            -- Require a Prettier configuration file to format.
            prettier = { require_cwd = true },
        },
    },
    init = function()
        -- Use conform for gq.
        vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

        -- Start auto-formatting by default (and disable with my ToggleFormat command).
        vim.g.autoformat = true
    end,
}

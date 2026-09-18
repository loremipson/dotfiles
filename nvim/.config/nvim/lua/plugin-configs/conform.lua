local M = {}

function M.setup()
  local conform = require 'conform'

  -- Returns the first available formatter from the candidates list.
  -- Used to pick one formatter from a fallback chain.
  local function first(bufnr, ...)
    local args = { ... }
    for _, formatter in ipairs(args) do
      if conform.get_formatter_info(formatter, bufnr).available then
        return formatter
      end
    end
    return args[1]
  end

  vim.api.nvim_create_autocmd('BufWritePre', {
    group = vim.api.nvim_create_augroup('eslint_fix_on_save', { clear = true }),
    pattern = { '*.ts', '*.tsx', '*.js', '*.jsx', '*.vue', '*.svelte', '*.astro' },
    callback = function()
      local clients = vim.lsp.get_clients { bufnr = 0, name = 'eslint' }
      if #clients > 0 and vim.fn.exists ':LspEslintFixAll' == 2 then
        vim.cmd 'LspEslintFixAll'
      end
    end,
  })

  conform.setup {
    formatters_by_ft = {
      lua = { 'stylua' },
      -- Use the first available Prettier-compatible formatter.
      javascript = function(bufnr)
        return { first(bufnr, 'oxfmt', 'prettierd', 'prettier') }
      end,
      typescript = function(bufnr)
        return { first(bufnr, 'oxfmt', 'prettierd', 'prettier') }
      end,
      javascriptreact = function(bufnr)
        return { first(bufnr, 'oxfmt', 'prettierd', 'prettier') }
      end,
      typescriptreact = function(bufnr)
        return { first(bufnr, 'oxfmt', 'prettierd', 'prettier') }
      end,
      vue = function(bufnr)
        return { first(bufnr, 'oxfmt', 'prettierd', 'prettier') }
      end,
      astro = function(bufnr)
        return { first(bufnr, 'oxfmt', 'prettierd', 'prettier') }
      end,
      svelte = function(bufnr)
        return { first(bufnr, 'oxfmt', 'prettierd', 'prettier') }
      end,
      html = function(bufnr)
        return { first(bufnr, 'oxfmt', 'prettierd', 'prettier') }
      end,
      css = { 'oxfmt', 'prettierd', 'prettier', stop_after_first = true },
      scss = { 'oxfmt', 'prettierd', 'prettier', stop_after_first = true },
      json = { 'oxfmt', 'prettierd', 'prettier', stop_after_first = true },
      jsonc = { 'oxfmt', 'prettierd', 'prettier', stop_after_first = true },
      yaml = { 'oxfmt', 'prettierd', 'prettier', stop_after_first = true },
      markdown = { 'oxfmt', 'prettierd', 'prettier', stop_after_first = true },
      graphql = { 'oxfmt', 'prettierd', 'prettier', stop_after_first = true },
      rust = function(bufnr)
        local formatters = { 'rustfmt' }
        local root = vim.fs.root(bufnr, { 'Dioxus.toml' })
        if root then
          table.insert(formatters, 'dxfmt')
        end
        return formatters
      end,
      python = { 'ruff_format', 'ruff_organize_imports' },
      go = { 'goimports', 'gofumpt' },
    },
    formatters = {
      dxfmt = {
        command = 'dx',
        args = { 'fmt', '--file', '$FILENAME' },
        stdin = false,
        availability_check = function()
          return vim.fn.executable 'dx' == 1
        end,
      },
    },
    format_on_save = { timeout_ms = 2500, lsp_format = 'fallback' },
  }

  vim.keymap.set({ 'n', 'v' }, '<leader>F', function()
    conform.format { timeout_ms = 2500, lsp_format = 'fallback' }
  end, { desc = 'Format file or range (in visual mode)' })
end

return M

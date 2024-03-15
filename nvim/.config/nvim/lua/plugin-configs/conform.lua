local M = {}

function M.setup()
  local conform = require 'conform'

  conform.setup {
    formatters_by_ft = {
      lua = { 'stylua' },
      javascript = { { 'eslint_d', 'prettierd' } },
      typescript = { { 'eslint_d', 'prettierd' } },
      javascriptreact = { { 'eslint_d', 'prettierd' }, 'rustywind' },
      typescriptreact = { { 'eslint_d', 'prettierd' }, 'rustywind' },
      svelte = { 'prettierd' },
      go = { 'gofumpt', 'goimports-reviser', 'golines' },
      css = { 'prettierd' },
      scss = { 'prettierd' },
      html = { 'prettierd', 'rustywind' },
      json = { 'prettierd' },
      jsonc = { 'prettierd' },
      yaml = { 'prettierd' },
      markdown = { 'prettierd' },
      graphql = { 'prettierd' },
    },
    format_on_save = { async = false, timeout_ms = 500, lsp_fallback = true },
  }

  vim.keymap.set('', '<leader>f', function()
    conform.format { async = false, timeout_ms = 500, lsp_fallback = true }
  end, { desc = 'Format file or range (in visual mode)' })

  -- Optionally, set the formatexpr
  vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
end

return M

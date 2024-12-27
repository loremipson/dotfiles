local M = {}

function M.setup()
  local conform = require 'conform'

  conform.setup {
    formatters_by_ft = {
      lua = { 'stylua' },
      javascript = { 'prettierd' },
      typescript = { 'prettierd' },
      javascriptreact = { 'prettierd' },
      typescriptreact = { 'prettierd' },
      vue = { 'prettierd' },
      astro = { 'prettierd' },
      svelte = { 'prettierd' },
      go = { 'gofumpt', 'goimports-reviser' },
      css = { 'prettierd' },
      scss = { 'prettierd' },
      html = { 'prettierd' },
      json = { 'prettierd' },
      jsonc = { 'prettierd' },
      yaml = { 'prettierd' },
      markdown = { 'prettierd' },
      graphql = { 'prettierd' },
    },
    -- formatters = {
    --   rustywind = {
    --     command = 'rustywind',
    --     args = { '--stdin', '--custom-regex', 'cva%([^)]*[\'"]([^\'"]+)[\'"][^)]*%)' },
    --   },
    -- },
    format_on_save = { async = false, timeout_ms = 500, lsp_fallback = true },
  }

  vim.keymap.set('', '<leader>F', function()
    conform.format { async = false, timeout_ms = 500, lsp_fallback = true }
  end, { desc = 'Format file or range (in visual mode)' })

  -- Optionally, set the formatexpr
  vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
end

return M

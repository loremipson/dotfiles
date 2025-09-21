local M = {}

function M.setup()
  local conform = require 'conform'

  conform.setup {
    formatters_by_ft = {
      lua = { 'stylua' },
      javascript = { 'prettierd', 'prettier', stop_after_first = true },
      typescript = { 'prettierd', 'prettier', stop_after_first = true },
      javascriptreact = { 'prettierd', 'prettier', stop_after_first = true },
      typescriptreact = { 'prettierd', 'prettier', stop_after_first = true },
      vue = { 'prettierd', 'prettier' },
      astro = { 'prettierd', 'prettier' },
      svelte = { 'prettierd', 'prettier' },
      go = { 'gofumpt', 'goimports-reviser' },
      css = { 'prettierd', 'prettier' },
      scss = { 'prettierd', 'prettier' },
      html = { 'prettierd', 'prettier' },
      json = { 'prettierd', 'prettier' },
      jsonc = { 'prettierd', 'prettier' },
      yaml = { 'prettierd', 'prettier' },
      markdown = { 'prettierd', 'prettier' },
      graphql = { 'prettierd', 'prettier' },
    },
    -- formatters = {
    --   rustywind = {
    --     command = 'rustywind',
    --     args = { '--stdin', '--custom-regex', 'cva%([^)]*[\'"]([^\'"]+)[\'"][^)]*%)' },
    --   },
    -- },
    format_on_save = { timeout_ms = 2500, lsp_format = 'fallback' },
  }

  vim.keymap.set({ 'n', 'v' }, '<leader>F', function()
    conform.format { timeout_ms = 2500, lsp_format = 'fallback' }
  end, { desc = 'Format file or range (in visual mode)' })
end

return M

local M = {}

function M.setup()
  local conform = require 'conform'

  conform.setup {
    formatters_by_ft = {
      lua = { 'stylua' },
      javascript = { 'oxfmt', 'prettierd', 'prettier', stop_after_first = true },
      typescript = { 'oxfmt', 'prettierd', 'prettier', stop_after_first = true },
      javascriptreact = { 'oxfmt', 'prettierd', 'prettier', stop_after_first = true },
      typescriptreact = { 'oxfmt', 'prettierd', 'prettier', stop_after_first = true },
      vue = { 'oxfmt', 'prettierd', 'prettier' },
      astro = { 'oxfmt', 'prettierd', 'prettier' },
      svelte = { 'oxfmt', 'prettierd', 'prettier' },
      css = { 'oxfmt', 'prettierd', 'prettier' },
      scss = { 'oxfmt', 'prettierd', 'prettier' },
      html = { 'oxfmt', 'prettierd', 'prettier' },
      json = { 'oxfmt', 'prettierd', 'prettier' },
      jsonc = { 'oxfmt', 'prettierd', 'prettier' },
      yaml = { 'oxfmt', 'prettierd', 'prettier' },
      markdown = { 'oxfmt', 'prettierd', 'prettier' },
      graphql = { 'oxfmt', 'prettierd', 'prettier' },
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

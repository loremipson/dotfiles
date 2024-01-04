local M = {}

function M.setup()
  vim.keymap.set('', '<leader>f', function()
    require('conform').format { async = true, lsp_fallback = true }
  end, { desc = 'Format file or range (in visual mode)' })

  require('conform').setup {
    formatters_by_ft = {
      lua = { 'stylua' },
      javascript = { { 'eslint_d', 'prettierd' } },
      typescript = { { 'eslint_d', 'prettierd' } },
      javascriptreact = { { 'eslint_d', 'prettierd' } },
      typescriptreact = { { 'eslint_d', 'prettierd' } },
      svelte = { 'prettierd' },
      go = { 'gofumpt', 'goimports-reviser', 'golines' },
      css = { 'prettierd' },
      html = { 'prettierd' },
      json = { 'prettierd' },
      yaml = { 'prettierd' },
      markdown = { 'prettierd' },
      graphql = { 'prettierd' },
    },
    format_on_save = { timeout_ms = 500, lsp_fallback = true },
    formatters = {
      shfmt = { prepend_args = { '-i', '2' } },
    },
  }

  -- Optionally, set the formatexpr
  vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
end

return M

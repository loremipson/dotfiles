local M = {}

function M.setup()
  local conform = require 'conform'

  -- Returns the first available formatter from the candidates list.
  -- Used to pick one formatter from a fallback chain and then append
  -- additional formatters (e.g. rustywind) that must always run after.
  local function first(bufnr, ...)
    local args = { ... }
    for _, formatter in ipairs(args) do
      if conform.get_formatter_info(formatter, bufnr).available then
        return formatter
      end
    end
    return args[1]
  end

  conform.setup {
    formatters_by_ft = {
      lua = { 'stylua' },
      -- Use first available prettier-variant, then always run rustywind to sort classes
      javascript = function(bufnr) return { first(bufnr, 'oxfmt', 'prettierd', 'prettier'), 'rustywind' } end,
      typescript = function(bufnr) return { first(bufnr, 'oxfmt', 'prettierd', 'prettier'), 'rustywind' } end,
      javascriptreact = function(bufnr) return { first(bufnr, 'oxfmt', 'prettierd', 'prettier'), 'rustywind' } end,
      typescriptreact = function(bufnr) return { first(bufnr, 'oxfmt', 'prettierd', 'prettier'), 'rustywind' } end,
      vue = function(bufnr) return { first(bufnr, 'oxfmt', 'prettierd', 'prettier'), 'rustywind' } end,
      astro = function(bufnr) return { first(bufnr, 'oxfmt', 'prettierd', 'prettier'), 'rustywind' } end,
      svelte = function(bufnr) return { first(bufnr, 'oxfmt', 'prettierd', 'prettier'), 'rustywind' } end,
      html = function(bufnr) return { first(bufnr, 'oxfmt', 'prettierd', 'prettier'), 'rustywind' } end,
      -- No class sorting needed for these
      css = { 'oxfmt', 'prettierd', 'prettier', stop_after_first = true },
      scss = { 'oxfmt', 'prettierd', 'prettier', stop_after_first = true },
      json = { 'oxfmt', 'prettierd', 'prettier', stop_after_first = true },
      jsonc = { 'oxfmt', 'prettierd', 'prettier', stop_after_first = true },
      yaml = { 'oxfmt', 'prettierd', 'prettier', stop_after_first = true },
      markdown = { 'oxfmt', 'prettierd', 'prettier', stop_after_first = true },
      graphql = { 'oxfmt', 'prettierd', 'prettier', stop_after_first = true },
    },
    formatters = {
      rustywind = {
        prepend_args = { '--stdin' },
      },
    },
    -- formatters = {
    --   rustywind = {
    --     command = 'rustywind',
    --     args = { '--stdin', '--custom-regex', 'cva%([^)]*[\'"]([^\'"]+)[\'"][^)]*%)' },
    --   },
    -- },
    format_on_save = { timeout_ms = 2500, lsp_format = 'fallback' },
  }

  -- Run eslint --fix before the formatter on save, but only if eslint LSP is active
  vim.api.nvim_create_autocmd('BufWritePre', {
    pattern = { '*.ts', '*.tsx', '*.js', '*.jsx', '*.vue', '*.svelte', '*.astro' },
    callback = function()
      local clients = vim.lsp.get_clients { bufnr = 0, name = 'eslint' }
      if #clients > 0 and vim.fn.exists ':EslintFixAll' == 2 then
        vim.cmd 'EslintFixAll'
      end
    end,
  })

  vim.keymap.set({ 'n', 'v' }, '<leader>F', function()
    conform.format { timeout_ms = 2500, lsp_format = 'fallback' }
  end, { desc = 'Format file or range (in visual mode)' })
end

return M

local M = {}

function M.setup()
  local lint = require 'lint'

  lint.linters_by_ft = {
    markdown = { 'vale' },
    javascript = { 'eslint' },
    typescript = { 'eslint' },
    javascriptreact = { 'eslint' },
    typescriptreact = { 'eslint' },
    svelte = { 'eslint' },
    vue = { 'eslint' },
    astro = { 'eslint' },
  }

  local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })

  vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
    group = lint_augroup,
    callback = function()
      lint.try_lint()
    end,
  })

  vim.keymap.set('n', '<leader>L', function()
    lint.try_lint()
  end, { desc = 'Trigger linting for current file' })
end

return M

local M = {}

function M.setup()
  local lint = require 'lint'

  lint.linters_by_ft = {
    markdown = { 'vale' },
    javascript = { 'eslint_d' },
    typescript = { 'eslint_d' },
    typescriptreact = { 'eslint_d' },
    svelte = { 'eslint_d' },
  }

  vim.api.nvim_create_autocmd({ 'BufEnter' }, {
    callback = function()
      lint.try_lint()
    end,
  })

  vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
    callback = function()
      lint.try_lint()
    end,
  })
end

return M

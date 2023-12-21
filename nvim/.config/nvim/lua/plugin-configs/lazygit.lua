local M = {}

function M.setup()
  local key = vim.keymap.set

  key('n', '<leader>gg', '<cmd>LazyGit<CR>', {})
end

return M

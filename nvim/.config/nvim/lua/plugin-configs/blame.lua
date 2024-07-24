local M = {}

function M.setup()
  local key = vim.keymap.set

  key('n', '<leader>b', '<cmd>ToggleBlame<CR>', {})
end

return M

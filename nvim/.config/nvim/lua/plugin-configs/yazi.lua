local M = {}

function M.setup()
  if vim.fn.executable('yazi') == 0 then
    return
  end
  local key = vim.keymap.set
  key({ 'n', 'v' }, '-', '<cmd>Yazi<CR>', {})
  vim.g.loaded_netrwPlugin = 1

  require('yazi').setup {
    open_for_directories = true,
  }
end

return M

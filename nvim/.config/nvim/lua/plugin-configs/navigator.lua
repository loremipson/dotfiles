local M = {}
local key = vim.keymap.set

function M.setup()
  require('Navigator').setup {
    auto_save = 'current',
  }
  key('n', '<C-h>', '<CMD>NavigatorLeft<CR>')
  key('n', '<C-l>', '<CMD>NavigatorRight<CR>')
  key('n', '<C-k>', '<CMD>NavigatorUp<CR>')
  key('n', '<C-j>', '<CMD>NavigatorDown<CR>')
end

return M

local M = {}
local key = vim.keymap.set

function M.setup()
  local function navigate(command)
    return function()
      vim.cmd(command)
      vim.cmd.redrawstatus()
    end
  end

  require('Navigator').setup {
    auto_save = 'current',
  }
  key('n', '<C-h>', navigate('NavigatorLeft'))
  key('n', '<C-l>', navigate('NavigatorRight'))
  key('n', '<C-k>', navigate('NavigatorUp'))
  key('n', '<C-j>', navigate('NavigatorDown'))
end

return M

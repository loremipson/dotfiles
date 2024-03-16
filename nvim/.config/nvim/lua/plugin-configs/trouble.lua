local M = {}

function M.setup()
  local trouble = require 'trouble'
  local key = vim.keymap.set

  trouble.setup {}

  key('n', '<leader>xx', function()
    trouble.toggle()
  end)
  key('n', '<leader>xw', function()
    trouble.toggle 'workspace_diagnostics'
  end)
  key('n', '<leader>xd', function()
    trouble.toggle 'document_diagnostics'
  end)
  key('n', '<leader>xq', function()
    trouble.toggle 'quickfix'
  end)
  key('n', '<leader>xl', function()
    trouble.toggle 'loclist'
  end)
  key('n', 'gR', function()
    trouble.toggle 'lsp_references'
  end)
end

return M

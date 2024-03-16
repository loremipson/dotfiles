local M = {}

function M.setup()
  local neotest = require 'neotest'
  local key = vim.keymap.set

  neotest.setup {
    adapters = {
      require 'neotest-vitest',
    },
  }

  key('n', '<leader>t', neotest.run.run)
  key('n', '<leader>T', function()
    neotest.run.run(vim.fn.expand '%')
  end)
end

return M

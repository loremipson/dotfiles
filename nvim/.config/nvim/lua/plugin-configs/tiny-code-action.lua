local M = {}

function M.setup()
  require('tiny-code-action').setup {
    backend = 'vim',
    picker = 'snacks',
  }
end

return M

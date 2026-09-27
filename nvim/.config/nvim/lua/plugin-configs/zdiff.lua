local M = {}

function M.setup()
  require('zdiff').setup {
    default_expanded = false,
    default_branch = 'main',
    syntax = {
      mode = 'projection', -- uses existing treesitter parsers for diff highlighting
    },
  }
end

return M

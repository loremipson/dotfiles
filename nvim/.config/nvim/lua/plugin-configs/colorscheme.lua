local M = {}

function M.setup()
  -- colorscheme is intended to be picked via <leader>cs, not hardcoded here
  require('util.theme-picker').load()
end

return M

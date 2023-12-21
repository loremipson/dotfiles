local M = {}

function M.setup()
  require('rose-pine').setup {
    dark_variant = 'moon',
  }
  vim.cmd 'colorscheme rose-pine'
end

return M

local M = {}

function M.setup()
  require('tiny-inline-diagnostic').setup {
    preset = 'modern',
    options = {
      multilines = {
        enabled = true,
      },
      show_source = {
        enabled = false,
      },
    },
  }

  vim.diagnostic.config { virtual_text = false }
end

return M

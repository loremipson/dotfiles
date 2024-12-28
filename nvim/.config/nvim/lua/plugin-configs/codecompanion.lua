local M = {}

function M.setup()
  local cc = require 'codecompanion'
  local key = vim.keymap.set

  cc.setup {
    strategies = {
      chat = {
        adapter = 'anthropic',
      },
      inline = {
        adapter = 'anthropic',
      },
    },
  }

  key('n', '<leader>cc', '<cmd>CodeCompanionChat<CR>', { desc = 'Code companion chat' })
  key('n', '<leader>ci', '<cmd>CodeCompanionInline<CR>', { desc = 'Code companion inline' })
  key('v', '<leader>ce', '', {
    desc = 'Code companion explain',
    callback = function()
      cc.prompt 'explain'
    end,
  })
end

return M

local M = {}

function M.setup()
  local cc = require 'codecompanion'
  local key = vim.keymap.set

  -- Load default configuration
  local default_config = require('defaults').config

  -- Try to load user configuration with explicit path checking
  local config_path = vim.fn.stdpath('config') .. '/config.lua'
  local user_config = {}
  
  if vim.fn.filereadable(config_path) == 1 then
    user_config = dofile(config_path)
  end

  local config = vim.tbl_deep_extend('force', default_config, user_config)

  cc.setup(config)

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

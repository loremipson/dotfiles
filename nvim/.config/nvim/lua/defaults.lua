local M = {}

M.config = {
  strategies = {
    chat = {
      adapter = 'anthropic',
    },
    inline = {
      adapter = 'anthropic',
    },
  },
  adapters = {
    anthropic = function()
      return require('codecompanion.adapters').extend('anthropic', {
        env = {
          api_key = nil, -- require config
        },
      })
    end,
  },
}

return M

local M = {}
function M.setup()
  local opencode = require 'opencode'
  local key = vim.keymap.set

  vim.g.opencode_opts = {
    provider = {
      enabled = 'tmux',
      tmux = {},
    },
  }

  key({ 'n', 'x' }, '<leader>oa', function()
    opencode.ask('@this: ', { submit = true })
  end, { desc = 'Ask opencode' })

  key({ 'n', 'x' }, '<leader>ox', function()
    opencode.select()
  end, { desc = 'Execute opencode action' })

  key({ 'n', 'x' }, 'go', function()
    return opencode.operator '@this '
  end, { desc = 'Add range to opencode' })
  key('n', 'goo', function()
    return opencode.operator '@this ' .. '_'
  end, { desc = 'Add line to opencode' })

  key('n', '<leader>ou', function()
    opencode.command 'session.half.page.up'
  end, { desc = 'Opencode half page up' })
  key('n', '<leader>od', function()
    opencode.command 'session.half.page.down'
  end, { desc = 'Opencode half page down' })
end

return M

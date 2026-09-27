local M = {}

function M.setup()
  local opencode = require 'opencode'
  local key = vim.keymap.set

  vim.g.opencode_opts = {
    server = {
      enabled = 'tmux',
      tmux = {},
    },
  }

  vim.o.autoread = true

  key({ 'n', 'x' }, '<leader>oa', function()
    opencode.ask('@this: ')
  end, { desc = 'Ask opencode' })

  key({ 'n', 'x' }, '<leader>os', function()
    opencode.select()
  end, { desc = 'Select opencode...' })

  key({ 'n', 'x' }, 'go', function()
    return opencode.operator('@this ')
  end, { desc = 'Add range to opencode', expr = true })

  key('n', 'goo', function()
    return opencode.operator('@this ') .. '_'
  end, { desc = 'Add line to opencode', expr = true })

  key('n', '<S-C-u>', function()
    opencode.command('session.half.page.up')
  end, { desc = 'Scroll opencode up' })

  key('n', '<S-C-d>', function()
    opencode.command('session.half.page.down')
  end, { desc = 'Scroll opencode down' })
end

return M

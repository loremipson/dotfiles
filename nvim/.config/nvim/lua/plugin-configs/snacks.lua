local M = {}
function M.setup()
  local snacks = require 'snacks'
  snacks.setup {
    options = {
      indent = { enabled = true },
      lazygit = { enabled = true },
      scroll = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
    },
  }

  vim.keymap.set('n', '<leader>.', function()
    snacks.scratch()
  end, { desc = 'Toggle scratch buffer' })

  vim.keymap.set('n', '<leader>n', function()
    snacks.notifier.show_history()
  end, { desc = 'Notification history' })

  vim.keymap.set('n', '<leader>un', function()
    snacks.notifier.hide()
  end, { desc = 'Dismiss all notifications' })

  vim.keymap.set('n', '<leader>gf', function()
    snacks.lazygit.log_file()
  end, { desc = 'Lazygit current file history' })

  vim.keymap.set('n', '<leader>gg', function()
    snacks.lazygit()
  end, { desc = 'Lazygit' })

  vim.keymap.set('n', '<leader>gl', function()
    snacks.lazygit.log()
  end, { desc = 'Lazygit log (cmd)' })

  vim.api.nvim_create_autocmd('User', {
    pattern = 'VeryLazy',
    callback = function()
      -- Global debug helpers
      _G.dd = function(...)
        snacks.debug.inspect(...)
      end
      _G.bt = function()
        snacks.debug.backtrace()
      end
      vim.print = _G.dd -- Makes the `:=` command use snacks for output

      -- Toggle mappings with their descriptions
      snacks.toggle.option('spell', { name = 'Spelling' }):map '<leader>us'
      snacks.toggle.option('wrap', { name = 'Wrap' }):map '<leader>uw'
      snacks.toggle.option('relativenumber', { name = 'Relative Number' }):map '<leader>uL'
      snacks.toggle.diagnostics():map '<leader>ud'
      snacks.toggle.line_number():map '<leader>ul'
      snacks.toggle
        .option('conceallevel', {
          off = 0,
          on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2,
        })
        :map '<leader>uc'
      snacks.toggle.treesitter():map '<leader>uT'
      snacks.toggle
        .option('background', {
          off = 'light',
          on = 'dark',
          name = 'Dark Background',
        })
        :map '<leader>ub'
      snacks.toggle.inlay_hints():map '<leader>uh'
      snacks.toggle.indent():map '<leader>ug'
      snacks.toggle.dim():map '<leader>uD'
    end,
  })
end
return M

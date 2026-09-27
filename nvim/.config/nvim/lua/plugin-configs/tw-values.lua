local M = {}

function M.setup()
  require('tw-values').setup {
    border = 'rounded',
    show_unknown_classes = true,
    focus_preview = false,
    copy_register = '',
    keymaps = {
      copy = '<C-y>',
    },
  }

  vim.keymap.set('n', '<leader>lt', '<cmd>TWValues<cr>', { desc = 'Show Tailwind CSS values' })
end

return M

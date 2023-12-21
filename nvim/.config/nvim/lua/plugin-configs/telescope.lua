local M = {}

function M.setup()
  local builtin = require 'telescope.builtin'
  local key = vim.keymap.set

  key('n', '<C-p>', builtin.find_files, {})
  key('n', '<leader>ff', builtin.find_files, {})
  key('n', '<leader>fg', builtin.live_grep, {})
  key('n', '<leader>fb', builtin.buffers, {})
  key('n', '<leader>fh', builtin.help_tags, {})
end

return M

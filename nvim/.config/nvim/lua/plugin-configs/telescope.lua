local M = {}

function M.setup()
  local telescope = require('telescope')
  local actions = require('telescope.actions')
  local builtin = require('telescope.builtin')
  local key = vim.keymap.set

  telescope.setup({
    defaults = {
      mappings = {
        i = {
          ['<C-k>'] = actions.move_selection_previous,
          ['<C-j>'] = actions.move_selection_next,
          ['<C-q>'] = actions.send_selected_to_qflist + actions.open_qflist,
        }
      }
    }
  })

  telescope.load_extension('fzf')

  key('n', '<C-p>', builtin.find_files, { desc = 'Fuzzy find files in cwd' })
  key('n', '<leader>ff', builtin.find_files, { desc = 'Fuzzy find files in cwd' })
  key('n', '<leader>fg', builtin.live_grep, { desc = 'Fuzzy grep in cwd' })
  key('n', '<leader>fb', builtin.buffers, { desc = 'Fuzzy find buffers' })
  key('n', '<leader>fh', builtin.help_tags, { desc = 'Fuzzy find help tags' })
end

return M

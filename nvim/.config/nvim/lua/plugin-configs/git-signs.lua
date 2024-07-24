local M = {}

function M.setup()
  local gitsigns = require 'gitsigns'
  local key = vim.keymap.set

  gitsigns.setup {
    key('n', '<leader>hs', gitsigns.stage_hunk, { desc = 'Stage hunk' }),
    key('n', '<leader>hr', gitsigns.reset_hunk, { desc = 'Reset hunk' }),
    key('v', '<leader>hs', function()
      gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
    end, { desc = 'Stage hunk' }),
    key('v', '<leader>hr', function()
      gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
    end, { desc = 'Reset hunk' }),
    -- key('n', '<leader>hb', gitsigns.stage_buffer, { desc = 'Stage buffer' }),
    key('n', '<leader>hu', gitsigns.undo_stage_hunk, { desc = 'Undo stage hunk' }),
    key('n', '<leader>hR', gitsigns.reset_buffer, { desc = 'Reset buffer' }),
    key('n', '<leader>hp', gitsigns.preview_hunk, { desc = 'Preview hunk' }),
    key('n', '<leader>hb', function()
      gitsigns.blame_line { full = true }
    end, { desc = 'Blame line' }),
    key('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = 'Toggle blame line' }),
    key('n', '<leader>hd', gitsigns.diffthis, { desc = 'Diff this' }),
    key('n', '<leader>hD', function()
      gitsigns.diffthis '~'
    end, { desc = 'Diff this.. tilde?' }),
    key('n', '<leader>td', gitsigns.toggle_deleted, { desc = 'Toggle deleted' }),
  }
end

return M

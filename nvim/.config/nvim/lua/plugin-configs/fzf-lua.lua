local M = {}

function M.setup()
  local fzf = require 'fzf-lua'
  local key = vim.keymap.set

  fzf.setup {}

  key('n', '<leader>ff', "<cmd>lua require('fzf-lua').files({ hidden = true, git_ignored = false })<CR>", { desc = 'Fuzzy find files in cwd' })
  key('n', '<leader>fg', "<cmd>lua require('fzf-lua').live_grep()<CR>", { desc = 'Fuzzy grep in cwd' })
  key('n', '<leader>fb', "<cmd>lua require('fzf-lua').buffers()<CR>", { desc = 'Fuzzy find buffers' })
  key('n', '<leader>fh', "<cmd>lua require('fzf-lua').help_tags()<CR>", { desc = 'Fuzzy find help tags' })
  key('n', '<leader>fr', "<cmd>lua require('fzf-lua').resume()<CR>", { desc = 'Resume the last fzf search' })
  key('n', '<leader>fs', "<cmd>lua require('fzf-lua').lsp_document_symbols()<CR>", { desc = 'Fuzzy find symbols in current buffer' })
  key('n', '<leader>fc', "<cmd>lua require('fzf-lua').git_bcommits()<CR>", { desc = 'Fuzzy find git commits' })
  key('n', '<leader>fa', "<cmd>lua require('fzf-lua').lsp_code_actions()<CR>", { desc = 'Fuzzy find code actions' })
end

return M

local M = {}

function M.setup()
  require('hlslens').setup {
    calm_down = true,
    nearest_only = true,
  }

  local opts = { noremap = true, silent = true }

  vim.keymap.set('n', 'n', [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]], opts)
  vim.keymap.set('n', 'N', [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]], opts)
  vim.keymap.set('n', '*', [[*<Cmd>lua require('hlslens').start()<CR>]], opts)
  vim.keymap.set('n', '#', [[#<Cmd>lua require('hlslens').start()<CR>]], opts)
  vim.keymap.set('n', 'g*', [[g*<Cmd>lua require('hlslens').start()<CR>]], opts)
  vim.keymap.set('n', 'g#', [[g#<Cmd>lua require('hlslens').start()<CR>]], opts)
end

return M

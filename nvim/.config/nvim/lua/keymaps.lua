vim.g.mapleader = ' '

vim.keymap.set('i', 'jj', '<Esc>')

-- Suppress pointless written file message entirely
vim.keymap.set('ca', 'w', function()
  return (vim.fn.getcmdtype() == ':' and vim.fn.getcmdline() == 'w') and 'silent write' or 'w'
end, { expr = true })

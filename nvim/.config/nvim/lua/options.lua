local options = {
  -- ui
  cursorline = true, -- highlight current line
  relativenumber = true, -- show relative line numbers
  number = true, -- enable current line number for "hybrid"
  splitright = true, -- new vertical splits will open to the right of the current one
  splitbelow = true, -- new splits will be placed below the current one
  cmdheight = 1, -- more space in the command line for displaying messages
  showmode = false, -- we don't need to see things like -- INSERT -- anymore
  signcolumn = 'yes', -- always show the sign column, otherwise it would shift the text each time
  scrolloff = 8, -- scroll when you are 8 lines away from the top/bottom
  sidescrolloff = 8, -- same as above, but for columns

  laststatus = 3, -- global statusline instead of just the current window

  -- indenting
  expandtab = true,
  tabstop = 2,
  softtabstop = 2,
  shiftwidth = 2,
  smarttab = true,
  smartindent = true,

  -- search
  hlsearch = true, -- highlight search results
  ignorecase = true, -- case insensitive searching
  smartcase = true,

  clipboard = 'unnamed,unnamedplus', -- copy to system clipboard
  swapfile = false, -- no swap files
  backup = false, -- no backup files

  completeopt = 'menu,menuone,noselect', -- better completion for menus
  pumheight = 10, -- max number of entries in the completion menus
}

vim.opt.shortmess:append 'c' -- don't show redundant completion messages
vim.opt.shortmess:append 'I' -- don't show 'Insert mode' messages
vim.opt.whichwrap:append '<,>,[,],h,l' -- allow horizontal/vertical movement

for k, v in pairs(options) do
  vim.opt[k] = v
end

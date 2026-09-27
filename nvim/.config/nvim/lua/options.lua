local options = {
  -- ui
  termguicolors = true,  -- enable 24-bit color
  updatetime = 200,      -- make things that use `CursorHold` feel more responsive
  cursorline = true,     -- highlight current line
  relativenumber = true, -- show relative line numbers
  number = true,         -- enable current line number for "hybrid"
  splitright = true,     -- new vertical splits will open to the right of the current one
  splitbelow = true,     -- new splits will be placed below the current one
  showmode = false,      -- we don't need to see things like -- INSERT -- anymore
  signcolumn = 'yes',    -- always show the sign column, otherwise it would shift the text each time
  scrolloff = 8,         -- scroll when you are 8 lines away from the top/bottom
  sidescrolloff = 8,     -- same as above, but for columns
  winborder = 'rounded', -- rounded borders
  confirm = true,        -- prompt user with unsaved changes instead of erroring
  cmdheight = 0,         -- hide the message area unless typing a command
  laststatus = 3,        -- global statusline instead of just the current window

  -- indenting
  expandtab = true,
  tabstop = 2,
  softtabstop = 2,
  shiftwidth = 2,
  smarttab = true,
  smartindent = true,
  autoindent = true,
  wrap = false,
  breakindent = true,

  -- search
  hlsearch = true,   -- highlight search results
  ignorecase = true, -- case insensitive searching
  smartcase = true,

  clipboard = 'unnamed,unnamedplus',     -- copy to system clipboard
  swapfile = false,                      -- no swap files
  backup = false,                        -- no backup files
  undofile = true,                       -- persist undo across sessions
  autoread = true,                       -- auto reload a file if it changes on disk outside of nvim
  inccommand = 'split',                  -- show substitutions as you type before you hit enter
  timeoutlen = 300,                      -- make which-key feel snappier

  completeopt = 'menu,menuone,noselect', -- better completion for menus
  pumheight = 10,                        -- max number of entries in the completion menus
}

for k, v in pairs(options) do
  vim.opt[k] = v
end

vim.opt.shortmess:append 'W'           -- don't show "written" when saving
vim.opt.shortmess:append 'F'           -- don't show file info when opening a file
vim.opt.shortmess:append 'c'           -- don't show completion menu messages
vim.opt.shortmess:append 'C'           -- don't show "scanning..." during completion
vim.opt.shortmess:append 'I'           -- don't show the intro screen on startup
vim.opt.shortmess:append 's'           -- don't show "search hit BOTTOM"
vim.opt.whichwrap:append '<,>,[,],h,l' -- let h/l and arrow keys wrap to prev/next line

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

-- Statusline

-- Called on every statusline redraw. Returns the fully-rendered statusline
-- string with inline highlight groups.
function _G.build_statusline()
  local parts = {}

  -- Branch name
  local branch = vim.b.gitsigns_head or ''
  if branch ~= '' then
    parts[#parts + 1] = '%#Special#  ' .. branch .. ' '
  end

  -- Git diff: only emit non-zero counts, each in its sign colour
  local status = vim.b.gitsigns_status or ''
  local added = status:match '%+(%d+)'
  local changed = status:match '~(%d+)'
  local deleted = status:match '%-(%d+)'
  if added then
    parts[#parts + 1] = '%#GitSignsAdd# +' .. added .. ' '
  end
  if changed then
    parts[#parts + 1] = '%#GitSignsChange#~' .. changed .. ' '
  end
  if deleted then
    parts[#parts + 1] = '%#GitSignsDelete#-' .. deleted .. ' '
  end

  -- Filename + modified flag
  parts[#parts + 1] = '%#StatusLine# %f %m'

  -- Right-align
  parts[#parts + 1] = '%='

  -- Diagnostics: icon + count, only shown when non-zero
  local errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
  local warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
  local icon_error = vim.fn.nr2char(0xe009) -- nf-seti-error (  )
  local icon_warn = vim.fn.nr2char(0xf421) -- nf-fa-exclamation_circle (  )
  if errors > 0 then
    parts[#parts + 1] = '%#DiagnosticError# ' .. icon_error .. ' ' .. errors .. ' '
  end
  if warnings > 0 then
    parts[#parts + 1] = '%#DiagnosticWarn# ' .. icon_warn .. ' ' .. warnings .. ' '
  end

  -- Line:col + scroll position
  parts[#parts + 1] = '%#Comment# %l:%c  %P '

  return table.concat(parts)
end

vim.o.statusline = '%!v:lua.build_statusline()'

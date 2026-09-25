local icons = require('icons')

local api = vim.api
local fn = vim.fn

-- mode() char -> { label, accent key }
local modes = {
  n = { 'N', 'normal' },
  i = { 'I', 'insert' },
  v = { 'V', 'visual' },
  V = { 'VL', 'visual' },
  ['\22'] = { 'VB', 'visual' }, -- Ctrl-v
  s = { 'S', 'visual' },
  S = { 'SL', 'visual' },
  ['\19'] = { 'SB', 'visual' }, -- Ctrl-s
  c = { 'C', 'command' },
  R = { 'R', 'replace' },
  t = { 'T', 'terminal' },
}

-- accent key -> highlight group whose fg color is used for that mode
local accents = {
  normal = 'Function',
  insert = 'String',
  visual = 'Number',
  command = 'Constant',
  replace = 'DiagnosticError',
  terminal = 'Type',
}

-- Statusline segment groups. Each takes its fg from `src` and gets the
-- mode-tinted background, so the whole bar shifts color together.
local segments = {
  StlBranch = { src = 'Special' },
  StlAdd = { src = 'GitSignsAdd' },
  StlChange = { src = 'GitSignsChange' },
  StlDelete = { src = 'GitSignsDelete' },
  StlError = { src = 'DiagnosticError' },
  StlWarn = { src = 'DiagnosticWarn' },
  StlMuted = { src = 'Comment' },
  StlModified = { src = 'DiagnosticWarn', italic = true },
  StlLock = { src = 'DiagnosticError' },
  StlRecording = { src = 'DiagnosticError', bold = true },
}

-- How strongly the mode color tints the statusline background (0 to 1)
local TINT = 0.18

local base = {}      -- colors captured from the colorscheme before we modify them
local recording = '' -- register currently being recorded to

local function hl(name)
  return api.nvim_get_hl(0, { name = name, link = false })
end

local function current_mode()
  return modes[fn.mode()] or { fn.mode(), 'normal' }
end

-- Mix color a into color b. t = 0 gives b, t = 1 gives a.
local function blend(a, b, t)
  if not a or not b then
    return b
  end
  local function split(c)
    return math.floor(c / 65536) % 256, math.floor(c / 256) % 256, c % 256
  end
  local ar, ag, ab = split(a)
  local br, bg, bb = split(b)
  local function mix(x, y)
    return math.floor(x * t + y * (1 - t) + 0.5)
  end
  return mix(ar, br) * 65536 + mix(ag, bg) * 256 + mix(ab, bb)
end

-- Grab the colorscheme's original colors. Only runs on colorscheme load,
-- because apply() overwrites StatusLine and CursorLineNr afterwards.
local function capture()
  local sl, normal = hl('StatusLine'), hl('Normal')
  base.fg = sl.fg or normal.fg
  base.bg = sl.bg or normal.bg
  base.dark = normal.bg or sl.bg or 0x000000 -- text color on top of accent blocks
  base.clnr_bg = hl('CursorLineNr').bg
  base.winbar_bg = hl('WinBar').bg
end

-- Rebuild every mode-dependent highlight for the current mode
local function apply()
  local key = current_mode()[2]
  local accent = hl(accents[key]).fg
  local bg = key == 'normal' and base.bg or blend(accent, base.bg, TINT)
  local set = function(name, opts)
    api.nvim_set_hl(0, name, opts)
  end

  set('StatusLine', { fg = base.fg, bg = bg })
  set('StlFile', { fg = base.fg, bg = bg })
  set('StlMode', { fg = base.dark, bg = accent, bold = true })
  set('StlModeEdge', { fg = accent, bg = bg })

  for name, o in pairs(segments) do
    set(name, { fg = hl(o.src).fg, bg = bg, italic = o.italic, bold = o.bold })
  end

  -- Current line number and cursor follow the mode color
  set('CursorLineNr', { fg = accent, bg = base.clnr_bg, bold = true })
  set('StlCursor', { fg = base.dark, bg = accent })

  set('WinBarModified', { fg = hl('DiagnosticWarn').fg, bg = base.winbar_bg, italic = true })
end

function _G.build_statusline()
  local parts = {}
  local function add(s)
    parts[#parts + 1] = s
  end

  -- Mode pill
  local m = current_mode()
  add('%#StlMode# ' .. m[1] .. ' %#StatusLine# ')

  -- Macro recording
  if recording ~= '' then
    add('%#StlRecording#● @' .. recording .. ' ')
  end

  -- Branch name (escape % so it isn't read as a format item)
  local branch = vim.b.gitsigns_head or ''
  if branch ~= '' then
    add('%#StlBranch#' .. icons.git.branch .. ' ' .. branch:gsub('%%', '%%%%') .. ' ')
  end

  -- Git diff: only emit non-zero counts
  local status = vim.b.gitsigns_status or ''
  local added = status:match '%+(%d+)'
  local changed = status:match '~(%d+)'
  local deleted = status:match '%-(%d+)'
  if added then
    add('%#StlAdd#+' .. added .. ' ')
  end
  if changed then
    add('%#StlChange#~' .. changed .. ' ')
  end
  if deleted then
    add('%#StlDelete#-' .. deleted .. ' ')
  end

  -- Filename: italic and warning-colored when unsaved
  add((vim.bo.modified and '%#StlModified#' or '%#StlFile#') .. ' %f ')
  if vim.bo.readonly or not vim.bo.modifiable then
    add('%#StlLock#' .. icons.ui.lock .. ' ')
  end

  add('%#StatusLine#%=')

  -- Attached LSP clients
  local clients = {}
  for _, c in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
    clients[#clients + 1] = c.name
  end
  if #clients > 0 then
    add('%#StlMuted#' .. icons.ui.lsp .. ' ' .. table.concat(clients, ', ') .. ' ')
  end

  -- Diagnostics
  local errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
  local warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
  if errors > 0 then
    add('%#StlError#' .. icons.diagnostics.ERROR .. ' ' .. errors .. ' ')
  end
  if warnings > 0 then
    add('%#StlWarn#' .. icons.diagnostics.WARN .. ' ' .. warnings .. ' ')
  end

  -- Line:col + scroll position
  add('%#StlMuted# %l:%c  %P ')

  return table.concat(parts)
end

-- Autocmds
local group = api.nvim_create_augroup('Statusline', { clear = true })

api.nvim_create_autocmd('ColorScheme', {
  group = group,
  callback = function()
    capture()
    apply()
  end,
})

api.nvim_create_autocmd('ModeChanged', {
  group = group,
  callback = function()
    apply()
    vim.cmd.redrawstatus()
  end,
})

-- Track recording ourselves, since reg_recording() still returns the
-- register during RecordingLeave
api.nvim_create_autocmd('RecordingEnter', {
  group = group,
  callback = function()
    recording = fn.reg_recording()
    vim.cmd.redrawstatus()
  end,
})

api.nvim_create_autocmd('RecordingLeave', {
  group = group,
  callback = function()
    recording = ''
    vim.cmd.redrawstatus()
  end,
})

api.nvim_create_autocmd({ 'LspAttach', 'LspDetach' }, {
  group = group,
  callback = function()
    -- scheduled because the detaching client is still listed during LspDetach
    vim.schedule(function()
      vim.cmd.redrawstatus()
    end)
  end,
})

-- Cursor shape per mode, colored by the current mode accent
vim.opt.guicursor = 'n-v-c-sm:block-StlCursor,i-ci-ve:ver25-StlCursor,r-cr-o:hor20-StlCursor'

-- Init
capture()
apply()
vim.o.statusline = '%!v:lua.build_statusline()'

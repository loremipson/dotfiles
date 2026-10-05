local icons = require('icons')

local api = vim.api
local fn = vim.fn

local mode_icon = fn.nr2char(0xe6ae)

-- mode() char -> accent key
local modes = {
  n = 'normal',
  i = 'insert',
  v = 'visual',
  V = 'visual',
  ['\22'] = 'visual', -- Ctrl-v
  s = 'visual',
  S = 'visual',
  ['\19'] = 'visual', -- Ctrl-s
  c = 'command',
  R = 'replace',
  t = 'terminal',
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
  StlBranch = { src = 'Statement' },
  StlAdd = { src = 'GitSignsAdd' },
  StlChange = { src = 'GitSignsChange' },
  StlDelete = { src = 'GitSignsDelete' },
  StlError = { src = 'DiagnosticError' },
  StlWarn = { src = 'DiagnosticWarn' },
  StlMuted = { src = 'Comment' },
  StlLock = { src = 'DiagnosticError' },
  StlRecording = { src = 'DiagnosticError', bold = true },
}

-- How strongly the mode color tints the statusline background (0 to 1)
local TINT = 0.18
local FILE_BG_OPACITY = 0.5

local base = {}      -- colors captured from the colorscheme before we modify them
local recording = '' -- register currently being recorded to
local search_generation = 0

local function hl(name)
  return api.nvim_get_hl(0, { name = name, link = false })
end

local function current_mode()
  return modes[fn.mode()] or 'normal'
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
  base.file_bg = hl('CursorLine').bg or blend(base.fg, base.bg, 0.1)
  base.file_icon_bg = blend(0x000000, base.file_bg, 0.2)
end

-- Rebuild every mode-dependent highlight for the current mode
local function apply()
  local key = current_mode()
  local accent = hl(accents[key]).fg
  local bg = key == 'normal' and base.bg or blend(accent, base.bg, TINT)
  local file_bg = blend(base.file_bg, bg, FILE_BG_OPACITY)
  local file_icon_bg = blend(base.file_icon_bg, bg, FILE_BG_OPACITY)
  local set = function(name, opts)
    api.nvim_set_hl(0, name, opts)
  end

  set('StatusLine', { fg = base.fg, bg = bg })
  set('StlFile', { fg = base.fg, bg = file_bg })
  set('StlFileIcon', { fg = base.fg, bg = file_icon_bg })
  set('StlFileIconModified', { fg = hl('DiagnosticWarn').fg, bg = file_icon_bg })
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

local width = fn.strdisplaywidth

local function shorten_middle(text, budget)
  if width(text) <= budget then
    return text
  end

  local marker = '...'
  local available = budget - width(marker)
  if available < 2 then
    return marker
  end

  local chars = fn.strchars(text)
  local prefix_len = math.min(4, math.floor(available / 2))
  local suffix_len = available - prefix_len
  return fn.strcharpart(text, 0, prefix_len) .. marker .. fn.strcharpart(text, chars - suffix_len, suffix_len)
end

local function file_segment(name, rel, budget)
  if name == '' then
    return '[No Name]'
  end
  if width(rel) <= budget then
    return rel
  end
  local short = fn.pathshorten(rel) -- src/plugins/nvim/statusline.lua -> s/p/n/statusline.lua
  if width(short) <= budget then
    return short
  end
  return fn.fnamemodify(name, ':t') -- just the filename
end

local function file_icon(name)
  if name == '' or not MiniIcons then
    return icons.ui.file
  end
  return MiniIcons.get('file', fn.fnamemodify(name, ':t'))
end

local lsp_helpers = {
  emmet_language_server = true,
  tailwindcss = true,
  graphql = true,
  oxlint = true,
  eslint = true,
  copilot = true,
}

local function lsp_segment()
  local primary, helpers = {}, {}
  for _, c in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
    table.insert(lsp_helpers[c.name] and helpers or primary, c.name)
  end
  vim.list_extend(primary, helpers)

  if #primary == 0 then
    return nil
  elseif #primary == 1 then
    return primary[1]
  end
  return primary[1] .. ' +' .. (#primary - 1)
end

local function search_segment()
  if vim.v.hlsearch == 0 then
    return nil
  end

  local result = fn.searchcount { recompute = 0 }
  if not result.current or result.total == 0 then
    return nil
  end
  if result.incomplete == 1 then
    return '?/??'
  end

  local current = result.current > result.maxcount and '>' .. result.maxcount or result.current
  local total = result.total > result.maxcount and '>' .. result.maxcount or result.total
  return current .. '/' .. total
end

function _G.build_statusline()
  local parts = {}
  local function add(s)
    parts[#parts + 1] = s
  end

  local win_w = api.nvim_win_get_width(vim.g.statusline_winid or 0)
  local branch = vim.b.gitsigns_head or ''
  local status = vim.b.gitsigns_status or ''
  local added = status:match '%+(%d+)'
  local changed = status:match '~(%d+)'
  local deleted = status:match '%-(%d+)'
  local name = api.nvim_buf_get_name(0)
  local rel = name == '' and '[No Name]' or fn.fnamemodify(name, ':~:.')
  local filetype_icon = file_icon(name)
  local locked = vim.bo.readonly or not vim.bo.modifiable
  local lsp = lsp_segment()
  local search = search_segment()
  local errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
  local warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })

  local fixed_width = width(' ' .. mode_icon .. '  ') + width(' ' .. filetype_icon .. ' ') + 1
  if recording ~= '' then
    fixed_width = fixed_width + width(icons.ui.recording .. ' @' .. recording .. ' ')
  end
  if branch ~= '' then
    fixed_width = fixed_width + width(' ' .. icons.git.branch .. ' ')
  end
  if added then
    fixed_width = fixed_width + width('+' .. added .. ' ')
  end
  if changed then
    fixed_width = fixed_width + width('~' .. changed .. ' ')
  end
  if deleted then
    fixed_width = fixed_width + width('-' .. deleted .. ' ')
  end
  if locked then
    fixed_width = fixed_width + width(icons.ui.lock .. ' ')
  end
  if lsp then
    fixed_width = fixed_width + width(icons.ui.lsp .. ' ' .. lsp .. ' ')
  end
  if search then
    fixed_width = fixed_width + width('[' .. search .. '] ')
  end
  if errors > 0 then
    fixed_width = fixed_width + width(icons.diagnostics.ERROR .. ' ' .. errors .. ' ')
  end
  if warnings > 0 then
    fixed_width = fixed_width + width(icons.diagnostics.WARN .. ' ' .. warnings .. ' ')
  end
  fixed_width = fixed_width + width(' ' .. fn.line('.') .. ':' .. fn.col('.') .. '  100% ')

  local content_budget = math.max(1, win_w - fixed_width)
  local branch_budget = 0
  local file_budget = content_budget
  if branch ~= '' then
    branch_budget = math.min(width(branch), math.max(8, math.floor(content_budget * 0.4)))
    branch_budget = math.min(branch_budget, math.max(3, content_budget - 1))
    file_budget = math.max(1, content_budget - branch_budget)
    if width(rel) < file_budget then
      file_budget = width(rel)
      branch_budget = content_budget - file_budget
    end
  end

  -- Mode pill
  add('%#StlMode# ' .. mode_icon .. ' %#StatusLine#')

  -- File pill
  local file = file_segment(name, rel, file_budget):gsub('%%', '%%%%')
  local file_icon_hl = vim.bo.modified and '%#StlFileIconModified#' or '%#StlFileIcon#'
  add(file_icon_hl .. ' ' .. filetype_icon .. ' %#StlFile#%<' .. file .. ' ')
  if locked then
    add('%#StlLock#' .. icons.ui.lock .. ' ')
  end

  -- Macro recording
  if recording ~= '' then
    add('%#StlRecording# ' .. icons.ui.recording .. ' @' .. recording)
  end

  -- Branch name (escape % so it isn't read as a format item)
  if branch ~= '' then
    branch = shorten_middle(branch, branch_budget):gsub('%%', '%%%%')
    add('%@v:lua.statusline_details@%#StlBranch# ' .. icons.git.branch .. ' ' .. branch .. '%X ')
  end

  -- Git diff: only emit non-zero counts
  if added then
    add('%#StlAdd#+' .. added .. ' ')
  end
  if changed then
    add('%#StlChange#~' .. changed .. ' ')
  end
  if deleted then
    add('%#StlDelete#-' .. deleted .. ' ')
  end

  add('%#StatusLine#%=')

  if search then
    add('%#StlMuted#[' .. search .. '] ')
  end

  -- LSP clients
  if lsp then
    add('%#StlMuted#' .. icons.ui.lsp .. ' ' .. lsp .. ' ')
  end

  -- Diagnostics
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

function _G.statusline_details()
  require('ui.status_info').open()
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

api.nvim_create_autocmd('CursorMoved', {
  group = group,
  callback = function()
    search_generation = search_generation + 1
    local generation = search_generation

    vim.defer_fn(function()
      if generation ~= search_generation or vim.v.hlsearch == 0 then
        return
      end
      fn.searchcount { recompute = true, timeout = 50 }
      vim.cmd.redrawstatus()
    end, 25)
  end,
})

-- Cursor shape per mode, colored by the current mode accent
vim.opt.guicursor = 'n-v-c-sm:block-StlCursor,i-ci-ve:ver25-StlCursor,r-cr-o:hor20-StlCursor'

-- Init
capture()
apply()
vim.o.statusline = '%!v:lua.build_statusline()'

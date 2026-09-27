local api, fn = vim.api, vim.fn
local icons = require('icons')
local float = require('ui.float')
local lsp_roles = require('ui.lsp_roles')

local M = {}

local function set_highlights()
  api.nvim_set_hl(0, 'LspInfoName', { link = 'Title', default = true })
  api.nvim_set_hl(0, 'LspInfoLabel', { link = 'Comment', default = true })
  api.nvim_set_hl(0, 'LspInfoOn', { link = 'DiagnosticVirtualTextOk', default = true })
  api.nvim_set_hl(0, 'LspInfoOff', { link = 'NonText', default = true })
end

set_highlights()
-- :colorscheme clears custom groups, so put them back
api.nvim_create_autocmd('ColorScheme', {
  group = api.nvim_create_augroup('ui_lsp_info', { clear = true }),
  callback = set_highlights,
})

-- server_capabilities key -> badge label
local caps = {
  { 'completionProvider',         'complete' },
  { 'hoverProvider',              'hover' },
  { 'definitionProvider',         'def' },
  { 'referencesProvider',         'refs' },
  { 'renameProvider',             'rename' },
  { 'codeActionProvider',         'actions' },
  { 'documentFormattingProvider', 'format' },
  { 'documentHighlightProvider',  'highlight' },
  { 'inlayHintProvider',          'inlay' },
}

local INDENT = '    '
local LABEL_W = 11
local BADGES_PER_LINE = 5

local function label(text)
  return { INDENT .. string.format('%-' .. LABEL_W .. 's', text), 'LspInfoLabel' }
end

local function row(name, value, group)
  return { label(name), { value, group } }
end

local function cmd_string(c)
  local cmd = c.config.cmd
  if type(cmd) == 'table' then
    return table.concat(cmd, ' ')
  elseif type(cmd) == 'function' then
    return '<dynamic>'
  end
  return 'n/a'
end

local function buffer_list(c)
  local bufs = vim.tbl_keys(c.attached_buffers or {})
  table.sort(bufs)
  return #bufs > 0 and table.concat(bufs, ', ') or 'none'
end

local function status(c)
  if c:is_stopped() then
    return { '● stopped', 'DiagnosticError' }
  elseif c.initialized then
    return { '● running', 'DiagnosticOk' }
  end
  return { '● starting', 'DiagnosticWarn' }
end

local function summarize_client(c)
  local name_hl = lsp_roles.is_helper(c) and 'LspInfoLabel' or 'LspInfoName'
  local root = c.root_dir and fn.fnamemodify(c.root_dir, ':~') or 'single file'

  local lines = {
    {
      { '  ' .. c.name,           name_hl },
      { '   id ' .. c.id .. '  ', 'Comment' },
      status(c),
    },
    row('root', root, 'Directory'),
    row('cmd', cmd_string(c)),
    row('encoding', c.offset_encoding or 'n/a'),
    row('buffers', buffer_list(c)),
  }

  -- Capability badges, lit up when supported, wrapped across lines
  local sc = c.server_capabilities or {}
  local line = { label('features') }
  for i, cap in ipairs(caps) do
    if i > 1 and (i - 1) % BADGES_PER_LINE == 0 then
      table.insert(lines, line)
      line = { { string.rep(' ', #INDENT + LABEL_W) } }
    end
    table.insert(line, { ' ' .. cap[2] .. ' ', sc[cap[1]] and 'LspInfoOn' or 'LspInfoOff' })
    table.insert(line, { ' ' })
  end
  table.insert(lines, line)

  return lines
end

-- Show a float for the given clients. Primary servers are listed first.
function M.open(clients, title)
  if #clients == 0 then
    vim.notify('No LSP clients attached', vim.log.levels.WARN)
    return
  end

  lsp_roles.sorted(clients)

  local blocks = {}
  for i, c in ipairs(clients) do
    if i > 1 then
      table.insert(blocks, {})
    end
    vim.list_extend(blocks, summarize_client(c))
  end

  float.open(blocks, ' ' .. icons.ui.lsp .. ' ' .. title .. ' ')
end

return M

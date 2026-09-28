local api, fn = vim.api, vim.fn
local float = require('ui.float')
local lsp_roles = require('ui.lsp_roles')

local M = {}

local function section(blocks, label, value, highlight)
  if #blocks > 0 then
    table.insert(blocks, {})
  end
  table.insert(blocks, { { label, 'Comment' } })
  table.insert(blocks, { { '  ' .. value, highlight } })
end

function M.open()
  local name = api.nvim_buf_get_name(0)
  local path = name == '' and '[No Name]' or fn.fnamemodify(name, ':~')
  local branch = vim.b.gitsigns_head or ''
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  lsp_roles.sorted(clients)

  local client_names = {}
  for _, client in ipairs(clients) do
    table.insert(client_names, client.name)
  end

  local blocks = {}
  section(blocks, 'Branch', branch ~= '' and branch or 'none', branch ~= '' and 'Special' or 'Comment')
  section(blocks, 'File', path, name ~= '' and 'Directory' or 'Comment')
  section(blocks, 'LSP clients', #client_names > 0 and table.concat(client_names, ', ') or 'none', 'Type')

  float.open(blocks, ' Status details ')
end

return M

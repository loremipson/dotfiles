local M = {}

function M.setup()
  local key = vim.keymap.set
  local lsp_zero = require 'lsp-zero'
  lsp_zero.extend_lspconfig()

  lsp_zero.on_attach(function(_, bufnr)
    local opts = { buffer = bufnr, remap = false }

    key('n', 'gd', vim.lsp.buf.definition, opts)
    key('n', 'K', vim.lsp.buf.hover, opts)
    key('n', '<leader>ws', vim.lsp.buf.workspace_symbol, opts)
    key('n', '<leader>d', vim.diagnostic.open_float, opts)
    key('n', '[d', vim.diagnostic.goto_next, opts)
    key('n', ']d', vim.diagnostic.goto_prev, opts)
    key('n', '<leader>ca', vim.lsp.buf.code_action, opts)
    key('n', '<leader>rr', vim.lsp.buf.references, opts)
    key('n', '<leader>rn', vim.lsp.buf.rename, opts)
    key('i', '<C-h>', vim.lsp.buf.signature_help, opts)
  end)
end

return M

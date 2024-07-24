local M = {}

function M.setup()
  local lspconfig = require 'lspconfig'
  local cmp_nvim_lsp = require 'cmp_nvim_lsp'

  local keymap = vim.keymap

  local opts = { noremap = true, silent = true }
  local on_attach = function(client, bufnr)
    opts.buffer = bufnr

    opts.desc = 'Show LSP references'
    keymap.set('n', 'gR', '<cmd>Telescope lsp_references<CR>', opts)

    opts.desc = 'Go to declaration'
    keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)

    opts.desc = 'Show LSP definitions'
    keymap.set('n', 'gd', '<cmd>Telescope lsp_definitions<CR>', opts)

    opts.desc = 'Show LSP implementations'
    keymap.set('n', 'gi', '<cmd>Telescope lsp_implementations<CR>', opts)

    opts.desc = 'Show LSP type definitions'
    keymap.set('n', 'gt', '<cmd>Telescope lsp_type_definitions<CR>', opts)

    opts.desc = 'See available code actions'
    keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)

    opts.desc = 'Smart rename'
    keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)

    opts.desc = 'Go to previous diagnostic'
    keymap.set('n', ']d', vim.diagnostic.goto_prev, opts)

    opts.desc = 'Go to next diagnostic'
    keymap.set('n', '[d', vim.diagnostic.goto_next, opts)

    opts.desc = 'Show documentation for what is under cursor'
    keymap.set('n', 'K', vim.lsp.buf.hover, opts)

    opts.desc = 'Restart LSP'
    keymap.set('n', '<leader>rs', '<cmd>LspRestart<CR>', opts)
  end

  local capabilities = cmp_nvim_lsp.default_capabilities()

  local signs = { Error = ' ', Warn = ' ', Hint = ' ', Info = ' ' }
  for type, icon in pairs(signs) do
    local hl = 'DiagnosticSign' .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = '' })
  end

  lspconfig.tsserver.setup({
    capabilities = capabilities,
    on_attach = on_attach,
  })

  lspconfig.dockerls.setup {
    capabilities = capabilities,
    on_attach = on_attach,
  }

  lspconfig.docker_compose_language_service.setup {
    capabilities = capabilities,
    on_attach = on_attach,
  }

  lspconfig.graphql.setup {
    capabilities = capabilities,
    on_attach = on_attach,
  }

  lspconfig.html.setup {
    capabilities = capabilities,
    on_attach = on_attach,
  }

  lspconfig.jsonls.setup {
    capabilities = capabilities,
    on_attach = on_attach,
  }

  lspconfig.tailwindcss.setup {
    capabilities = capabilities,
    on_attach = on_attach,
  }

  lspconfig.lua_ls.setup {
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
      Lua = {
        diagnostics = {
          globals = { 'vim' },
        },
        workspace = {
          library = {
            [vim.fn.expand('$VIMRUNTIME/lua')] = true,
            [vim.fn.stdpath('config') .. '/lua'] = true,
          },
        },
      },
    },
  }

  lspconfig.prismals.setup {
    capabilities = capabilities,
    on_attach = on_attach,
  }

  lspconfig.yamlls.setup {
    capabilities = capabilities,
    on_attach = on_attach,
  }

  lspconfig.gopls.setup {
    capabilities = capabilities,
    on_attach = on_attach,
  }
end

return M

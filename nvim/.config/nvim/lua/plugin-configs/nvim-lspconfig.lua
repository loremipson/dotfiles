local M = {}

function M.setup()
  local lspconfig = require 'lspconfig'
  local blink = require 'blink.cmp'

  local keymap = vim.keymap

  local opts = { noremap = true, silent = true }
  local on_attach = function(client, bufnr)
    opts.buffer = bufnr

    opts.desc = 'Show LSP references'
    keymap.set('n', 'gR', '<cmd>FzfLua lsp_references<CR>', opts)

    opts.desc = 'Go to declaration'
    keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)

    opts.desc = 'Show LSP definitions'
    keymap.set('n', 'gd', '<cmd>FzfLua lsp_definitions<CR>', opts)

    opts.desc = 'Show LSP implementations'
    keymap.set('n', 'gi', '<cmd>FzfLua lsp_implementations<CR>', opts)

    opts.desc = 'Show LSP type definitions'
    keymap.set('n', 'gt', '<cmd>FzfLua lsp_typedefs<CR>', opts)

    opts.desc = 'See available code actions'
    keymap.set('n', '<leader>la', vim.lsp.buf.code_action, opts)

    opts.desc = 'Smart rename'
    keymap.set('n', '<leader>ln', vim.lsp.buf.rename, opts)

    opts.desc = 'Go to previous diagnostic'
    keymap.set('n', ']d', vim.diagnostic.goto_prev, opts)

    opts.desc = 'Go to next diagnostic'
    keymap.set('n', '[d', vim.diagnostic.goto_next, opts)

    opts.desc = 'Show diagnostic for what is under cursor'
    keymap.set('n', '<leader>d', vim.diagnostic.open_float, opts)

    opts.desc = 'Show documentation for what is under cursor'
    keymap.set('n', 'K', vim.lsp.buf.hover, opts)

    opts.desc = 'Restart LSP'
    keymap.set('n', '<leader>lr', '<cmd>LspRestart<CR>', opts)
  end

  local capabilities = blink.get_lsp_capabilities()

  vim.diagnostic.config {
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = ' ',
        [vim.diagnostic.severity.WARN] = ' ',
        [vim.diagnostic.severity.HINT] = ' ',
        [vim.diagnostic.severity.INFO] = ' ',
      },
    },
  }

  local mason_registry = require 'mason-registry'
  local vue_language_server_path = vim.fn.expand '$MASON/packages/vue-language-server' .. '/node_modules/@vue/language-server'

  lspconfig.ts_ls.setup {
    capabilities = capabilities,
    on_attach = on_attach,
    init_options = {
      plugins = {
        {
          name = '@vue/typescript-plugin',
          location = vue_language_server_path,
          languages = { 'vue' },
        },
      },
    },
    filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
  }

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
            [vim.fn.expand '$VIMRUNTIME/lua'] = true,
            [vim.fn.stdpath 'config' .. '/lua'] = true,
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

  lspconfig.volar.setup {
    capabilities = capabilities,
    on_attach = on_attach,
  }

  lspconfig.astro.setup {
    capabilities = capabilities,
    on_attach = on_attach,
    filetypes = { 'astro' },
  }
end

return M

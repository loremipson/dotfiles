local M = {}

function M.setup()
  local blink = require 'blink.cmp'

  local keymap = vim.keymap

  local opts = { noremap = true, silent = true }
  local on_attach = function(client, bufnr)
    print('LSP attached: ' .. client.name .. ' to buffer ' .. bufnr)
    opts.buffer = bufnr

    opts.desc = 'Show LSP references'
    keymap.set('n', 'gR', function()
      require('fzf-lua').lsp_references { jump_to_single_result = true }
    end, opts)

    opts.desc = 'Show LSP definitions'
    keymap.set('n', 'gd', function()
      require('fzf-lua').lsp_definitions { jump_to_single_result = true }
    end, opts)

    opts.desc = 'Show LSP implementations'
    keymap.set('n', 'gi', function()
      require('fzf-lua').lsp_implementations { jump_to_single_result = true }
    end, opts)

    opts.desc = 'Show LSP type definitions'
    keymap.set('n', 'gt', function()
      require('fzf-lua').lsp_typedefs { jump_to_single_result = true }
    end, opts)

    -- Built-in LSP functions
    opts.desc = 'Go to declaration'
    keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)

    opts.desc = 'See available code actions'
    keymap.set('n', '<leader>la', vim.lsp.buf.code_action, opts)

    opts.desc = 'Smart rename'
    keymap.set('n', '<leader>ln', vim.lsp.buf.rename, opts)

    opts.desc = 'Show documentation for what is under cursor'
    keymap.set('n', 'K', vim.lsp.buf.hover, opts)

    opts.desc = 'Go to previous diagnostic'
    keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)

    opts.desc = 'Go to next diagnostic'
    keymap.set('n', ']d', vim.diagnostic.goto_next, opts)

    opts.desc = 'Show diagnostic for what is under cursor'
    keymap.set('n', '<leader>d', vim.diagnostic.open_float, opts)

    -- LSP management
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

  local vue_language_server_path = vim.fn.expand '$MASON/packages/vue-language-server' .. '/node_modules/@vue/language-server'

  vim.lsp.config('ts_ls', {
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
  })

  vim.lsp.config('dockerls', {
    capabilities = capabilities,
    on_attach = on_attach,
  })

  vim.lsp.config('docker_compose_language_service', {
    capabilities = capabilities,
    on_attach = on_attach,
  })

  vim.lsp.config('graphql', {
    capabilities = capabilities,
    on_attach = on_attach,
  })

  vim.lsp.config('html', {
    capabilities = capabilities,
    on_attach = on_attach,
  })

  vim.lsp.config('jsonls', {
    capabilities = capabilities,
    on_attach = on_attach,
  })

  vim.lsp.config('tailwindcss', {
    capabilities = capabilities,
    on_attach = on_attach,
  })

  vim.lsp.config('lua_ls', {
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
  })

  vim.lsp.config('prismals', {
    capabilities = capabilities,
    on_attach = on_attach,
  })

  vim.lsp.config('yamlls', {
    capabilities = capabilities,
    on_attach = on_attach,
  })

  vim.lsp.config('gopls', {
    capabilities = capabilities,
    on_attach = on_attach,
  })

  vim.lsp.config('volar', {
    capabilities = capabilities,
    on_attach = on_attach,
  })

  vim.lsp.config('astro', {
    capabilities = capabilities,
    on_attach = on_attach,
    filetypes = { 'astro' },
  })

  vim.lsp.config('svelte', {
    capabilities = capabilities,
    on_attach = on_attach,
    filetypes = { 'svelte' },
  })
end

return M

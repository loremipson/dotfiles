local M = {}

function M.setup()
  local blink = require 'blink.cmp'

  local keymap = vim.keymap

  local on_attach = function(client, bufnr)
    print('LSP attached: ' .. client.name .. ' to buffer ' .. bufnr)
    -- Fresh opts table per buffer to avoid cross-buffer mutation
    local opts = { noremap = true, silent = true, buffer = bufnr }

    opts.desc = 'Show LSP references'
    keymap.set('n', 'gR', function()
      require('snacks').picker.lsp_references()
    end, opts)

    opts.desc = 'Show LSP definitions'
    keymap.set('n', 'gd', function()
      require('snacks').picker.lsp_definitions()
    end, opts)

    opts.desc = 'Show LSP implementations'
    keymap.set('n', 'gi', function()
      require('snacks').picker.lsp_implementations()
    end, opts)

    opts.desc = 'Show LSP type definitions'
    keymap.set('n', 'gt', function()
      require('snacks').picker.lsp_type_definitions()
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

    -- Document highlight: illuminate all references to the symbol under cursor
    if client.supports_method('textDocument/documentHighlight') then
      local group = vim.api.nvim_create_augroup('lsp_document_highlight_' .. bufnr, { clear = true })
      vim.api.nvim_create_autocmd('CursorHold', {
        group = group,
        buffer = bufnr,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd({ 'CursorMoved', 'InsertEnter' }, {
        group = group,
        buffer = bufnr,
        callback = vim.lsp.buf.clear_references,
      })
    end
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
    virtual_text = {
      prefix = '●',
      source = 'if_many', -- show source only when multiple LSPs active on buffer
    },
    underline = true,
    update_in_insert = false, -- don't update diagnostics while typing
    severity_sort = true,     -- errors before warnings before hints
    float = {
      border = 'rounded',
      source = true,
    },
  }

  local vue_language_server_path = vim.fn.expand '$MASON/packages/vue-language-server' .. '/node_modules/@vue/language-server'

  vim.lsp.config('vtsls', {
    capabilities = capabilities,
    on_attach = on_attach,
    filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
    settings = {
      vtsls = {
        enableMoveToFileCodeAction = true,
        autoUseWorkspaceTsdk = true,
        experimental = {
          completion = {
            enableServerSideFuzzyMatch = true,
          },
        },
      },
      typescript = {
        updateImportsOnFileMove = { enabled = 'always' },
        suggest = { completeFunctionCalls = true },
        inlayHints = {
          enumMemberValues = { enabled = true },
          functionLikeReturnTypes = { enabled = true },
          parameterNames = { enabled = 'literals' },
          parameterTypes = { enabled = true },
          propertyDeclarationTypes = { enabled = true },
          variableTypes = { enabled = false },
        },
      },
      javascript = {
        updateImportsOnFileMove = { enabled = 'always' },
        suggest = { completeFunctionCalls = true },
        inlayHints = {
          enumMemberValues = { enabled = true },
          functionLikeReturnTypes = { enabled = true },
          parameterNames = { enabled = 'literals' },
          parameterTypes = { enabled = true },
          propertyDeclarationTypes = { enabled = true },
          variableTypes = { enabled = false },
        },
      },
    },
    before_init = function(_, config)
      -- Inject the Vue TypeScript plugin so vtsls understands Vue files
      local vtsls_settings = config.settings.vtsls or {}
      vtsls_settings.tsserver = vtsls_settings.tsserver or {}
      vtsls_settings.tsserver.globalPlugins = vtsls_settings.tsserver.globalPlugins or {}
      table.insert(vtsls_settings.tsserver.globalPlugins, {
        name = '@vue/typescript-plugin',
        location = vue_language_server_path,
        languages = { 'vue' },
        configNamespace = 'typescript',
        enableForWorkspaceTypeScriptVersions = true,
      })
      config.settings.vtsls = vtsls_settings
    end,
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
    settings = {
      json = {
        schemas = require('schemastore').json.schemas(),
        validate = { enable = true },
      },
    },
  })

  vim.lsp.config('tailwindcss', {
    capabilities = capabilities,
    on_attach = on_attach,
    filetypes = {
      'html', 'css', 'scss',
      'javascript', 'javascriptreact',
      'typescript', 'typescriptreact',
      'astro', 'svelte', 'vue',
    },
    settings = {
      tailwindCSS = {
        experimental = {
          classRegex = {
            -- cva, cx, cn, clsx, twMerge — completions inside utility wrappers
            { 'cva\\(([^)]*)\\)', '["\'`]([^"\'`]*).*?["\'`]' },
            { 'cx\\(([^)]*)\\)', '["\'`]([^"\'`]*).*?["\'`]' },
            { 'cn\\(([^)]*)\\)', '["\'`]([^"\'`]*).*?["\'`]' },
            { 'clsx\\(([^)]*)\\)', '["\'`]([^"\'`]*).*?["\'`]' },
            { 'twMerge\\(([^)]*)\\)', '["\'`]([^"\'`]*).*?["\'`]' },
          },
        },
      },
    },
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
    settings = {
      yaml = {
        schemaStore = { enable = false, url = '' }, -- disable built-in, use schemastore.nvim
        schemas = require('schemastore').yaml.schemas(),
      },
    },
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

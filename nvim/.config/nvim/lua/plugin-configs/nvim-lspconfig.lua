local M = {}
function M.on_attach(client, bufnr)
  local keymap = vim.keymap
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

  vim.keymap.set({ 'n', 'x' }, '<leader>la', function()
    require('tiny-code-action').code_action()
  end, { noremap = true, silent = true, desc = 'See available code action' })

  opts.desc = 'Smart rename'
  keymap.set('n', '<leader>ln', vim.lsp.buf.rename, opts)

  opts.desc = 'Show documentation for what is under cursor'
  keymap.set('n', 'K', vim.lsp.buf.hover, opts)

  opts.desc = 'Go to previous diagnostic'
  keymap.set('n', '[d', function()
    vim.diagnostic.jump { count = -1, float = true }
  end, opts)

  opts.desc = 'Go to next diagnostic'
  keymap.set('n', ']d', function()
    vim.diagnostic.jump { count = 1, float = true }
  end, opts)

  opts.desc = 'Show diagnostic for what is under cursor'
  keymap.set('n', '<leader>d', vim.diagnostic.open_float, opts)

  -- LSP management
  opts.desc = 'Restart LSP'
  keymap.set('n', '<leader>lr', '<cmd>lsp restart<CR>', opts)

  local function summarize_client(c)
    local caps = c.server_capabilities or {}
    local notable = {}
    local function flag(key, label)
      if caps[key] then
        table.insert(notable, label)
      end
    end
    flag('renameProvider', 'rename')
    flag('codeActionProvider', 'codeAction')
    flag('documentFormattingProvider', 'format')
    flag('hoverProvider', 'hover')
    flag('definitionProvider', 'definition')
    flag('referencesProvider', 'references')
    flag('documentHighlightProvider', 'documentHighlight')
    flag('inlayHintProvider', 'inlayHints')

    local bufs = {}
    for bufnr_attached, _ in pairs(c.attached_buffers or {}) do
      table.insert(bufs, bufnr_attached)
    end
    table.sort(bufs)

    local cmd_str
    if type(c.config.cmd) == 'table' then
      cmd_str = table.concat(c.config.cmd, ' ')
    elseif type(c.config.cmd) == 'function' then
      cmd_str = '<dynamic cmd function>'
    else
      cmd_str = 'n/a'
    end

    return {
      string.format('%s (id: %d)', c.name, c.id),
      string.format('  root_dir:   %s', c.root_dir or 'n/a'),
      string.format('  cmd:        %s', cmd_str),
      string.format('  encoding:   %s', c.offset_encoding or 'n/a'),
      string.format('  buffers:    %s', #bufs > 0 and table.concat(bufs, ', ') or 'none'),
      string.format('  supports:   %s', #notable > 0 and table.concat(notable, ', ') or 'none'),
    }
  end

  local function show_float(lines, title)
    local buf = vim.api.nvim_create_buf(false, true) -- unlisted, scratch
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.bo[buf].filetype = 'text'
    vim.bo[buf].bufhidden = 'wipe'
    vim.bo[buf].modifiable = false

    local width = math.floor(vim.o.columns * 0.7)
    local height = math.min(#lines + 2, math.floor(vim.o.lines * 0.7))

    local win = vim.api.nvim_open_win(buf, true, {
      relative = 'editor',
      width = width,
      height = height,
      row = math.floor((vim.o.lines - height) / 2),
      col = math.floor((vim.o.columns - width) / 2),
      style = 'minimal',
      border = 'rounded',
      title = title,
      title_pos = 'center',
    })

    -- Close on q or <Esc>
    local close_keys = { 'q', '<Esc>' }
    for _, key in ipairs(close_keys) do
      vim.keymap.set('n', key, function()
        if vim.api.nvim_win_is_valid(win) then
          vim.api.nvim_win_close(win, true)
        end
      end, { buffer = buf, nowait = true, silent = true })
    end
  end

  opts.desc = 'Show LSP client info (current buffer)'
  keymap.set('n', '<leader>li', function()
    local clients = vim.lsp.get_clients { bufnr = bufnr }
    if #clients == 0 then
      vim.notify('No LSP clients attached to this buffer', vim.log.levels.WARN)
      return
    end

    local lines = {}
    for _, c in ipairs(clients) do
      vim.list_extend(lines, summarize_client(c))
      table.insert(lines, '')
    end

    show_float(lines, ' LSP Clients (buffer) ')
  end, opts)

  opts.desc = 'Show all LSP clients (global)'
  keymap.set('n', '<leader>lI', function()
    local clients = vim.lsp.get_clients()
    local lines = {}
    for _, c in ipairs(clients) do
      vim.list_extend(lines, summarize_client(c))
      table.insert(lines, '')
    end

    show_float(lines, ' LSP Clients (all) ')
  end, opts)

  -- Document highlight: illuminate all references to the symbol under cursor
  if client:supports_method 'textDocument/documentHighlight' then
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

function M.setup()
  local blink = require 'blink.cmp'

  local on_attach = M.on_attach

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
    severity_sort = true, -- errors before warnings before hints
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
      'html',
      'css',
      'scss',
      'javascript',
      'javascriptreact',
      'typescript',
      'typescriptreact',
      'astro',
      'svelte',
      'vue',
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

  vim.lsp.config('cssls', {
    capabilities = capabilities,
    on_attach = on_attach,
  })

  vim.lsp.config('emmet_language_server', {
    capabilities = capabilities,
    on_attach = on_attach,
    filetypes = {
      'html',
      'css',
      'scss',
      'javascriptreact',
      'typescriptreact',
      'astro',
      'svelte',
      'vue',
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

  vim.lsp.config('pyright', {
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
      python = {
        analysis = {
          typeCheckingMode = 'basic',
          autoSearchPaths = true,
          useLibraryCodeForTypes = true,
          diagnosticMode = 'openFilesOnly',
        },
      },
    },
  })

  -- ruff handles linting/formatting-adjacent diagnostics; pyright handles types.
  -- They overlap on hover/some diagnostics, so mute ruff's hover in favor of pyright's.
  vim.lsp.config('ruff', {
    capabilities = capabilities,
    on_attach = function(client, bufnr)
      client.server_capabilities.hoverProvider = false
      on_attach(client, bufnr)
    end,
  })

  vim.lsp.config('gopls', {
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
      gopls = {
        gofumpt = true,
        staticcheck = true,
        analyses = {
          unusedparams = true,
          shadow = true,
        },
        hints = {
          assignVariableTypes = true,
          compositeLiteralFields = true,
          constantValues = true,
          parameterNames = true,
          rangeVariableTypes = true,
        },
      },
    },
  })
end

return M

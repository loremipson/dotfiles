local M = {}

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
  local buf = vim.api.nvim_create_buf(false, true)
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

  for _, key in ipairs { 'q', '<Esc>' } do
    vim.keymap.set('n', key, function()
      if vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_win_close(win, true)
      end
    end, { buffer = buf, nowait = true, silent = true })
  end
end

function M.setup()
  vim.lsp.config('*', {
    capabilities = vim.tbl_deep_extend('force', require('blink.cmp').get_lsp_capabilities(),
      require('lsp-file-operations').default_capabilities()),
  })

  vim.lsp.enable {
    'vtsls',
    'tsc_native',
    'dockerls',
    'docker_compose_language_service',
    'graphql',
    'html',
    'jsonls',
    'tailwindcss',
    'lua_ls',
    'prismals',
    'yamlls',
    'cssls',
    'emmet_language_server',
    'vue_ls',
    'astro',
    'svelte',
    'pyright',
    'ruff',
    'gopls',
    'eslint',
    'biome',
    'oxlint',
  }

  local icons = require('icons').diagnostics
  local sev = vim.diagnostic.severity

  vim.diagnostic.config {
    signs = {
      text = {
        [sev.ERROR] = icons.ERROR,
        [sev.WARN] = icons.WARN,
        [sev.HINT] = icons.HINT,
        [sev.INFO] = icons.INFO,
      },
    },
    virtual_text = {
      prefix = '●',
      source = 'if_many',
    },
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
      border = 'rounded',
      source = true,
    },
  }

  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('user_lsp_attach', { clear = true }),
    callback = function(args)
      local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
      local bufnr = args.buf
      local keymap = vim.keymap
      print('LSP attached: ' .. client.name .. ' to buffer ' .. bufnr)

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

      opts.desc = 'Go to declaration'
      keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)

      -- rust-analyzer sets its own grouped code-action mapping on this same key
      -- inside rustaceanvim's on_attach.
      if client.name ~= 'rust-analyzer' then
        opts.desc = 'See available code action'
        keymap.set({ 'n', 'x' }, '<leader>la', function()
          require('tiny-code-action').code_action()
        end, opts)
      end

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

      opts.desc = 'Restart LSP'
      keymap.set('n', '<leader>lr', '<cmd>lsp restart<CR>', opts)

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
    end,
  })
end

return M

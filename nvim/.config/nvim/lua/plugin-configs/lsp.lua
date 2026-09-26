local M = {}

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

  vim.keymap.set('n', '<leader>lI', function()
    require('ui.lsp_info').open(vim.lsp.get_clients(), 'LSP Clients (all)')
  end, { desc = 'Show all LSP clients (global)', silent = true })

  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('user_lsp_attach', { clear = true }),
    callback = function(args)
      local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
      local bufnr = args.buf
      local keymap = vim.keymap
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
        require('ui.lsp_info').open(vim.lsp.get_clients { bufnr = bufnr }, 'LSP Clients (buffer)')
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

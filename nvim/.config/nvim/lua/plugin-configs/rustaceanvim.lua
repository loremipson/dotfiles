-- rustaceanvim manages its own LSP client internally (not via vim.lsp.enable()),
-- so it never goes through lsp.lua's vim.lsp.config('*', {...}) merge.
local M = {}

function M.setup()
  if vim.fn.executable 'cargo' == 0 then
    return
  end

  vim.g.rustaceanvim = {
    server = {
      capabilities = vim.tbl_deep_extend('force', require('blink.cmp').get_lsp_capabilities(), require('lsp-file-operations').default_capabilities()),

      on_attach = function(_, bufnr)
        -- Shared keymaps (gd, gR, K, diagnostics, <leader>ln, <leader>lr, etc.)
        -- come from the global LspAttach autocmd in lsp.lua. It fires for
        -- every attaching client, including this one, so nothing to call here.
        --
        -- <leader>la below overrides the global tiny-code-action mapping with
        -- Rust's grouped code action. This only works because lsp.lua's
        -- LspAttach autocmd skips setting <leader>la for rust-analyzer.
        local opts = { noremap = true, silent = true, buffer = bufnr }

        opts.desc = 'Rust: code action (grouped)'
        vim.keymap.set('n', '<leader>la', function()
          vim.cmd.RustLsp 'codeAction'
        end, opts)

        opts.desc = 'Rust: runnables'
        vim.keymap.set('n', '<leader>rr', function()
          vim.cmd.RustLsp 'runnables'
        end, opts)

        opts.desc = 'Rust: debuggables'
        vim.keymap.set('n', '<leader>rd', function()
          vim.cmd.RustLsp 'debuggables'
        end, opts)

        opts.desc = 'Rust: expand macro'
        vim.keymap.set('n', '<leader>rm', function()
          vim.cmd.RustLsp 'expandMacro'
        end, opts)

        opts.desc = 'Rust: open Cargo.toml'
        vim.keymap.set('n', '<leader>rc', function()
          vim.cmd.RustLsp 'openCargo'
        end, opts)
      end,

      default_settings = {
        ['rust-analyzer'] = {
          checkOnSave = true,
          check = {
            command = 'clippy',
            allTargets = false,
            extraArgs = { '--no-deps' },
          },
        },
      },
    },
  }
end

return M

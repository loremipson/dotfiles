local M = {}

function M.setup()
  if vim.fn.executable 'cargo' == 0 then
    return
  end

  local lspconfig = require 'plugin-configs.nvim-lspconfig'

  vim.g.rustaceanvim = {
    server = {
      on_attach = function(client, bufnr)
        lspconfig.on_attach(client, bufnr)

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

local M = {}

function M.setup()
  local lsp_zero = require 'lsp-zero'

  require('mason').setup()
  require('mason-lspconfig').setup {
    ensure_installed = {
      'lua_ls',
      'tsserver',
      'docker_compose_language_service',
      'dockerls',
      'graphql',
      'html',
      'jsonls',
      'vimls',
      'tsserver',
      'tailwindcss',
      'lua_ls',
      'prismals',
      'yamlls',
    },
    handlers = {
      lsp_zero.default_setup,
      lua_ls = function()
        local lua_opts = lsp_zero.nvim_lua_ls()
        require('lspconfig').lua_ls.setup(lua_opts)
      end,
    },
  }
end

return M

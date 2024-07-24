local M = {}

function M.setup()
  require('mason').setup {
    ui = {
      icons = {
        package_installed = '✓',
        package_pending = '➜',
        package_uninstalled = '✗',
      },
    },
  }
  require('mason-lspconfig').setup {
    ensure_installed = {
      'tsserver',
      'docker_compose_language_service',
      'dockerls',
      'graphql',
      'html',
      'jsonls',
      'tsserver',
      'tailwindcss',
      'lua_ls',
      'prismals',
      'yamlls',
      'gopls',
      'volar',
      'astro',
      'eslint',
    },
    automatic_installation = true,
  }
end

return M

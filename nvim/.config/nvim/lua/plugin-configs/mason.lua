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
  require('mason-tool-installer').setup {
    ensure_installed = {
      'goimports-reviser',
      'golines',
      'prettier',
      'rustywind',
      'vale',
    },
  }
  require('mason-lspconfig').setup {
    ensure_installed = {
      'eslint',
      'ts_ls',
      'docker_compose_language_service',
      'dockerls',
      'graphql',
      'html',
      'jsonls',
      'tailwindcss',
      'lua_ls',
      'prismals',
      'yamlls',
      'gopls',
      'vue_ls',
      'astro',
    },
    automatic_installation = true,
  }
end

return M

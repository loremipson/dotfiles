local M = {}

function M.setup()
  require('nvim-treesitter.configs').setup {
    ensure_installed = { 'lua', 'vim', 'vimdoc', 'prisma', 'typescript', 'json', 'go', 'gowork', 'gomod', 'gosum', 'sql', 'gotmpl', 'comment', 'astro', 'vue' },
    sync_install = false,
    highlight = {
      enable = true,
    },
  }
end

return M

local M = {}

function M.setup()
  require('nvim-treesitter').setup {
    ensure_installed = {
      'bash',
      'lua',
      'vim',
      'vimdoc',
      'prisma',
      'typescript',
      'json',
      'regex',
      'sql',
      'gotmpl',
      'comment',
      'astro',
      'vue',
      'yaml',
      'css',
      'html',
      'javascript',
      'latex',
      'norg',
      'scss',
      'typst',
    },
    sync_install = false,
    highlight = {
      enable = true,
    },
  }
end

return M

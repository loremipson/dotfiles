local M = {}

function M.setup()
  require('nvim-treesitter').setup {
    sync_install = false,
    highlight = {
      enable = true,
    },
  }
  require('nvim-treesitter').install({
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
    'scss',
    'typst',
  })
end

return M

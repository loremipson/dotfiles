local M = {}

function M.setup()
  require('nvim-treesitter.configs').setup {
    sync_install = false,
    ensure_installed = {
      'bash',
      'lua',
      'vim',
      'vimdoc',
      'prisma',
      'typescript',
      'tsx',
      'json',
      'regex',
      'sql',
      'gotmpl',
      'comment',
      'astro',
      'vue',
      'svelte',
      'graphql',
      'markdown',
      'markdown_inline',
      'yaml',
      'css',
      'html',
      'javascript',
      'latex',
      'scss',
      'typst',
    },
    highlight = {
      enable = true,
    },
  }
end

return M

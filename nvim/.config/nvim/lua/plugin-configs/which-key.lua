local M = {}

function M.setup()
  local wk = require 'which-key'

  wk.setup {
    preset = 'modern',
    delay = 300,
    expand = 1,
    notify = false,
    replace = {
      ['<space>'] = 'SPC',
      ['<cr>'] = 'RET',
      ['<tab>'] = 'TAB',
    },
    icons = {
      breadcrumb = '»',
      separator = '➜',
      group = '+',
    },
    layout = {
      height = { min = 4, max = 25 },
      width = { min = 20, max = 50 },
      spacing = 3,
      align = 'left',
    },
    show_help = true,
    show_keys = true,
    disable = {
      buftypes = {},
      filetypes = { 'TelescopePrompt' },
    },
  }

  wk.add {
    { '<leader>f', group = 'Find' },
    { '<leader>ff', desc = 'Find files' },
    { '<leader>fg', desc = 'Live grep' },
    { '<leader>fb', desc = 'Find buffers' },
    { '<leader>fh', desc = 'Find help' },
    { '<leader>fr', desc = 'Resume search' },
    { '<leader>fs', desc = 'Find symbols' },
    { '<leader>fS', desc = 'Find workspace symbols' },
    { '<leader>fc', desc = 'Find commits' },
    { '<leader>fa', desc = 'Find actions' },
    { '<leader>f/', desc = 'Search history' },
    { '<leader>f:', desc = 'Command history' },
    { '<leader>fw', desc = 'Search word under cursor' },
    { '<leader>fy', desc = 'Registers' },

    { '<leader>c', group = 'Code AI' },
    { '<leader>cc', desc = 'Chat with AI' },
    { '<leader>ci', desc = 'Inline AI' },
    { '<leader>ce', desc = 'Explain code', mode = 'v' },

    { '<leader>l', group = 'LSP' },
    { '<leader>la', desc = 'Code actions' },
    { '<leader>ln', desc = 'Rename symbol' },
    { '<leader>lr', desc = 'Restart LSP' },

    { '<leader>x', group = 'Diagnostics' },
    { '<leader>xx', desc = 'Toggle diagnostics' },
    { '<leader>xd', desc = 'Buffer diagnostics' },
    { '<leader>xq', desc = 'Quickfix list' },
    { '<leader>xl', desc = 'Location list' },

    { '<leader>g', group = 'Git' },
    { '<leader>gg', desc = 'LazyGit' },
    { '<leader>gf', desc = 'File history' },
    { '<leader>gl', desc = 'Git log' },

    { '<leader>h', group = 'Git Hunks' },
    { '<leader>hs', desc = 'Stage hunk' },
    { '<leader>hr', desc = 'Reset hunk' },
    { '<leader>hu', desc = 'Undo stage' },
    { '<leader>hR', desc = 'Reset buffer' },
    { '<leader>hp', desc = 'Preview hunk' },
    { '<leader>hb', desc = 'Blame line' },
    { '<leader>hd', desc = 'Diff this' },

    { '<leader>t', group = 'Toggle' },
    { '<leader>tb', desc = 'Toggle blame' },
    { '<leader>td', desc = 'Toggle deleted' },
    { '<leader>ts', desc = 'Toggle spelling' },
    { '<leader>tw', desc = 'Toggle wrap' },
    { '<leader>tL', desc = 'Toggle relative numbers' },
    { '<leader>tD', desc = 'Toggle diagnostics' },
    { '<leader>tl', desc = 'Toggle line numbers' },
    { '<leader>tc', desc = 'Toggle conceallevel' },
    { '<leader>tT', desc = 'Toggle treesitter' },
    { '<leader>tB', desc = 'Toggle background' },
    { '<leader>th', desc = 'Toggle inlay hints' },
    { '<leader>tg', desc = 'Toggle indent guides' },
    { '<leader>tm', desc = 'Toggle dim' },

    { '<leader>u', group = 'Utilities' },
    { '<leader>un', desc = 'Dismiss notifications' },
    { '<leader>ub', desc = 'Notification history' },

    { '<leader>F', desc = 'Format' },
    { '<leader>d', desc = 'Show diagnostic' },
    { '<leader>.', desc = 'Scratch buffer' },
    { '<leader>?', desc = 'Buffer keymaps' },

    { 'g', group = 'Go to' },
    { 'gR', desc = 'Show references' },
    { 'gD', desc = 'Go to declaration' },
    { 'gd', desc = 'Show definitions' },
    { 'gi', desc = 'Show implementations' },
    { 'gt', desc = 'Show type definitions' },

    { ']', group = 'Next' },
    { ']d', desc = 'Next diagnostic' },
    { ']]', desc = 'Next reference' },

    { '[', group = 'Previous' },
    { '[d', desc = 'Previous diagnostic' },
    { '[[', desc = 'Previous reference' },

    { 'K', desc = 'Hover documentation' },
  }
end

return M

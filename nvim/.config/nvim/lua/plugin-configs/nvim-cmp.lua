local M = {}

function M.setup()
  local cmp = require 'cmp'
  local luasnip = require 'luasnip'

  -- loads vscode style snippets from installed plugins (e.g. friendly-snippets)
  require('luasnip.loaders.from_vscode').lazy_load()

  local cmp_select = { behavior = cmp.SelectBehavior.Select }

  cmp.setup {
    completion = {
      completeopt = 'menu,menuone,preview,noselect',
    },
    formatting = {
      format = require('lspkind').cmp_format {
        mode = 'symbol',
        max_width = 50,
        symbol_map = { Supermaven = '' },
      },
    },
    snippet = { -- configure how nvim-cmp interacts with snippet engine
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    sources = {
      { name = 'nvim_lsp' },
      { name = 'supermaven' },
      { name = 'luasnip' },
      { name = 'buffer' },
      { name = 'path' },
      { name = 'nvim_lua' },
    },
    mapping = cmp.mapping.preset.insert {
      ['<C-k>'] = cmp.mapping.select_prev_item(cmp_select),
      ['<C-j>'] = cmp.mapping.select_next_item(cmp_select),
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm { select = true },
    },
  }
end

return M

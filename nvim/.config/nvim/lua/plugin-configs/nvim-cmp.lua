local M = {}

function M.setup()
  local cmp = require 'cmp'
  local luasnip = require 'luasnip'
  local lsp_zero = require 'lsp-zero'

  -- loads vscode style snippets from installed plugins (e.g. friendly-snippets)
  require('luasnip.loaders.from_vscode').lazy_load()

  local cmp_select = { behavior = cmp.SelectBehavior.Select }

  cmp.setup {
    completion = {
      completeopt = 'menu,menuone,preview,noselect',
    },
    snippet = { -- configure how nvim-cmp interacts with snippet engine
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    sources = {
      { name = 'codeium' },
      { name = 'luasnip' },
      { name = 'buffer' },
      { name = 'path' },
      { name = 'nvim_lsp' },
      { name = 'nvim_lua' },
    },
    formatting = lsp_zero.cmp_format(),
    mapping = cmp.mapping.preset.insert {
      ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
      ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
      ['<C-y>'] = cmp.mapping.confirm { select = true },
      ['<C-Space>'] = cmp.mapping.complete(),
    },
  }
end

return M

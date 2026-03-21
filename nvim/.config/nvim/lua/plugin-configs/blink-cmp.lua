local M = {}

function M.setup()
  local blink = require 'blink.cmp'

  blink.setup {
    enabled = function()
      return vim.bo.filetype ~= 'markdown' and vim.bo.buftype ~= 'prompt' and vim.b.completion ~= false
    end,
    keymap = {
      preset = 'default',
      -- C-Space forces LSP-only completions so you get actual props/types,
      -- not a mix of buffer words
      ['<C-Space>'] = {
        function(cmp)
          cmp.show { providers = { 'lsp' } }
        end,
      },
    },
    completion = {
      keyword = { range = 'full' },
      accept = { auto_brackets = { enabled = false } },
      list = { selection = { preselect = false, auto_insert = true } },
      documentation = { auto_show = true, auto_show_delay_ms = 500 },
    },
    sources = {
      default = { 'lsp', 'path', 'buffer' },
      providers = {
        -- Only show buffer completions when the keyword is 4+ chars long,
        -- preventing buffer words from polluting short-trigger completions
        buffer = {
          min_keyword_length = 4,
          score_offset = -5, -- rank buffer completions lower than LSP
        },
        lsp = {
          score_offset = 5, -- ensure LSP completions rank highest
          -- Sort items by TypeScript's sortText field before blink re-ranks.
          -- ts/vtsls assigns "0..." to component-specific props and "1..."/higher
          -- to inherited HTML globals, so a plain string sort puts custom props first.
          transform_items = function(_, items)
            -- Filter out deprecated items (LSP tag 1 = deprecated)
            local filtered = vim.tbl_filter(function(item)
              local tags = item.deprecated or (item.tags and vim.tbl_contains(item.tags, 1))
              return not tags
            end, items)
            -- Stable-sort by sortText to honour the LSP's intended ranking
            table.sort(filtered, function(a, b)
              return (a.sortText or a.label) < (b.sortText or b.label)
            end)
            return filtered
          end,
        },
      },
    },
    signature = { enabled = true },
  }
end

return M

local M = {}

function M.setup()
  local blink = require 'blink.cmp'

  blink.setup {
    enabled = function()
      return not vim.tbl_contains({ 'lua', 'markdown' }, vim.bo.filetype) and vim.bo.buftype ~= 'prompt' and vim.b.completion ~= false
    end,
    keymap = { preset = 'default' },
    completion = {
      keyword = { range = 'full' },
      accept = { auto_brackets = { enabled = false } },
      list = { selection = 'auto_insert' },
      -- Show documentation when selecting a completion item
      documentation = { auto_show = true, auto_show_delay_ms = 500 },
    },
    signature = { enabled = true },
  }
end

return M

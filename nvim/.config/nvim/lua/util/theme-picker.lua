local M = {}

local state_file = vim.fn.stdpath 'data' .. '/colorscheme.txt'

-- Each entry: { text = "display name", load = function() ... end }
-- The display name is what gets persisted to disk.
M.themes = {
  -- Kanso
  {
    text = 'kanso-ink',
    load = function()
      vim.cmd.colorscheme 'kanso-ink'
    end,
  },
  {
    text = 'kanso-zen',
    load = function()
      vim.cmd.colorscheme 'kanso-zen'
    end,
  },
  {
    text = 'kanso',
    load = function()
      vim.cmd.colorscheme 'kanso'
    end,
  },

  -- Black Metal
  {
    text = 'bathory',
    load = function()
      require('black-metal').setup { theme = 'bathory', alt_bg = false }
      require('black-metal').load()
    end,
  },
  {
    text = 'bathory-alt',
    load = function()
      require('black-metal').setup { theme = 'bathory', alt_bg = true }
      require('black-metal').load()
    end,
  },
  {
    text = 'burzum',
    load = function()
      require('black-metal').setup { theme = 'burzum', alt_bg = false }
      require('black-metal').load()
    end,
  },
  {
    text = 'burzum-alt',
    load = function()
      require('black-metal').setup { theme = 'burzum', alt_bg = true }
      require('black-metal').load()
    end,
  },
  {
    text = 'dark-funeral',
    load = function()
      require('black-metal').setup { theme = 'dark-funeral', alt_bg = false }
      require('black-metal').load()
    end,
  },
  {
    text = 'dark-funeral-alt',
    load = function()
      require('black-metal').setup { theme = 'dark-funeral', alt_bg = true }
      require('black-metal').load()
    end,
  },
  {
    text = 'darkthrone',
    load = function()
      require('black-metal').setup { theme = 'darkthrone', alt_bg = false }
      require('black-metal').load()
    end,
  },
  {
    text = 'emperor',
    load = function()
      require('black-metal').setup { theme = 'emperor', alt_bg = false }
      require('black-metal').load()
    end,
  },
  {
    text = 'emperor-alt',
    load = function()
      require('black-metal').setup { theme = 'emperor', alt_bg = true }
      require('black-metal').load()
    end,
  },
  {
    text = 'gorgoroth',
    load = function()
      require('black-metal').setup { theme = 'gorgoroth', alt_bg = false }
      require('black-metal').load()
    end,
  },
  {
    text = 'gorgoroth-alt',
    load = function()
      require('black-metal').setup { theme = 'gorgoroth', alt_bg = true }
      require('black-metal').load()
    end,
  },
  {
    text = 'immortal',
    load = function()
      require('black-metal').setup { theme = 'immortal', alt_bg = false }
      require('black-metal').load()
    end,
  },
  {
    text = 'immortal-alt',
    load = function()
      require('black-metal').setup { theme = 'immortal', alt_bg = true }
      require('black-metal').load()
    end,
  },
  {
    text = 'impaled-nazarene',
    load = function()
      require('black-metal').setup { theme = 'impaled-nazarene', alt_bg = false }
      require('black-metal').load()
    end,
  },
  {
    text = 'impaled-nazarene-alt',
    load = function()
      require('black-metal').setup { theme = 'impaled-nazarene', alt_bg = true }
      require('black-metal').load()
    end,
  },
  {
    text = 'khold',
    load = function()
      require('black-metal').setup { theme = 'khold', alt_bg = false }
      require('black-metal').load()
    end,
  },
  {
    text = 'khold-alt',
    load = function()
      require('black-metal').setup { theme = 'khold', alt_bg = true }
      require('black-metal').load()
    end,
  },
  {
    text = 'marduk',
    load = function()
      require('black-metal').setup { theme = 'marduk', alt_bg = false }
      require('black-metal').load()
    end,
  },
  {
    text = 'marduk-alt',
    load = function()
      require('black-metal').setup { theme = 'marduk', alt_bg = true }
      require('black-metal').load()
    end,
  },
  {
    text = 'mayhem',
    load = function()
      require('black-metal').setup { theme = 'mayhem', alt_bg = false }
      require('black-metal').load()
    end,
  },
  {
    text = 'mayhem-alt',
    load = function()
      require('black-metal').setup { theme = 'mayhem', alt_bg = true }
      require('black-metal').load()
    end,
  },
  {
    text = 'nile',
    load = function()
      require('black-metal').setup { theme = 'nile', alt_bg = false }
      require('black-metal').load()
    end,
  },
  {
    text = 'nile-alt',
    load = function()
      require('black-metal').setup { theme = 'nile', alt_bg = true }
      require('black-metal').load()
    end,
  },
  {
    text = 'taake',
    load = function()
      require('black-metal').setup { theme = 'taake', alt_bg = false }
      require('black-metal').load()
    end,
  },
  {
    text = 'taake-alt',
    load = function()
      require('black-metal').setup { theme = 'taake', alt_bg = true }
      require('black-metal').load()
    end,
  },
  {
    text = 'thyrfing',
    load = function()
      require('black-metal').setup { theme = 'thyrfing', alt_bg = false }
      require('black-metal').load()
    end,
  },
  {
    text = 'thyrfing-alt',
    load = function()
      require('black-metal').setup { theme = 'thyrfing', alt_bg = true }
      require('black-metal').load()
    end,
  },
  {
    text = 'venom',
    load = function()
      require('black-metal').setup { theme = 'venom', alt_bg = false }
      require('black-metal').load()
    end,
  },
  {
    text = 'venom-alt',
    load = function()
      require('black-metal').setup { theme = 'venom', alt_bg = true }
      require('black-metal').load()
    end,
  },
  {
    text = 'windir',
    load = function()
      require('black-metal').setup { theme = 'windir', alt_bg = false }
      require('black-metal').load()
    end,
  },
  {
    text = 'windir-alt',
    load = function()
      require('black-metal').setup { theme = 'windir', alt_bg = true }
      require('black-metal').load()
    end,
  },

  -- Neomodern
  {
    text = 'moon',
    load = function()
      require('neomodern').load 'moon'
    end,
  },
  {
    text = 'iceclimber',
    load = function()
      require('neomodern').load 'iceclimber'
    end,
  },
  {
    text = 'gyokuro',
    load = function()
      require('neomodern').load 'gyokuro'
    end,
  },
  {
    text = 'hojicha',
    load = function()
      require('neomodern').load 'hojicha'
    end,
  },
  {
    text = 'roseprime',
    load = function()
      require('neomodern').load 'roseprime'
    end,
  },

  -- Monokai Pro
  {
    text = 'monokai-pro',
    load = function()
      require('monokai-pro').setup { filter = 'pro' }
      vim.cmd.colorscheme 'monokai-pro'
    end,
  },
  {
    text = 'monokai-pro-classic',
    load = function()
      require('monokai-pro').setup { filter = 'classic' }
      vim.cmd.colorscheme 'monokai-pro'
    end,
  },
  {
    text = 'monokai-pro-machine',
    load = function()
      require('monokai-pro').setup { filter = 'machine' }
      vim.cmd.colorscheme 'monokai-pro'
    end,
  },
  {
    text = 'monokai-pro-octagon',
    load = function()
      require('monokai-pro').setup { filter = 'octagon' }
      vim.cmd.colorscheme 'monokai-pro'
    end,
  },
  {
    text = 'monokai-pro-ristretto',
    load = function()
      require('monokai-pro').setup { filter = 'ristretto' }
      vim.cmd.colorscheme 'monokai-pro'
    end,
  },
  {
    text = 'monokai-pro-spectrum',
    load = function()
      require('monokai-pro').setup { filter = 'spectrum' }
      vim.cmd.colorscheme 'monokai-pro'
    end,
  },
}

local _by_name = {}
for _, t in ipairs(M.themes) do
  _by_name[t.text] = t
end

function M.save(name)
  pcall(vim.fn.writefile, { name }, state_file)
end

function M.load()
  local ok, lines = pcall(vim.fn.readfile, state_file)
  if ok and lines and lines[1] and lines[1] ~= '' then
    local entry = _by_name[lines[1]]
    if entry then
      pcall(entry.load)
      return
    end
  end
  -- Fallback: kanso-ink on first run or if the saved name is gone.
  pcall(vim.cmd.colorscheme, 'kanso-ink')
end

function M.pick()
  local original = vim.g.colors_name
  -- Also snapshot the active theme entry so we can fully restore plugin state.
  local original_entry = _by_name[original]
  local confirmed = false

  -- Read the persisted name once at open time so the indicator is stable
  -- while browsing. Falls back to the raw colorscheme name if no file exists.
  local saved_name = original
  local ok, lines = pcall(vim.fn.readfile, state_file)
  if ok and lines and lines[1] and lines[1] ~= '' then
    saved_name = lines[1]
  end

  -- Use the current buffer's file for the preview pane so you see your own
  -- code syntax-highlighted in each theme as you browse. Falls back to no
  -- preview if the current buffer has no associated file (scratch, etc.).
  local preview_file = vim.api.nvim_buf_get_name(0)
  local has_file = preview_file ~= ''

  Snacks.picker.pick {
    title = '  Themes',
    preview = has_file and 'file' or false,
    items = vim.tbl_map(function(t)
      return {
        text = t.text,
        file = has_file and preview_file or nil,
      }
    end, M.themes),

    format = function(item)
      local active = item.text == saved_name
      return {
        { active and '● ' or '  ', active and 'Special' or 'Comment' },
        { item.text, active and 'Special' or 'Normal' },
      }
    end,

    -- Live preview as the cursor moves through the list.
    on_change = function(_, item)
      if item then
        local entry = _by_name[item.text]
        if entry then
          pcall(entry.load)
        end
      end
    end,

    confirm = function(picker, item)
      confirmed = true
      picker:close()
      if item then
        local entry = _by_name[item.text]
        if entry then
          pcall(entry.load)
          M.save(item.text)
        end
      else
        -- Confirmed with no selection — restore original.
        if original_entry then
          pcall(original_entry.load)
        else
          pcall(vim.cmd.colorscheme, original)
        end
      end
    end,

    -- Escape / q without confirming — restore the original theme.
    on_close = function()
      if not confirmed then
        if original_entry then
          pcall(original_entry.load)
        else
          pcall(vim.cmd.colorscheme, original)
        end
      end
    end,
  }
end

return M

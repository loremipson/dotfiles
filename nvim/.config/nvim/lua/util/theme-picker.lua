local M = {}

local state_file = vim.fn.stdpath 'data' .. '/colorscheme.txt'

-- ============================================================
-- 1) Plugins that ship one colors/*.{lua,vim} file per variant
--  sans the default colorschemes that ship with vim/neovim
-- ============================================================
local function is_builtin_only(name)
  local files = vim.api.nvim_get_runtime_file('colors/' .. name .. '.{vim,lua}', true)
  if #files == 0 then
    return false
  end
  for _, f in ipairs(files) do
    if not vim.startswith(f, vim.env.VIMRUNTIME) then
      return false
    end
  end
  return true
end

-- Derive a group label from the plugin directory the colors/ file lives in
-- (e.g. .../lazy/kanso.nvim/colors/kanso-ink.lua -> "kanso.nvim")
local function runtime_group(name)
  local files = vim.api.nvim_get_runtime_file('colors/' .. name .. '.{vim,lua}', false)
  local f = files[1]
  if not f then
    return 'other'
  end
  return f:match '([^/\\]+)[/\\]colors[/\\][^/\\]+$' or 'other'
end

local function native_colorschemes(exclude)
  local entries = {}
  for _, name in ipairs(vim.fn.getcompletion('', 'color')) do
    if not exclude[name] and not is_builtin_only(name) then
      table.insert(entries, {
        text = name,
        group = runtime_group(name),
        load = function()
          vim.cmd.colorscheme(name)
        end,
      })
    end
  end
  return entries
end

-- ============================================================
-- 2) Plugins whose variants are selected through their own Lua
--    API rather than a colors/ file.
-- ============================================================

local function black_metal_entries()
  local variants = {
    'bathory',
    'burzum',
    'dark-funeral',
    'darkthrone',
    'emperor',
    'gorgoroth',
    'immortal',
    'impaled-nazarene',
    'khold',
    'marduk',
    'mayhem',
    'nile',
    'taake',
    'thyrfing',
    'venom',
    'windir',
  }
  local entries = {}
  for _, name in ipairs(variants) do
    for _, alt in ipairs { false, true } do
      table.insert(entries, {
        text = alt and (name .. '-alt') or name,
        group = 'black-metal-theme-neovim',
        load = function()
          require('black-metal').setup { theme = name, alt_bg = alt }
          require('black-metal').load()
        end,
      })
    end
  end
  return entries
end

-- We can't rely on nvim_get_runtime_file here: base46 is lazy-loaded with
-- no trigger, and a lazy plugin's own directory only lands on the
-- runtimepath once something has actually require()'d it
local function discover_base46_themes()
  local plugin_dir
  local ok, lazy_config = pcall(require, 'lazy.core.config')
  if ok and lazy_config.plugins.base46 then
    plugin_dir = lazy_config.plugins.base46.dir
  else
    plugin_dir = vim.fn.stdpath 'data' .. '/lazy/base46'
  end

  local names = {}
  for _, f in ipairs(vim.fn.glob(plugin_dir .. '/lua/base46/themes/*.lua', false, true)) do
    table.insert(names, vim.fn.fnamemodify(f, ':t:r'))
  end
  table.sort(names)
  return names
end

local function base46_entries()
  local variants = discover_base46_themes()
  local entries = {}
  for _, name in ipairs(variants) do
    table.insert(entries, {
      text = name,
      group = 'base46',
      load = function()
        -- Unlike vim.cmd.colorscheme(), base46's load() never does a full
        -- highlight reset first. Without clearing first, any group the
        -- *previous* theme set (dark borders, etc.) survives untouched and
        -- bleeds through into the new theme. `:colorscheme` does this
        -- implicitly.. base46 needs it done by hand.
        vim.cmd 'hi clear'
        if vim.fn.exists 'syntax_on' == 1 then
          vim.cmd 'syntax reset'
        end
        require('base46').load(name)
        -- base46 also never sets colors_name, so M.pick()'s "restore
        -- original theme on Escape" logic (which reads vim.g.colors_name)
        -- would otherwise stay stuck on whatever was active before the
        -- *first* base46 theme this session.
        vim.g.colors_name = name
      end,
    })
  end
  return entries
end

local function neomodern_entries()
  local variants = { 'moon', 'iceclimber', 'gyokuro', 'hojicha', 'roseprime' }
  local entries = {}
  for _, name in ipairs(variants) do
    table.insert(entries, {
      text = name,
      group = 'neomodern.nvim',
      load = function()
        require('neomodern').load(name)
      end,
    })
  end
  return entries
end

local function monokai_pro_entries()
  local filters = { 'pro', 'classic', 'machine', 'octagon', 'ristretto', 'spectrum' }
  local entries = {}
  for _, filter in ipairs(filters) do
    table.insert(entries, {
      text = filter == 'pro' and 'monokai-pro' or ('monokai-pro-' .. filter),
      group = 'monokai-pro',
      load = function()
        -- Note: vim.cmd.colorscheme('monokai-pro') won't reapply a changed
        -- filter once 'monokai-pro' is already the active colorscheme name.
        -- The plugin's own load() bypasses that and re-renders from the
        -- current config every time, which is what we actually want here.
        require('monokai-pro').setup { filter = filter }
        require('monokai-pro').load()
      end,
    })
  end
  return entries
end

-- ============================================================
-- Assemble the full list. Manually-generated entries are built
-- first so we can exclude their names from the native scan
-- ============================================================
local manual = {}
vim.list_extend(manual, black_metal_entries())
vim.list_extend(manual, base46_entries())
vim.list_extend(manual, neomodern_entries())
vim.list_extend(manual, monokai_pro_entries())

local exclude = {}
for _, t in ipairs(manual) do
  exclude[t.text] = true
end

M.themes = {}
vim.list_extend(M.themes, native_colorschemes(exclude))
vim.list_extend(M.themes, manual)

table.sort(M.themes, function(a, b)
  if a.group ~= b.group then
    return a.group < b.group
  end
  return a.text < b.text
end)

local _by_name = {}
for _, t in ipairs(M.themes) do
  _by_name[t.text] = t
end

local function apply_theme(entry)
  local ok = pcall(entry.load)
  if ok then
    pcall(vim.api.nvim_exec_autocmds, 'ColorScheme', { modeline = false })
  end
  return ok
end

function M.save(name)
  pcall(vim.fn.writefile, { name }, state_file)
end

function M.load()
  local ok, lines = pcall(vim.fn.readfile, state_file)
  if ok and lines and lines[1] and lines[1] ~= '' then
    local entry = _by_name[lines[1]]
    if entry then
      apply_theme(entry)
      return
    end
  end
  -- Fallback: kanso on first run or if the saved name is gone.
  pcall(vim.cmd.colorscheme, 'kanso')
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
        -- `text` is what plain, unprefixed typing matches against, so
        -- folding the group in here means typing "base46" or "kanso" alone
        -- narrows straight to that plugin's themes. `name` keeps the pure
        -- theme identifier around for lookups/display, since `text` is no
        -- longer just that.
        text = t.group .. ' ' .. t.text,
        name = t.text,
        group = t.group,
        file = has_file and preview_file or nil,
      }
    end, M.themes),

    -- Themes are pre-sorted by group (see table.sort above), so items from
    -- the same plugin already sit together -- this just labels each line.
    -- Deliberately not trying to print a header only once per group: the
    -- picker may re-render items out of viewport order while scrolling, and
    -- state tracked across format() calls would get out of sync with that.
    format = function(item)
      local active = item.name == saved_name
      return {
        { active and '● ' or '  ', active and 'Special' or 'Comment' },
        { string.format('%-24s', item.group), 'Comment' },
        { item.name, active and 'Special' or 'Normal' },
      }
    end,

    -- Live preview as the cursor moves through the list.
    on_change = function(_, item)
      if item then
        local entry = _by_name[item.name]
        if entry then
          apply_theme(entry)
        end
      end
    end,

    confirm = function(picker, item)
      confirmed = true
      picker:close()
      if item then
        local entry = _by_name[item.name]
        if entry then
          apply_theme(entry)
          M.save(item.name)
        end
      else
        -- Confirmed with no selection — restore original.
        if original_entry then
          apply_theme(original_entry)
        else
          pcall(vim.cmd.colorscheme, original)
        end
      end
    end,

    -- Escape / q without confirming — restore the original theme.
    on_close = function()
      if not confirmed then
        if original_entry then
          apply_theme(original_entry)
        else
          pcall(vim.cmd.colorscheme, original)
        end
      end
    end,
  }
end

return M

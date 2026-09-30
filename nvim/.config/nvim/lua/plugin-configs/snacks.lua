local M = {}
function M.setup()
  local snacks = require 'snacks'
  snacks.setup {
    indent = {
      enabled = true,
      chunk = {
        enabled = true,
      },
    },
    scroll = { enabled = true },
    dashboard = {
      enabled = true,
      preset = {
        header = [[
            █                                                █            
             █    █                                         █   █         
             ██    █                                  █    █   █          
          █  █      █                █       █   █   █     █  █           
           █ █    ██  █     █   █    █       █      █      ███            
           ████   █    █████  █████   █     █    █  ██     ████           
            ██ █  ██  ██     █     █  █     █   ██  ███   █ ██            
            ██  █ ██  █████  █     █  ██   ██    █  ██ █ █  ██            
            ██   ███  ██     █     █  ███ ███    █  ██ ███  ██            
            ██    ██  ██   █ ██   ██   █████    ██  ██  █   ███           
            ██     █  █████    ███      ███    ██  ████     ███           
           ███     █    █  █  █          █    █     █       ███           
          ██ ██     ██   █     █          █        █       ██  ██         
         █     █     █                     █      █       █     █         
        █       █     █                          █       █       █        
         █       █                                      █         █       
          █                                            █         █         ]],
      },
      sections = {
        { section = 'header' },
        { section = 'keys',   gap = 1, padding = 1 },
        { section = 'startup' },
      },
    },
    statuscolumn = {
      enabled = true,
      left = { 'mark', 'sign' },
      right = { 'fold', 'git' },
      folds = {
        open = false,
        git_hl = false,
      },
      git = {
        patterns = { 'GitSign', 'MiniDiffSign' },
      },
      refresh = 50,
    },
    picker = {
      enabled = true,
      sources = {
        grep = {
          hidden = true,
          ignored = false,
        },
      },
      actions = {
        ---@param picker snacks.Picker
        opencode_send = function(picker)
          local items = vim.tbl_map(function(item) ---@param item snacks.picker.Item
            return item.file and require('opencode').format { path = item.file, from = item.pos, to = item.end_pos } or
                item.text
          end, picker:selected { fallback = true })

          require('opencode').prompt(table.concat(items, ', ') .. ' ')
        end,
      },
      win = {
        input = {
          keys = {
            ['<a-a>'] = { 'opencode_send', mode = { 'n', 'i' } },
          },
          -- works around snacks#2810 (cursor jumps left in live grep)
          wo = { virtualedit = 'onemore' },
        },
      },
    },
    -- explorer = { enabled = true, replace_netrw = true, auto_close = true },
    input = { enabled = true },
    notifier = { enabled = true },
    words = { enabled = true },
    scratch = { enabled = false },
  }

  vim.keymap.set('n', '<leader>.', function()
    snacks.scratch()
  end, { desc = 'Toggle scratch buffer' })

  vim.keymap.set('n', '<leader>S', function()
    snacks.scratch.select()
  end, { desc = 'Select scratch buffer' })

  vim.keymap.set('n', '<leader>ub', function()
    snacks.notifier.show_history()
  end, { desc = 'Notification history' })

  vim.keymap.set('n', '<leader>un', function()
    snacks.notifier.hide()
  end, { desc = 'Dismiss all notifications' })

  vim.keymap.set('n', ']]', function()
    snacks.words.jump(vim.v.count1)
  end, { desc = 'Next reference' })
  vim.keymap.set('n', '[[', function()
    snacks.words.jump(-vim.v.count1)
  end, { desc = 'Previous reference' })

  vim.keymap.set('n', '<leader>cs', function()
    require('util.theme-picker').pick()
  end, { desc = 'Color scheme picker' })

  vim.keymap.set('n', '<leader>ff', function()
    snacks.picker.files { hidden = true }
  end, { desc = 'Fuzzy find files in cwd' })

  vim.keymap.set('n', '<leader>fg', function()
    snacks.picker.grep()
  end, { desc = 'Fuzzy grep in cwd' })

  vim.keymap.set('n', '<leader>fb', function()
    snacks.picker.buffers()
  end, { desc = 'Fuzzy find buffers' })

  vim.keymap.set('n', '<leader>fh', function()
    snacks.picker.help()
  end, { desc = 'Fuzzy find help tags' })

  vim.keymap.set('n', '<leader>fr', function()
    snacks.picker.resume()
  end, { desc = 'Resume the last picker search' })

  vim.keymap.set('n', '<leader>fs', function()
    snacks.picker.lsp_symbols()
  end, { desc = 'Fuzzy find symbols in current buffer' })

  vim.keymap.set('n', '<leader>fS', function()
    snacks.picker.lsp_workspace_symbols()
  end, { desc = 'Fuzzy find workspace symbols' })

  vim.keymap.set('n', '<leader>fc', function()
    snacks.picker.git_log()
  end, { desc = 'Fuzzy find git commits' })

  vim.keymap.set('n', '<leader>fw', function()
    snacks.picker.grep_word()
  end, { desc = 'Search word under cursor' })

  vim.keymap.set('n', '<leader>fy', function()
    snacks.picker.registers()
  end, { desc = 'Registers' })

  vim.keymap.set('n', '<leader>f/', function()
    snacks.picker.search_history()
  end, { desc = 'Search history' })

  vim.keymap.set('n', '<leader>f:', function()
    snacks.picker.command_history()
  end, { desc = 'Command history' })

  vim.keymap.set('n', '<leader>xx', function()
    snacks.picker.diagnostics()
  end, { desc = 'Diagnostics' })

  vim.keymap.set('n', '<leader>xd', function()
    snacks.picker.diagnostics_buffer()
  end, { desc = 'Buffer diagnostics' })

  vim.keymap.set('n', '<leader>xq', function()
    snacks.picker.qflist()
  end, { desc = 'Quickfix list' })

  vim.keymap.set('n', '<leader>xl', function()
    snacks.picker.loclist()
  end, { desc = 'Location list' })

  vim.api.nvim_create_autocmd('User', {
    pattern = 'VeryLazy',
    callback = function()
      -- Global debug helpers
      _G.dd = function(...)
        snacks.debug.inspect(...)
      end
      _G.bt = function()
        snacks.debug.backtrace()
      end
      vim.print = _G.dd -- Makes the `:=` command use snacks for output

      -- Toggle mappings with their descriptions
      snacks.toggle.option('spell', { name = 'Spelling' }):map '<leader>ts'
      snacks.toggle.option('wrap', { name = 'Wrap' }):map '<leader>tw'
      snacks.toggle.option('relativenumber', { name = 'Relative Number' }):map '<leader>tL'
      snacks.toggle.diagnostics():map '<leader>tD'
      snacks.toggle.line_number():map '<leader>tl'
      snacks.toggle
          .option('conceallevel', {
            off = 0,
            on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2,
          })
          :map '<leader>tc'
      snacks.toggle.treesitter():map '<leader>tT'
      snacks.toggle
          .option('background', {
            off = 'light',
            on = 'dark',
            name = 'Dark Background',
          })
          :map '<leader>tB'
      snacks.toggle.inlay_hints():map '<leader>th'
      snacks.toggle.indent():map '<leader>tg'
      snacks.toggle.dim():map '<leader>tm'
    end,
  })
end

return M

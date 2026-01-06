local M = {}
function M.setup()
  local snacks = require 'snacks'
  snacks.setup {
    indent = { enabled = true },
    lazygit = { enabled = true },
    scroll = { enabled = true },
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
    picker = { enabled = true },
    -- explorer = { enabled = true, replace_netrw = true, auto_close = true },
    input = { enabled = true },
    notifier = { enabled = true },
    words = { enabled = true },
    scratch = {
      win_by_ft = {
        typescript = {
          keys = {
            ['source'] = {
              '<cr>',
              function(self)
                local namespace = vim.api.nvim_create_namespace 'node_result'
                vim.api.nvim_buf_clear_namespace(self.buf, namespace, 0, -1)

                -- Inject script that makes console log output line numbers.
                local script = [[
                  'use strict';

                  const path = require('path');

                  ['debug', 'log', 'warn', 'error'].forEach((methodName) => {
                      const originalLoggingMethod = console[methodName];
                      console[methodName] = (firstArgument, ...otherArguments) => {
                          const originalPrepareStackTrace = Error.prepareStackTrace;
                          Error.prepareStackTrace = (_, stack) => stack;
                          const callee = new Error().stack[1];
                          Error.prepareStackTrace = originalPrepareStackTrace;
                          const relativeFileName = path.relative(process.cwd(), callee.getFileName());
                          const prefix = `${relativeFileName}:${callee.getLineNumber()}:`;
                          if (typeof firstArgument === 'string') {
                              originalLoggingMethod(prefix + ' ' + firstArgument, ...otherArguments);
                          } else {
                              originalLoggingMethod(prefix, firstArgument, ...otherArguments);
                          }
                      };
                  });
                ]]
                for _, line in pairs(vim.api.nvim_buf_get_lines(self.buf, 0, -1, true)) do
                  script = script .. line .. '\n'
                end

                local result = require('plenary.job')
                  :new({
                    command = 'node',
                    args = { '-e', script },
                  })
                  :sync()

                if result then
                  for _, line in pairs(result) do
                    local line_number, output = line:match '%[eval%]:(%d+): (.*)'
                    -- Subtract the lines of the injected script.
                    vim.api.nvim_buf_set_extmark(0, namespace, line_number - 21, 0, {
                      virt_text = { { output, 'Comment' } },
                    })
                  end
                end
              end,
              desc = 'Source buffer',
              mode = { 'n', 'x' },
            },
          },
        },
      },
    },
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

  vim.keymap.set('n', '<leader>gf', function()
    snacks.lazygit.log_file()
  end, { desc = 'Lazygit current file history' })

  vim.keymap.set('n', '<leader>gg', function()
    snacks.lazygit()
  end, { desc = 'Lazygit' })

  vim.keymap.set('n', '<leader>gl', function()
    snacks.lazygit.log()
  end, { desc = 'Lazygit log (cmd)' })

  vim.keymap.set('n', ']]', function()
    snacks.words.jump(vim.v.count1)
  end, { desc = 'Next reference' })
  vim.keymap.set('n', '[[', function()
    snacks.words.jump(-vim.v.count1)
  end, { desc = 'Previous reference' })

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

local M = {}

function M.icons()
  require('mini.icons').setup()
  MiniIcons.mock_nvim_web_devicons()
end

function M.ai()
  require('mini.ai').setup { n_lines = 500 }
end

function M.pairs()
  require('mini.pairs').setup()
end

function M.jump()
  require('mini.jump').setup()
end

function M.files()
  require('mini.files').setup()

  vim.keymap.set('n', '-', function()
    if MiniFiles.close() then
      return
    end

    local path = vim.api.nvim_buf_get_name(0)
    MiniFiles.open(path ~= '' and path or nil)
  end, { desc = 'Toggle file explorer' })
end

function M.hipatterns()
  local hipatterns = require 'mini.hipatterns'
  local keyword_patterns = function(keywords)
    return vim.tbl_map(function(keyword)
      return '%f[%w]()' .. keyword .. '()%f[%W]'
    end, keywords)
  end

  hipatterns.setup {
    highlighters = {
      fixme = {
        pattern = keyword_patterns { 'FIX', 'FIXME', 'BUG', 'FIXIT', 'ISSUE' },
        group = 'MiniHipatternsFixme',
      },
      hack = { pattern = keyword_patterns { 'HACK' }, group = 'MiniHipatternsHack' },
      todo = { pattern = keyword_patterns { 'TODO' }, group = 'MiniHipatternsTodo' },
      note = { pattern = keyword_patterns { 'NOTE', 'INFO', 'HINT' }, group = 'MiniHipatternsNote' },
      warn = { pattern = keyword_patterns { 'WARN', 'WARNING', 'XXX' }, group = 'DiagnosticWarn' },
      perf = { pattern = keyword_patterns { 'PERF', 'OPTIM', 'PERFORMANCE', 'OPTIMIZE' }, group = 'DiagnosticInfo' },
      test = { pattern = keyword_patterns { 'TEST', 'TESTING', 'PASSED', 'FAILED' }, group = 'DiagnosticHint' },
    },
  }
end

function M.clue()
  local clue = require 'mini.clue'

  clue.setup {
    triggers = {
      { mode = { 'n', 'x' }, keys = '<Leader>' },
      { mode = 'n',          keys = '[' },
      { mode = 'n',          keys = ']' },
      { mode = { 'n', 'x' }, keys = 'g' },
    },
    clues = {
      clue.gen_clues.square_brackets(),
      clue.gen_clues.g(),
      { mode = 'n', keys = '<Leader>f', desc = '+Find' },
      { mode = 'n', keys = '<Leader>l', desc = '+LSP' },
      { mode = 'n', keys = '<Leader>x', desc = '+Diagnostics' },
      { mode = 'n', keys = '<Leader>h', desc = '+Git Hunks' },
      { mode = 'n', keys = '<Leader>t', desc = '+Toggle' },
      { mode = 'n', keys = '<Leader>u', desc = '+Utilities' },
      { mode = 'n', keys = '<Leader>o', desc = '+OpenCode' },
      { mode = 'n', keys = '<Leader>r', desc = '+Rust' },
      { mode = 'n', keys = '<Leader>z', desc = '+Diff' },
    },
    window = {
      delay = 300,
      config = {
        border = 'rounded',
        width = 'auto',
      },
    },
  }

  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('user_mini_clue', { clear = true }),
    callback = function(args)
      vim.schedule(function()
        clue.ensure_buf_triggers(args.buf)
      end)
    end,
  })
end

function M.surround()
  require('mini.surround').setup {
    mappings = {
      add = 'ys',
      delete = 'ds',
      replace = 'cs',
    },
    search_method = 'cover_or_next',
  }

  vim.keymap.del('x', 'ys')
  vim.keymap.set('x', 'S', [[:<C-u>lua MiniSurround.add('visual')<CR>]], { silent = true })
  vim.keymap.set('n', 'yss', 'ys_', { remap = true })
end

function M.completion()
  local completion = require 'mini.completion'

  completion.setup {
    lsp_completion = {
      process_items = function(items, base)
        return completion.default_process_items(items, base, {
          kind_priority = { Snippet = 0 },
        })
      end,
    },
    window = {
      info = { border = 'rounded' },
      signature = { border = 'rounded' },
    },
  }

  vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('user_mini_completion', { clear = true }),
    pattern = 'snacks_picker_input',
    callback = function(args)
      vim.b[args.buf].minicompletion_disable = true
    end,
  })

  vim.keymap.set('i', '<CR>', function()
    local completion = vim.fn.complete_info()
    if completion.pum_visible == 1 then
      return completion.selected == -1 and '<C-n><C-y>' or '<C-y>'
    end
    return MiniPairs and MiniPairs.cr() or '<CR>'
  end, { expr = true })

  vim.keymap.set('i', '<Esc>', function()
    return vim.fn.pumvisible() == 1 and '<C-e><Esc>' or '<Esc>'
  end, { expr = true })
end

return M

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

function M.snippets()
  local snippets = require 'mini.snippets'
  local snippets_by_language = {}

  for _, manifest_path in ipairs(vim.api.nvim_get_runtime_file('package.json', true)) do
    local ok, manifest = pcall(function()
      return vim.json.decode(table.concat(vim.fn.readfile(manifest_path), '\n'))
    end)

    if ok and manifest.name == 'friendly-snippets' then
      local root = vim.fs.dirname(manifest_path)
      for _, entry in ipairs(manifest.contributes.snippets) do
        local languages = type(entry.language) == 'table' and entry.language or { entry.language }
        for _, language in ipairs(languages) do
          snippets_by_language[language] = snippets_by_language[language] or {}
          table.insert(snippets_by_language[language], vim.fs.joinpath(root, entry.path))
        end
      end
      break
    end
  end

  snippets.setup {
    snippets = {
      function(context)
        local filetype = vim.bo[context.buf_id].filetype
        return vim.tbl_map(snippets.read_file, snippets_by_language[filetype] or {})
      end,
    },
    mappings = {
      jump_next = '<Tab>',
      jump_prev = '<S-Tab>',
    },
  }

  snippets.start_lsp_server { match = false }
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

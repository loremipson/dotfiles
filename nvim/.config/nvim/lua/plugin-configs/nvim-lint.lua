-- lua/plugins/lint.lua

local M = {}

function M.setup()
  local lint = require 'lint'
  local uv = vim.uv or vim.loop

  -- Helper to check if a file exists
  local function file_exists(path)
    local stat = uv.fs_stat(path)
    return stat ~= nil and stat.type == 'file'
  end

  -- Prefer project-local bin from node_modules/.bin, then global
  local function find_bin(name)
    local cwd = vim.fn.getcwd()
    local local_bin = cwd .. '/node_modules/.bin/' .. name

    if file_exists(local_bin) then
      return local_bin
    end

    if vim.fn.executable(name) == 1 then
      return name
    end

    return nil
  end

  -- Find candidate linters
  local oxlint_bin = find_bin('oxlint')
  local biome_bin = find_bin('biome')
  local eslint_bin = find_bin('eslint')

  ---------------------------------------------------------------------------
  -- Configure specific linters if binaries exist
  ---------------------------------------------------------------------------

  -- oxlint
  if oxlint_bin then
    if not lint.linters.oxlint then
      pcall(require, 'lint.linters.oxlint')
    end

    if lint.linters.oxlint then
      lint.linters.oxlint.cmd = oxlint_bin
    end
  end

  -- biome
  if biome_bin then
    if not lint.linters.biome then
      pcall(require, 'lint.linters.biome')
    end

    if lint.linters.biome then
      lint.linters.biome.cmd = biome_bin
    end
  end

  -- eslint
  if eslint_bin then
    if not lint.linters.eslint then
      pcall(require, 'lint.linters.eslint')
    end

    if lint.linters.eslint then
      lint.linters.eslint.cmd = eslint_bin
    end
  end

  ---------------------------------------------------------------------------
  -- Build linter list for JS/TS: oxlint > biome > eslint
  ---------------------------------------------------------------------------

  local function js_linter_priority()
    local linters = {}

    if oxlint_bin and lint.linters.oxlint then
      table.insert(linters, 'oxlint')
    elseif biome_bin and lint.linters.biome then
      table.insert(linters, 'biome')
    elseif eslint_bin and lint.linters.eslint then
      table.insert(linters, 'eslint')
    end

    return linters
  end

  local js_linters = js_linter_priority()

  lint.linters_by_ft = {
    markdown = { 'markdownlint' },

    javascript = js_linters,
    typescript = js_linters,
    javascriptreact = js_linters,
    typescriptreact = js_linters,
    svelte = js_linters,
    vue = js_linters,
    astro = js_linters,
  }

  ---------------------------------------------------------------------------
  -- Autocommands + keymaps
  ---------------------------------------------------------------------------

  local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })

  vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
    group = lint_augroup,
    callback = function()
      lint.try_lint()
    end,
  })

  vim.keymap.set('n', '<leader>L', function()
    lint.try_lint()
  end, { desc = 'Trigger linting for current file' })
end

return M

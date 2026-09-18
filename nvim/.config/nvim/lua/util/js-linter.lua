local M = {}

local configs = {
  oxlint = {
    files = { '.oxlintrc.json', '.oxlintrc.jsonc', 'oxlint.config.ts' },
    package_fields = { 'oxlint', 'vite%-plus' },
  },
  biome = {
    files = { 'biome.json', 'biome.jsonc' },
    package_fields = { 'biomejs' },
  },
  eslint = {
    files = {
      '.eslintrc',
      '.eslintrc.js',
      '.eslintrc.cjs',
      '.eslintrc.yaml',
      '.eslintrc.yml',
      '.eslintrc.json',
      'eslint.config.js',
      'eslint.config.mjs',
      'eslint.config.cjs',
      'eslint.config.ts',
      'eslint.config.mts',
      'eslint.config.cts',
    },
    package_fields = { 'eslintConfig' },
  },
}

local function has_file(dir, names)
  return vim.iter(names):any(function(name)
    return vim.uv.fs_stat(vim.fs.joinpath(dir, name)) ~= nil
  end)
end

local function file_contains(path, patterns, match_all)
  local file = io.open(path, 'r')
  if not file then
    return false
  end

  local content = file:read '*a'
  file:close()

  local matches = vim.iter(patterns):filter(function(pattern)
    return content:find(pattern) ~= nil
  end):totable()
  if match_all then
    return #matches == #patterns
  end
  return #matches > 0
end

local function package_matches(dir, patterns)
  for _, name in ipairs { 'package.json', 'package.json5' } do
    if file_contains(vim.fs.joinpath(dir, name), patterns) then
      return true
    end
  end
  return false
end

local function configured_linter(dir)
  for _, name in ipairs { 'oxlint', 'biome', 'eslint' } do
    local config = configs[name]
    if has_file(dir, config.files) or package_matches(dir, config.package_fields) then
      return name
    end
  end

  local vite_config = vim.fs.joinpath(dir, 'vite.config.ts')
  if file_contains(vite_config, { 'vite%-plus', 'lint:' }, true) then
    return 'oxlint'
  end
end

function M.find(bufnr)
  local filename = vim.api.nvim_buf_get_name(bufnr)
  local dir = vim.fs.dirname(filename)
  local boundary_markers = { 'package-lock.json', 'yarn.lock', 'pnpm-lock.yaml', 'bun.lockb', 'bun.lock', 'deno.lock', '.git' }
  local boundary = vim.fs.root(bufnr, { boundary_markers })
  if not boundary then
    local cwd = vim.fs.normalize(vim.fn.getcwd())
    if dir == cwd or vim.startswith(dir, cwd .. '/') then
      boundary = cwd
    else
      boundary = dir
    end
  end

  while dir do
    local linter = configured_linter(dir)
    if linter then
      return linter, dir
    end

    if dir == boundary then
      break
    end

    local parent = vim.fs.dirname(dir)
    if parent == dir then
      break
    end
    dir = parent
  end
end

return M

local function has_ts(path)
  return path ~= '' and vim.uv.fs_stat(path .. '/typescript.js') ~= nil
end

local function get_global_typescript_lib()
  local ok, result = pcall(function()
    return vim.system({ 'npm', 'root', '-g' }, { text = true }):wait()
  end)
  if ok and result.code == 0 then
    local global_root = vim.trim(result.stdout or '')
    local path = global_root ~= '' and (global_root .. '/typescript/lib') or ''
    if has_ts(path) then
      return path
    end
  end
  return ''
end

local function resolve_tsdk(root_dir)
  local workspace_tsdk = root_dir and (root_dir .. '/node_modules/typescript/lib') or ''
  if has_ts(workspace_tsdk) then
    return workspace_tsdk
  end

  local mason_tsdk = vim.fn.expand '$MASON/packages/typescript-language-server' .. '/node_modules/typescript/lib'
  if has_ts(mason_tsdk) then
    return mason_tsdk
  end

  return get_global_typescript_lib()
end

---@type vim.lsp.Config
return {
  cmd = function(dispatchers, config)
    local cmd = 'astro-ls'
    if (config or {}).root_dir then
      local local_cmd = vim.fs.joinpath(config.root_dir, 'node_modules/.bin', cmd)
      if vim.fn.executable(local_cmd) == 1 then
        cmd = local_cmd
      end
    end
    return vim.lsp.rpc.start({ cmd, '--stdio' }, dispatchers)
  end,
  filetypes = { 'astro' },
  root_markers = { 'package.json', 'tsconfig.json', 'jsconfig.json', '.git' },
  init_options = {
    typescript = {},
  },
  before_init = function(_, config)
    if config.init_options and config.init_options.typescript and not config.init_options.typescript.tsdk then
      local tsdk = resolve_tsdk(config.root_dir)
      config.init_options.typescript.tsdk = tsdk
      if tsdk == '' then
        vim.notify(
          'astro-ls: could not find a TypeScript install for `typescript.tsdk` — ' .. 'run `npm i -D typescript` in this project.',
          vim.log.levels.WARN
        )
      end
    end
  end,
}

local typescript_native = require 'util.typescript-native'

---@type vim.lsp.Config
return {
  cmd = function(dispatchers, config)
    local tsc = vim.fs.joinpath(config.root_dir, 'node_modules', '.bin', 'tsc')
    return vim.lsp.rpc.start({ tsc, '--lsp', '--stdio' }, dispatchers)
  end,
  filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact' },
  root_dir = function(bufnr, on_dir)
    local root_markers = { 'package-lock.json', 'yarn.lock', 'pnpm-lock.yaml', 'bun.lockb', 'bun.lock' }
    root_markers = vim.fn.has 'nvim-0.11.3' == 1 and { root_markers, { '.git' } } or vim.list_extend(root_markers, { '.git' })
    local project_root = vim.fs.root(bufnr, root_markers)
    if project_root and typescript_native.is_available(project_root) then
      on_dir(project_root)
    end
  end,
}

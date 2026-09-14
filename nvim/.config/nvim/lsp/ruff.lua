---@type vim.lsp.Config
return {
  cmd = { 'ruff', 'server' },
  filetypes = { 'python' },
  root_markers = { 'pyproject.toml', 'ruff.toml', '.ruff.toml', '.git' },
  settings = {},
  -- ruff overlaps pyright on hover/some diagnostics; mute ruff's hover so pyright's wins.
  on_attach = function(client)
    client.server_capabilities.hoverProvider = false
  end,
}

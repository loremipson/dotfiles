---@type vim.lsp.Config
return {
  cmd = { 'graphql-lsp', 'server', '-m', 'stream' },
  filetypes = { 'graphql', 'typescriptreact', 'javascriptreact' },
  -- Rewritten without require('lspconfig.util').root_pattern — same glob matching,
  -- done with vim.fs.root's predicate form so this file has zero plugin dependency.
  root_dir = function(bufnr, on_dir)
    on_dir(vim.fs.root(bufnr, function(name)
      return name:match('^%.graphqlrc') ~= nil
        or name:match('^%.graphql%.config%.') ~= nil
        or name:match('^graphql%.config%.') ~= nil
    end))
  end,
}

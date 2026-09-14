local vue_language_server_path = vim.fn.expand '$MASON/packages/vue-language-server' .. '/node_modules/@vue/language-server'

---@type vim.lsp.Config
return {
  cmd = { 'vtsls', '--stdio' },
  init_options = {
    hostInfo = 'neovim',
  },
  filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
  -- Root detection copied from nvim-lspconfig's lsp/vtsls.lua: prefer a package-manager
  -- lock file (supports monorepos), but back off if this file is actually inside a Deno
  -- project (Deno has its own config/lock and shouldn't be claimed by vtsls).
  root_dir = function(bufnr, on_dir)
    local root_markers = { 'package-lock.json', 'yarn.lock', 'pnpm-lock.yaml', 'bun.lockb', 'bun.lock' }
    root_markers = vim.fn.has 'nvim-0.11.3' == 1 and { root_markers, { '.git' } } or vim.list_extend(root_markers, { '.git' })
    local deno_root = vim.fs.root(bufnr, { 'deno.json', 'deno.jsonc' })
    local deno_lock_root = vim.fs.root(bufnr, { 'deno.lock' })
    local project_root = vim.fs.root(bufnr, root_markers)
    if deno_lock_root and (not project_root or #deno_lock_root > #project_root) then
      return
    end
    if deno_root and (not project_root or #deno_root >= #project_root) then
      return
    end
    on_dir(project_root or vim.fn.getcwd())
  end,
  settings = {
    vtsls = {
      enableMoveToFileCodeAction = true,
      autoUseWorkspaceTsdk = true,
      experimental = {
        completion = {
          enableServerSideFuzzyMatch = true,
        },
      },
    },
    typescript = {
      updateImportsOnFileMove = { enabled = 'always' },
      suggest = { completeFunctionCalls = true },
      inlayHints = {
        enumMemberValues = { enabled = true },
        functionLikeReturnTypes = { enabled = true },
        parameterNames = { enabled = 'literals' },
        parameterTypes = { enabled = true },
        propertyDeclarationTypes = { enabled = true },
        variableTypes = { enabled = false },
      },
    },
    javascript = {
      updateImportsOnFileMove = { enabled = 'always' },
      suggest = { completeFunctionCalls = true },
      inlayHints = {
        enumMemberValues = { enabled = true },
        functionLikeReturnTypes = { enabled = true },
        parameterNames = { enabled = 'literals' },
        parameterTypes = { enabled = true },
        propertyDeclarationTypes = { enabled = true },
        variableTypes = { enabled = false },
      },
    },
  },
  before_init = function(_, config)
    local vtsls_settings = config.settings.vtsls or {}
    vtsls_settings.tsserver = vtsls_settings.tsserver or {}
    vtsls_settings.tsserver.globalPlugins = vtsls_settings.tsserver.globalPlugins or {}
    table.insert(vtsls_settings.tsserver.globalPlugins, {
      name = '@vue/typescript-plugin',
      location = vue_language_server_path,
      languages = { 'vue' },
      configNamespace = 'typescript',
      enableForWorkspaceTypeScriptVersions = true,
    })
    config.settings.vtsls = vtsls_settings
  end,
}

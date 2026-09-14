---@type vim.lsp.Config
return {
  cmd = { 'vue-language-server', '--stdio' },
  filetypes = { 'vue' },
  root_markers = { 'package.json' },
  init_options = {
    typescript = {}, -- tsdk filled in below, once root_dir is known
  },
  -- vue-language-server refuses to initialize without init_options.typescript.tsdk
  -- pointing at a real TypeScript install (a dir containing typescript.js or
  -- tsserverlibrary.js). Prefer the project's own TypeScript version; fall back
  -- to the copy bundled with Mason's typescript-language-server package.
  before_init = function(_, config)
    local function has_ts(path)
      return path ~= '' and vim.uv.fs_stat(path .. '/typescript.js') ~= nil
    end

    local workspace_tsdk = config.root_dir and (config.root_dir .. '/node_modules/typescript/lib') or ''
    local mason_tsdk = vim.fn.expand '$MASON/packages/typescript-language-server' .. '/node_modules/typescript/lib'

    config.init_options.typescript.tsdk = has_ts(workspace_tsdk) and workspace_tsdk or has_ts(mason_tsdk) and mason_tsdk or ''

    if config.init_options.typescript.tsdk == '' then
      vim.notify(
        'vue_ls: could not find a TypeScript install for `typescript.tsdk` — '
          .. 'run `npm i -D typescript` in this project or ensure typescript-language-server is installed via Mason.',
        vim.log.levels.WARN
      )
    end
  end,
  on_init = function(client)
    local retries = 0

    local function typescriptHandler(_, result, context)
      local ts_client = vim.lsp.get_clients({ bufnr = context.bufnr, name = 'ts_ls' })[1]
        or vim.lsp.get_clients({ bufnr = context.bufnr, name = 'vtsls' })[1]
        or vim.lsp.get_clients({ bufnr = context.bufnr, name = 'typescript-tools' })[1]

      if not ts_client then
        if retries <= 10 then
          retries = retries + 1
          vim.defer_fn(function()
            typescriptHandler(_, result, context)
          end, 100)
        else
          vim.notify('Could not find `ts_ls`, `vtsls`, or `typescript-tools` lsp client required by `vue_ls`.', vim.log.levels.ERROR)
        end
        return
      end

      local param = unpack(result)
      local id, command, payload = unpack(param)
      ts_client:exec_cmd({
        title = 'vue_request_forward',
        command = 'typescript.tsserverRequest',
        arguments = { command, payload },
      }, { bufnr = context.bufnr }, function(_, r)
        local response_data = { { id, r and r.body } }
        client:notify('tsserver/response', response_data)
      end)
    end

    client.handlers['tsserver/request'] = typescriptHandler
  end,
}

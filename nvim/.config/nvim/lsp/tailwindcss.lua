local function package_json_has_tailwind(fname)
  local pkg_path = vim.fs.find('package.json', { path = vim.fs.dirname(fname), upward = true })[1]
  if not pkg_path then
    return nil
  end
  local ok, lines = pcall(vim.fn.readfile, pkg_path)
  if not ok then
    return nil
  end
  if table.concat(lines, '\n'):match '"tailwindcss"' then
    return pkg_path
  end
  return nil
end

---@type vim.lsp.Config
return {
  cmd = function(dispatchers, config)
    local cmd = 'tailwindcss-language-server'
    if (config or {}).root_dir then
      local local_cmd = vim.fs.joinpath(config.root_dir, 'node_modules/.bin', cmd)
      if vim.fn.executable(local_cmd) == 1 then
        cmd = local_cmd
      end
    end
    return vim.lsp.rpc.start({ cmd, '--stdio' }, dispatchers)
  end,
  filetypes = {
    'aspnetcorerazor',
    'astro',
    'astro-markdown',
    'blade',
    'clojure',
    'django-html',
    'htmldjango',
    'edge',
    'eelixir',
    'elixir',
    'ejs',
    'erb',
    'eruby',
    'gohtml',
    'gohtmltmpl',
    'haml',
    'handlebars',
    'hbs',
    'html',
    'htmlangular',
    'html-eex',
    'heex',
    'jade',
    'leaf',
    'liquid',
    'markdown',
    'mdx',
    'mustache',
    'njk',
    'nunjucks',
    'php',
    'razor',
    'slim',
    'twig',
    'css',
    'less',
    'postcss',
    'sass',
    'scss',
    'stylus',
    'sugarss',
    'javascript',
    'javascriptreact',
    'reason',
    'rescript',
    'typescript',
    'typescriptreact',
    'vue',
    'svelte',
    'templ',
  },
  capabilities = {
    workspace = {
      didChangeWatchedFiles = {
        dynamicRegistration = true,
      },
    },
  },
  settings = {
    tailwindCSS = {
      validate = true,
      lint = {
        cssConflict = 'warning',
        invalidApply = 'error',
        invalidScreen = 'error',
        invalidVariant = 'error',
        invalidConfigPath = 'error',
        invalidTailwindDirective = 'error',
        recommendedVariantOrder = 'warning',
      },
      classAttributes = { 'class', 'className', 'class:list', 'classList', 'ngClass' },
      includeLanguages = {
        eelixir = 'html-eex',
        elixir = 'phoenix-heex',
        eruby = 'erb',
        heex = 'phoenix-heex',
        htmlangular = 'html',
        templ = 'html',
      },
      experimental = {
        classRegex = {
          -- cva, cx, cn, clsx, twMerge — completions inside utility wrappers
          { 'cva\\(([^)]*)\\)', '["\'`]([^"\'`]*).*?["\'`]' },
          { 'cx\\(([^)]*)\\)', '["\'`]([^"\'`]*).*?["\'`]' },
          { 'cn\\(([^)]*)\\)', '["\'`]([^"\'`]*).*?["\'`]' },
          { 'clsx\\(([^)]*)\\)', '["\'`]([^"\'`]*).*?["\'`]' },
          { 'twMerge\\(([^)]*)\\)', '["\'`]([^"\'`]*).*?["\'`]' },
        },
      },
    },
  },
  before_init = function(_, config)
    config.settings = vim.tbl_deep_extend('keep', config.settings, {
      editor = { tabSize = vim.lsp.util.get_effective_tabstop() },
    })
  end,
  workspace_required = true,
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    local root_files = {
      'tailwind.config.js',
      'tailwind.config.cjs',
      'tailwind.config.mjs',
      'tailwind.config.ts',
      'postcss.config.js',
      'postcss.config.cjs',
      'postcss.config.mjs',
      'postcss.config.ts',
      'theme/static_src/tailwind.config.js',
      'theme/static_src/tailwind.config.cjs',
      'theme/static_src/tailwind.config.mjs',
      'theme/static_src/tailwind.config.ts',
      'theme/static_src/postcss.config.js',
      '.git', -- fallback for Tailwind v4, which no longer requires tailwind.config.*
    }
    local pkg_with_tailwind = package_json_has_tailwind(fname)
    if pkg_with_tailwind then
      table.insert(root_files, 1, pkg_with_tailwind)
    end
    on_dir(vim.fs.dirname(vim.fs.find(root_files, { path = fname, upward = true })[1]))
  end,
}

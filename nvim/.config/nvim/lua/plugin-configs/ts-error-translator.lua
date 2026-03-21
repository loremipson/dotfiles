local M = {}

function M.setup()
  require('ts-error-translator').setup {
    auto_attach = true,
    servers = {
      'astro',
      'svelte',
      'volar',
      'vtsls',
    },
  }
end

return M

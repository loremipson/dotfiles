local M = {}

local function get_line_diagnostics(bufnr)
  local line = vim.api.nvim_win_get_cursor(0)[1] - 1
  return vim.iter(vim.diagnostic.get(bufnr, { lnum = line })):fold({}, function(diagnostics, diagnostic)
    local lsp_diagnostic = diagnostic.user_data and diagnostic.user_data.lsp
    if lsp_diagnostic then
      diagnostics[#diagnostics + 1] = lsp_diagnostic
    end
    return diagnostics
  end)
end

local function make_params(opts, client, context)
  if opts.range then
    return vim.tbl_extend('force', vim.lsp.util.make_given_range_params(opts.range.start, opts.range['end'], opts.bufnr, client.offset_encoding), {
      context = context,
    })
  end

  local mode = vim.api.nvim_get_mode().mode
  if mode == 'v' or mode == 'V' then
    local start = vim.fn.getpos 'v'
    local finish = vim.fn.getpos '.'
    local start_row, start_col = start[2], start[3]
    local end_row, end_col = finish[2], finish[3]

    if start_row == end_row and end_col < start_col then
      start_col, end_col = end_col, start_col
    elseif end_row < start_row then
      start_row, end_row = end_row, start_row
      start_col, end_col = end_col, start_col
    end

    if mode == 'V' then
      start_col = 1
      end_col = #vim.api.nvim_buf_get_lines(opts.bufnr, end_row - 1, end_row, true)[1]
    end

    return vim.tbl_extend(
      'force',
      vim.lsp.util.make_given_range_params({ start_row, start_col - 1 }, { end_row, end_col - 1 }, opts.bufnr, client.offset_encoding),
      { context = context }
    )
  end

  return vim.tbl_extend('force', vim.lsp.util.make_range_params(0, client.offset_encoding), { context = context })
end

local function install_bounded_finder()
  local finder = require 'tiny-code-action.finder'

  -- Upstream waits for every client and does not time out the initial request.
  finder.code_action_finder = function(opts, config, callback)
    local clients = vim.lsp.get_clients { bufnr = opts.bufnr, method = 'textDocument/codeAction' }
    if #clients == 0 then
      return
    end

    local context = vim.tbl_extend('force', {
      diagnostics = get_line_diagnostics(opts.bufnr),
      triggerKind = vim.lsp.protocol.CodeActionTriggerKind.Invoked,
    }, opts.context or {})
    local pending = #clients
    local requests = {}
    local results = {}
    local finished = false

    local function finish()
      if finished then
        return
      end
      finished = true

      for _, request in pairs(requests) do
        request.client:cancel_request(request.id)
      end

      if #results > 0 then
        callback(results)
      elseif config.notify and config.notify.enabled and config.notify.on_empty then
        vim.notify('No code actions found.', vim.log.levels.INFO)
      end
    end

    for _, client in ipairs(clients) do
      local responded = false
      local success, request_id = client:request('textDocument/codeAction', make_params(opts, client, context), function(err, actions)
        responded = true
        requests[client.id] = nil
        if finished then
          return
        end

        pending = pending - 1
        if not err then
          for _, action in ipairs(actions or {}) do
            results[#results + 1] = { client = client, action = action, context = context }
          end
        end

        if pending == 0 then
          finish()
        end
      end, opts.bufnr)

      if success and request_id and not responded then
        requests[client.id] = { client = client, id = request_id }
      elseif not responded then
        pending = pending - 1
        if pending == 0 then
          finish()
        end
      end
    end

    vim.defer_fn(finish, config.request_timeout or 3000)
  end
end

function M.setup()
  install_bounded_finder()
  require('tiny-code-action').setup {
    backend = 'vim',
    picker = 'snacks',
    request_timeout = 3000,
  }
end

return M

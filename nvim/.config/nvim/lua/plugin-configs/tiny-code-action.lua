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
    local optional_clients = { oxlint = true }
    local pending = #clients
    local required_pending = 0
    for _, client in ipairs(clients) do
      if not optional_clients[client.name] or #clients == 1 then
        required_pending = required_pending + 1
      end
    end
    local requests = {}
    local results = {}
    local finished = false
    local finish_scheduled = false

    local function finish(timed_out)
      if finished then
        return
      end
      finished = true

      local pending_clients = {}
      for _, request in pairs(requests) do
        if not request.optional then
          pending_clients[#pending_clients + 1] = request.client.name
        end
        request.client:cancel_request(request.id)
      end

      if #results > 0 then
        callback(results)
      elseif config.notify and config.notify.enabled and config.notify.on_empty then
        vim.notify('No code actions found.', vim.log.levels.INFO)
      end

      if timed_out and #pending_clients > 0 then
        table.sort(pending_clients)
        vim.notify('Code actions timed out: ' .. table.concat(pending_clients, ', '), vim.log.levels.WARN)
      end
    end

    local function schedule_finish()
      if finish_scheduled then
        return
      end
      finish_scheduled = true
      vim.defer_fn(finish, config.optional_grace or 50)
    end

    local function complete_request()
      if pending == 0 then
        finish()
      elseif required_pending == 0 then
        schedule_finish()
      end
    end

    for _, client in ipairs(clients) do
      local optional = optional_clients[client.name] and #clients > 1
      local responded = false
      local success, request_id = client:request('textDocument/codeAction', make_params(opts, client, context), function(err, actions)
        responded = true
        requests[client.id] = nil
        if finished then
          return
        end

        pending = pending - 1
        if not optional then
          required_pending = required_pending - 1
        end
        if not err then
          for _, action in ipairs(actions or {}) do
            results[#results + 1] = { client = client, action = action, context = context }
          end
        end

        complete_request()
      end, opts.bufnr)

      if success and request_id and not responded then
        requests[client.id] = { client = client, id = request_id, optional = optional }
      elseif not responded then
        pending = pending - 1
        if not optional then
          required_pending = required_pending - 1
        end
        complete_request()
      end
    end

    vim.defer_fn(function()
      finish(true)
    end, config.request_timeout or 1000)
  end
end

function M.setup()
  install_bounded_finder()
  require('tiny-code-action').setup {
    backend = 'vim',
    picker = 'snacks',
    optional_grace = 50,
    request_timeout = 1000,
  }
end

return M

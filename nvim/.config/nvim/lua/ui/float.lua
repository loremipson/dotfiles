-- Usage:
--   require('ui.float').open({
--     { { 'Hello', 'Title' }, { ' world' } },
--     {},  -- blank line
--     { { '  muted', 'Comment' } },
--   }, ' My Title ')

local M = {}

local api, fn = vim.api, vim.fn
local ns = api.nvim_create_namespace('ui_float')

local function render(blocks)
  local lines, marks = {}, {}
  for _, chunks in ipairs(blocks) do
    local text = ''
    for _, ch in ipairs(chunks) do
      if ch[2] then
        table.insert(marks, { #lines, #text, #text + #ch[1], ch[2] })
      end
      text = text .. ch[1]
    end
    table.insert(lines, text)
  end
  return lines, marks
end

function M.open(blocks, title)
  local lines, marks = render(blocks)

  local buf = api.nvim_create_buf(false, true)
  api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  for _, m in ipairs(marks) do
    api.nvim_buf_set_extmark(buf, ns, m[1], m[2], { end_col = m[3], hl_group = m[4] })
  end
  vim.bo[buf].modifiable = false
  vim.bo[buf].bufhidden = 'wipe'

  local width = 0
  for _, l in ipairs(lines) do
    width = math.max(width, fn.strdisplaywidth(l))
  end
  width = math.min(width + 2, math.floor(vim.o.columns * 0.8))
  local height = math.max(1, math.min(#lines, math.floor(vim.o.lines * 0.7)))

  local win = api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    style = 'minimal',
    border = 'rounded',
    title = title,
    title_pos = 'center',
    footer = ' q to close ',
    footer_pos = 'right',
  })

  for _, key in ipairs({ 'q', '<Esc>' }) do
    vim.keymap.set('n', key, '<cmd>close<cr>', { buffer = buf, nowait = true })
  end

  api.nvim_create_autocmd('WinLeave', {
    buffer = buf,
    once = true,
    callback = function()
      if api.nvim_win_is_valid(win) then
        api.nvim_win_close(win, true)
      end
    end,
  })

  return buf, win
end

return M

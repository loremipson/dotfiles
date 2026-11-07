local terminal = "com.superlogical.terminal"

local function focused_cwd(ctx)
  local pwd = rex.block.call(terminal, "pwd", { block_id = ctx.block_id })
  if pwd and pwd.pwd then
    return (pwd.pwd:gsub("^file://[^/]*", ""))
  end
  local proc = rex.block.call(terminal, "process", { block_id = ctx.block_id })
  local fg = proc and proc.foreground
  return fg and fg.cwd
end

rex.action({
  name = "lazygit_float",
  title = "Lazygit",
  keywords = "git lazygit float",
  run = function(ctx)
    local _, err = rex.session.new_layer({
      bounds = { 0.05, 0.05, 0.9, 0.9 },
      layout = rex.layout.block({ flavor = terminal .. ".shell", options = { command = { "lazygit" }, cwd = focused_cwd(ctx) } }),
      focus = true,
    })
    if err then error(err) end
  end,
})

rex.bind("ctrl+a>ctrl+a", "pane.send_key", { key = "ctrl+a" })
rex.bind("ctrl+a>c", "client.tab.new")
rex.bind("ctrl+a>g",       "lazygit_float")
rex.bind("ctrl+a>x", "pane.close")
rex.bind("ctrl+a>z", "pane.zoom")
rex.bind("ctrl+a>=", "pane.balance")

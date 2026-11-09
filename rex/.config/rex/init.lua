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

rex.action({
  name = "bitwarden",
  title = "Bitwarden",
  keywords = "bitwarden password picker vault",
  run = function()
    local _, err = rex.session.new_layer({
      bounds = { 0.05, 0.05, 0.9, 0.9 },
      layout = rex.layout.block({ flavor = terminal .. ".shell", options = { command = { os.getenv("HOME") .. "/.config/rex/bw.sh" } } }),
      focus = true,
    })
    if err then error(err) end
  end,
})

-- shortcut: switch back to lazy path once PR is merged
local ok, err = pcall(function()
  dofile(os.getenv("HOME") .. "/Work/rex-navigator.nvim/rex/navigator.lua").setup()
end)
if not ok then rex.log("warn", "rex-navigator not loaded: " .. tostring(err)) end

local ok_tb, err_tb = pcall(function()
  require("rex-tmux-bindings").setup({ prefix = "ctrl+a" })
end)
if not ok_tb then rex.log("warn", "rex-tmux-bindings not loaded: " .. tostring(err_tb)) end

rex.bind("ctrl+a>g", "lazygit_float")
rex.bind("ctrl+a>b", "bitwarden")

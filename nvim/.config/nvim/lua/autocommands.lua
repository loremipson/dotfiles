-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
  pattern = "*",
  desc = "Highlight yanked selection",
  callback = function()
    vim.hl.on_yank({ timeout = 200, visual = true })
  end,
})

-- Open help in vertical split
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("help_vsplit", { clear = true }),
  pattern = "help",
  command = "wincmd L",
})

-- Auto resize splits when resizing nvim window
vim.api.nvim_create_autocmd("VimResized", {
  group = vim.api.nvim_create_augroup("resize_splits", { clear = true }),
  command = "wincmd =",
})

-- Show cursorline only in active window
vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
  group = vim.api.nvim_create_augroup("active_cursorline", { clear = true }),
  callback = function()
    vim.opt_local.cursorline = true
  end,
})
vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
  group = "active_cursorline",
  callback = function()
    vim.opt_local.cursorline = false
  end,
})

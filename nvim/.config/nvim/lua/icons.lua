local c = vim.fn.nr2char

local M = {}

M.diagnostics = {
  ERROR = c(0xea87),
  WARN = c(0xea6c),
  INFO = c(0xea74),
  HINT = c(0xea61),
}

M.git = {
  branch = c(0xf126),
  added = c(0xf0fe),
  changed = c(0xf044),
  removed = c(0xf146),
  github = c(0xf09b),
  ahead = c(0xf062),
  behind = c(0xf063),
}

M.ui = {
  cap_l = c(0xe0b6),
  cap_r = c(0xe0b4),
  lsp = c(0xf2db),
  gear = c(0xf013),
  lock = c(0xf023),
  modified = c(0xf111),
  saved = c(0xf0c7),
  recording = c(0xf192),
  search = c(0xf002),
  terminal = c(0xf120),
  code = c(0xf121),
  file = c(0xf016),
  folder = c(0xf07b),
  folder_open = c(0xf07c),
  check = c(0xf00c),
  close = c(0xf00d),
  clock = c(0xf017),
  spinner = c(0xf110),
  eye = c(0xf06e),
  eye_off = c(0xf070),
  tag = c(0xf02b),
  copy = c(0xf0c5),
  trash = c(0xf1f8),
  keyboard = c(0xf11c),
}

M.debug = {
  bug = c(0xf188),
  breakpoint = c(0xf111),
  play = c(0xf04b),
  pause = c(0xf04c),
  stop = c(0xf04d),
  test = c(0xf0c3),
}

return M

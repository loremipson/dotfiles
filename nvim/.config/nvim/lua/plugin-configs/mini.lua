local M = {}

function M.icons()
  require('mini.icons').setup()
  MiniIcons.mock_nvim_web_devicons()
end

function M.ai()
  require('mini.ai').setup { n_lines = 500 }
end

function M.pairs()
  require('mini.pairs').setup()
end

function M.jump()
  require('mini.jump').setup()
end

return M

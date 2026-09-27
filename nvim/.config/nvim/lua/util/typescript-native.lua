local M = {}

function M.is_available(root_dir)
  if not root_dir then
    return false
  end

  local tsc = vim.fs.joinpath(root_dir, 'node_modules', '.bin', 'tsc')
  if vim.fn.executable(tsc) ~= 1 then
    return false
  end

  for _, package_name in ipairs { 'typescript', '@typescript/native' } do
    local package_json = vim.fs.joinpath(root_dir, 'node_modules', package_name, 'package.json')
    if vim.uv.fs_stat(package_json) then
      local ok, package = pcall(vim.json.decode, table.concat(vim.fn.readfile(package_json), '\n'))
      if ok and type(package.version) == 'string' and package.version:match '^7%.' then
        return true
      end
    end
  end

  return false
end

return M

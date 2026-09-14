local M = {}

--- Appends the basenames of any `new_names` files (found upward from `fname`)
--- that contain `field` (string or list of strings) to `root_files`, then
--- returns `root_files`. `match_mode`: 'any' (default) matches if any field
--- string is found; 'all' requires all of them to appear (anywhere in the file).
function M.root_markers_with_field(root_files, new_names, field, fname, match_mode)
  local path = vim.fn.fnamemodify(fname, ':h')
  local found = vim.fs.find(new_names, { path = path, upward = true, type = 'file' })
  local fields = type(field) == 'string' and { field } or field
  local to_find = vim.deepcopy(fields)
  local matcher = (match_mode or 'any') == 'any'
      and function(line)
        return vim.iter(fields):any(function(s)
          return line:find(s)
        end)
      end
    or function(line)
      to_find = vim
        .iter(to_find)
        :filter(function(s)
          return not line:find(s)
        end)
        :totable()
      if #to_find == 0 then
        to_find = vim.deepcopy(fields)
        return true
      end
      return false
    end
  for _, f in ipairs(found or {}) do
    local file = assert(io.open(f, 'r'))
    for line in file:lines() do
      if matcher(line) then
        root_files[#root_files + 1] = vim.fs.basename(f)
        break
      end
    end
    file:close()
  end
  return root_files
end

--- Adds package.json/package.json5 to root_files if it contains `field`.
function M.insert_package_json(root_files, field, fname)
  return M.root_markers_with_field(root_files, { 'package.json', 'package.json5' }, field, fname)
end

return M

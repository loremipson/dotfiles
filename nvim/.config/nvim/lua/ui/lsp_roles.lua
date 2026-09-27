local M = {}

M.helpers = {
  emmet_language_server = true,
  tailwindcss = true,
  graphql = true,
  oxlint = true,
  eslint = true,
  copilot = true,
}

function M.is_helper(client)
  return M.helpers[client.name] == true
end

function M.sorted(clients)
  table.sort(clients, function(a, b)
    local ha, hb = M.is_helper(a), M.is_helper(b)
    if ha ~= hb then
      return hb -- a comes first only when b is the helper
    end
    return a.name < b.name
  end)
  return clients
end

return M

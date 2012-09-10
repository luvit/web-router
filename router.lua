return function (app, setup)
  local routes = {}

  local router = {}
  function router.get(path, handler)
    if path:match("/:") then
      local pattern = path:gsub("/(:[a-z]+)", "/([^/]+)")
      local names = {path:match("/:([a-z]+)")}
      path = function (path)
        local matches = {path:match(pattern)}
        if #matches == 0 or not matches[1] then return end
        local params = {}
        for i, name in ipairs(names) do
          params[name] = matches[i]
        end
        return params
      end
    end
    routes[#routes + 1] = {path, handler}
  end

  setup(router)

  return function (req, res)
    for i, pair in ipairs(routes) do
      local path, handler = unpack(pair)
      if type(path) == "function" then
        local matches = path(req.url.path)
        if matches then
          req.params = matches
          return handler(req, res)
        end
      elseif req.url.path == path then
        return handler(req, res)
      end
    end
    app(req, res)
  end
end
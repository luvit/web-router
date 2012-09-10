return function (app, setup)
  local routes = {}

  local router = {}
  function router.get(path, handler)
    routes[#routes + 1] = {path, handler}
  end

  setup(router)

  return function (req, res)
    for i, pair in ipairs(routes) do
      local path, handler = unpack(pair)
      if req.url.path == path then
        return handler(req, res)
      end
    end
    app(req, res)
  end
end
return function (app, setup)
  local routes = {}

  local router = {}
  function router.get(path, handler)

  end

  setup(router)

  return function (req, res)
    console.log("TODO: Implement router")
    app(req, res)
  end
end
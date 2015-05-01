{ Router } = require 'express'

module.exports = class AHttpServerRouter

  constructor: (options) ->

    app = Router()

    { routes, config, server } = options

    r = routes(config)

    Object.keys(r).map (url) ->

      route = r[url]

      args = route.params || []

      args.unshift url

      args.push route.route.bind(app)

      app[route.method].apply app, args

    return app

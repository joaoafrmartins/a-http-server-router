{ isArray } = Array

{ Router } = require 'express'

module.exports = class AHttpServerRouter

  constructor: (options) ->

    app = Router()

    { routes, config, server } = options

    r = routes(config)

    Object.keys(r).map (url) ->

      route = r[url]

      if isArray(route)

        return route.map (routeMethod) ->

          args = routeMethod.params || []

          args.unshift url

          args.push routeMethod.route.bind(server)

          app[routeMethod.method].apply app, args

      args = route.params || []

      args.unshift url

      args.push route.route.bind(server)

      app[route.method].apply app, args

    return app

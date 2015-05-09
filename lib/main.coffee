{ isArray } = Array

{ Router } = require 'express'

configFn = require 'a-http-server-config-fn'

module.exports = class AHttpServerRouter

  constructor: (@server) ->

    Object.defineProperty @, "app", value: Router()

    url = ""

    blacklist = [ "server", "constructor", "config" ]

    if @config

      config = require(@config)

      url = config.router.url

      configFn @server.config, @config

    for route, definition of @

      if not (route in blacklist)

        if route.match(/^\/:?\w(\/:?\w)*/)

          args = definition.params || []

          args.unshift "#{url}#{route}"

          args.push definition.route.bind(@server)

          @app[definition.method].apply @app, args

        else throw new Error "invalid route: #{route}"

    return @app

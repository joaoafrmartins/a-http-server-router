{ isArray } = Array

{ Router } = require 'express'

configFn = require 'a-http-server-config-fn'

module.exports = class AHttpServerRouter

  constructor: (@server) ->

    url = ""

    Object.defineProperty @, "app", value: Router()

    if @config

      config = require(@config)

      configFn @server.config, @config

      @config = config

      url = @config.prefix or ""

    for route, definition of @

      if route.match(/^\/:?\w(\/:?\w)*/)

        args = definition.params || []

        args.unshift "#{url}#{route}"

        args.push definition.route.bind(@server)

        @app[definition.method].apply @app, args

    return @app

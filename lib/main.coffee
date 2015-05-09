{ isArray } = Array

{ Router } = require 'express'

Mixto = require 'mixto'

module.exports = class AHttpServerRouter

  constructor: (@server) ->

    Object.defineProperty @, "app", value: Router()

    blacklist = [ "server", "constructor" ]

    for route, definition of @

      if not (route in blacklist)

        if route.match(/^\/\w(\/\w)*/)

          args = definition.params || []

          args.unshift route

          args.push definition.route.bind(@server)

          @app[definition.method].apply @app, args

        else throw new Error "invalid route: #{key}"

    return @app

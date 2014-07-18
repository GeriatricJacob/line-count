
((module) ->
  class module.Random
    constructor: (@seed) ->
    get: ->
      @seed = (@seed * 9301 + 49297) % 233280
      @seed / 233280.0

)(if window? then window else module.exports)

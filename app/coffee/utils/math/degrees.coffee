assert = require 'assert'

Angle = require './angle.coffee'

class Degrees extends Angle
  @MIN_DEGREES = 0
  @MAX_DEGREES = 360

  constructor: (degrees) ->
    degrees %= Degrees.MAX_DEGREES
    super degrees


  getInverse: ->
    @value %= Degrees.MAX_DEGREES
    return @value - Degrees.MAX_DEGREES / 2


  toRadians: ->
    return @degreesToRadians()

module.exports = Degrees

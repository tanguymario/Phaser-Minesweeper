class Angle
  constructor: (angle) ->
    @value = angle


  degreesToRadians: ->
    return @value * (Math.PI / 180)


  radiansToDegrees: ->
    return @value * (180 / Math.PI)


module.exports = Angle

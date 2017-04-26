Phaser = require 'Phaser'

Coordinates = require '../coordinates.coffee'

assert = require '../assert.coffee'

class Polygon

  constructor: (coordinates...) ->
    for i in [0..coordinates.length - 1] by 1
      assert coordinates[i] instanceof Coordinates, "object specified is not of type \'Coordinates\'"

    @points = coordinates


  getPoint: (i) ->
    return @points[i]


  getMiddlePoint: () ->
    sumX = 0
    sumY = 0
    nbPoints = @points.length

    for point in @points
      sumX += point.x
      sumY += point.y

    return new Coordinates sumX / nbPoints, sumY / nbPoints


  toGraphics: (graphics) ->
    assert graphics? and graphics instanceof Phaser.Graphics, "Graphics doesn't exist"
    assert @points.length > 0, "No Points to draw"

    firstPoint = @points[0]

    graphics.beginFill 0xFFFFFF

    for i in [0..@points.length - 1] by 1
      nextPoint = @points[(i + 1) % @points.length]

      diffPoint = Coordinates.Sub nextPoint, firstPoint

      graphics.lineTo diffPoint.x, diffPoint.y

    graphics.endFill()

    return graphics


  toString: ->
    return """
    Polygon :
      - Points :
        #{@points}
    """

module.exports = Polygon

Polygon = require './polygon.coffee'

Coordinates = require '../coordinates.coffee'

assert = require '../assert.coffee'

class Square extends Polygon
  constructor: (topLeft, bottomRight) ->
    assert topLeft instanceof Coordinates, "Top Left is not of type Coordinates"
    assert bottomRight instanceof Coordinates, "Bottom Right is not of type Coordinates"

    bottomLeft = new Coordinates topLeft.x, bottomRight.y
    topRight = new Coordinates bottomRight.x, topLeft.y

    @sideLength = topRight.x - topLeft.x

    super topLeft, bottomLeft, bottomRight, topRight


  getSideLength: ->
    return @sideLength


  getDiagonalLength: ->
    return @sideLength * Math.sqrt 2


  getTopLeft: ->
    return @points[0]


  getBottomLeft: ->
    return @points[1]


  getTopRight: ->
    return @points[3]


  getBottomRight: ->
    return @points[2]


  toString: ->
    return """
    Square :
      - Top Right :
        #{@getTopLeft().toString()}
      - Bottom Left :
        #{@getBottomLeft().toString()}
      - Top Left :
        #{@getTopLeft().toString()}
      - Bottom Right :
        #{@getBottomRight().toString()}
    """


module.exports = Square

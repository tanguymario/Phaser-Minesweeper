Polygon = require './polygon.coffee'

Coordinates = require '../coordinates.coffee'

assert = require '../assert.coffee'

class Rectangle extends Polygon
  constructor: (topLeft, width, height) ->
    assert topLeft instanceof Coordinates, "Top Left is not of type Coordinates"
    assert width >= 0, "Width must be positive : " + width
    assert height >= 0, "Height must be positive : " + height

    topRight = new Coordinates topLeft.x + width, topLeft.y
    bottomLeft = new Coordinates topLeft.x, topLeft.y + height
    bottomRight = new Coordinates topRight.x, bottomLeft.y

    super topLeft, bottomLeft, bottomRight, topRight


  getTopLeft: ->
    return @points[0]


  getBottomLeft: ->
    return @points[1]


  getTopRight: ->
    return @points[3]


  getBottomRight: ->
    return @points[2]


  isInside: (coords) ->
    topLeft = @getTopLeft()
    bottomRight = @getBottomRight()

    if coords.x >= topLeft.x and coords.x <= bottomRight.x
      if coords.y >= topLeft.y and coords.y <= bottomRight.y
        return true

    return false


  isOutside: (coords )->
    return !@isInside coords


  toString: ->
    return """
    Rectangle :
      - Top Right :
        #{@getTopLeft().toString()}
      - Bottom Left :
        #{@getBottomLeft().toString()}
      - Top Left :
        #{@getTopLeft().toString()}
      - Bottom Right :
        #{@getBottomRight().toString()}
    """


module.exports = Rectangle

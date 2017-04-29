assert = require './assert.coffee'

lerp = require './math/lerp.coffee'
lerpUnclamped = require './math/lerp-unclamped.coffee'

class Coordinates

  @Assert2Coords: (coordsA, coordsB) ->
    assert coordsA instanceof Coordinates, "CoordsA is not coordinates"
    assert coordsB instanceof Coordinates, "CoordsB is not coordinates"


  @GetMiddle: (coordsA, coordsB) ->
    Coordinates.Assert2Coords coordsA, coordsB
    return new Coordinates (coordsA.x + coordsB.x) / 2, (coordsA.y + coordsB.y) / 2


  @GetFactor: (coordsA, coordsB) ->
    Coordinates.Assert2Coords coordsA, coordsB
    return (coordsA.x / coordsB.x + coordsA.y / coordsB.y) / 2


  @Add: (coordsA, coordsB) ->
    Coordinates.Assert2Coords coordsA, coordsB
    return new Coordinates coordsA.x + coordsB.x, coordsA.y + coordsB.y


  @Sub: (coordsA, coordsB) ->
    Coordinates.Assert2Coords coordsA, coordsB
    return new Coordinates coordsA.x - coordsB.x, coordsA.y - coordsB.y


  @Mult: (coordsA, coordsB) ->
    Coordinates.Assert2Coords coordsA, coordsB
    return new Coordinates coordsA.x * coordsB.x, coordsA.y * coordsB.y


  @Divide: (coordsA, coordsB) ->
    Coordinates.Assert2Coords coordsA, coordsB
    return new Coordinates coordsA.x / coordsB.x, coordsA.y / coordsB.y


  @Lerp: (coordsA, coordsB, value) ->
    Coordinates.Assert2Coords coordsA, coordsB
    x = lerp coordsA.x, coordsB.x, value
    y = lerp coordsA.y, coordsB.y, value
    return new Coordinates x, y

  @LerpUnclamped: (coordsA, coordsB, value) ->
    Coordinates.Assert2Coords coordsA, coordsB
    x = lerpUnclamped coordsA.x, coordsB.x, value
    y = lerpUnclamped coordsA.y, coordsB.y, value
    return new Coordinates x, y


  @One: ->
    return new Coordinates 1, 1


  constructor: (x, y) ->
    @x = x
    @y = y


  mult: (factor) ->
    @x *= factor
    @y *= factor


  divide: (factor) ->
    @x /= factor
    @y /= factor


  equals: (coordsB) ->
    assert coordsB instanceof Coordinates
    return @x == coordsB.x and @y == coordsB.y


  clone: ->
    return new Coordinates @x, @y


  toString: ->
    return """
    Coordinates :
      - x : #{@x}
      - y : #{@y}
    """

module.exports = Coordinates

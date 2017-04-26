Polygon = require './polygon.coffee'

Coordinates = require '../coordinates.coffee'

assert = require '../assert.coffee'

class LineSegment extends Polygon

  constructor: (pointA, pointB) ->
    assert pointA instanceof Coordinates, "PointA is not Coordinates"
    assert pointB instanceof Coordinates, "PointB is not Coordinates"

    super pointA, pointB


  getStart: ->
    return @points[0]


  getEnd: ->
    return @points[1]


  toString: ->
    return """
    LineSegment :
      - Point A :
      #{@getStart().toString()}
      - Point B :
      #{@getEnd().toString()}
    """

module.exports = LineSegment

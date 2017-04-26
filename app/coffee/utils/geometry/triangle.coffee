assert = require '../assert.coffee'

Polygon = require './polygon.coffee'

class Triangle extends Polygon
  constructor: (first, second, third) ->
    assert first instanceof Coordinates, "First is not coordinates"
    assert second instanceof Coordinates, "Second is not coordinates"
    assert third instanceof Coordinates, "Third is not coordinates"

    super first, second, third


  # TODO PYTHAGORE


  getFirst: ->
    return @points[0]


  getSecond: ->
    return @points[1]


  getThird: ->
    return @points[2]


  toString: ->
    return """
    Triangle :
      - first :
        #{@getFirst().toString()}
      - second :
        #{@getSecond().toString()}
      - third :
        #{@getThird().toString()}
    """

module.exports = Triangle

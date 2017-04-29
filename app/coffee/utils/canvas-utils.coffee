config = require '../config/config.coffee'

assert = require './assert.coffee'

Coordinates = require './coordinates.coffee'

class CanvasUtils

  @GetCanvas: ->
    return document.getElementById config.canvasId


  @GetMouseCoordinatesInCanvas: (event) ->
    assert event?, "No event"

    mouseCoords = new Coordinates event.clientX, event.clientY
    canvasRect = CanvasUtils.GetCanvas().getBoundingClientRect()
    mouseCoords.x -= canvasRect.left
    mouseCoords.y -= canvasRect.top

    return mouseCoords

module.exports = CanvasUtils

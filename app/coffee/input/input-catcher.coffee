debug       = require '../utils/debug.coffee'
debugThemes = require '../utils/debug-themes.coffee'

class InputCatcher
  constructor: (game) ->
    @game = game

    # Remove canvas context menu
    @game.canvas.oncontextmenu = (event) ->
      event.preventDefault()

    # Mouse Down
    @game.input.mouse.onMouseDown = (event) ->
      @game.state.states.Game.grid.layout.onMouseDown event

    # Mouse Wheel
    @game.input.mouse.onMouseWheel = (event) ->
      @game.state.states.Game.grid.layout.onMouseWheel event

    # Mouse Move
    @game.input.mouse.onMouseMove = (event) ->
      @game.state.states.Game.grid.layout.onMouseMove event

    # Mouse Up
    @game.input.mouse.onMouseUp = (event) ->
      @game.state.states.Game.grid.layout.onMouseUp event

module.exports = InputCatcher

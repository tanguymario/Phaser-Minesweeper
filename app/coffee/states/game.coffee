Phaser = require 'Phaser'

Grid = require '../minesweeper/grid.coffee'
Case = require '../minesweeper/case.coffee'

config      = require '../config/config.coffee'

debug       = require '../utils/debug.coffee'
debugThemes = require '../utils/debug-themes.coffee'

class Game extends Phaser.State
  constructor: ->
    debug 'Constructor...', @, 'info', 30, debugThemes.Phaser
    super


  preload: ->
    debug 'Preload...', @, 'info', 30, debugThemes.Phaser
    @load.pack 'game', config.pack


  create: ->
    debug 'Create...', @, 'info', 30, debugThemes.Phaser
    @grid = new Grid @, 30, 15, 10, 25

    # Remove canvas context menu
    @game.canvas.oncontextmenu = (event) ->
      event.preventDefault()

    # Mouse Down
    @game.input.mouse.onMouseDown = (event) ->
      @game.state.states.Game.grid.layout.input.onMouseDown event

    # Mouse Wheel
    @game.input.mouse.onMouseWheel = (event) ->
      @game.state.states.Game.grid.layout.input.onMouseWheel event

    # Mouse Move
    @game.input.mouse.onMouseMove = (event) ->
      @game.state.states.Game.grid.layout.input.onMouseMove event

    # Mouse Up
    @game.input.mouse.onMouseUp = (event) ->
      @game.state.states.Game.grid.layout.input.onMouseUp event


module.exports = Game

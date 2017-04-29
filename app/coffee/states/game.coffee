Phaser = require 'Phaser'

Grid = require '../minesweeper/grid.coffee'
Case = require '../minesweeper/case.coffee'

MinesweeperThemes = require '../minesweeper/minesweeper-themes.coffee'
MinesweeperConfig = require '../minesweeper/minesweeper-config.coffee'

config      = require '../config/config.coffee'

debug       = require '../utils/debug.coffee'
debugThemes = require '../utils/debug-themes.coffee'

class Game extends Phaser.State
  constructor: ->
    debug 'Constructor...', @, 'info', 30, debugThemes.Phaser
    @theme = MinesweeperThemes.Simple
    super


  preload: ->
    debug 'Preload...', @, 'info', 30, debugThemes.Phaser
    @game.load.spritesheet @theme.key, @theme.source, @theme.spriteSize, @theme.spriteSize


  create: ->
    debug 'Create...', @, 'info', 30, debugThemes.Phaser

    @difficulty = MinesweeperConfig.difficulty.expert

    @grid = new Grid @, @difficulty.w, @difficulty.h, @difficulty.mines, MinesweeperConfig.scale.default, @theme

    # Manage fullscreen
    @game.scale.fullScreenScaleMode = Phaser.ScaleManager.EXACT_FIT
    
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


  toggleFullscreen: ->
    if @game.scale.isFullScreen
      @game.scale.stopFullScreen()
    else
      @game.scale.startFullScreen()


module.exports = Game

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
    @grid = new Grid @, 25, 25, 10, 25
    @game.input.mouse.capture = true;
    @game.canvas.oncontextmenu = (e) ->
      e.preventDefault()

module.exports = Game

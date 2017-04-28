Phaser = require 'Phaser'

Grid = require '../minesweeper/grid.coffee'
Case = require '../minesweeper/case.coffee'

InputCatcher = require '../input/input-catcher.coffee'

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
    @inputCatcher = new InputCatcher @game


module.exports = Game

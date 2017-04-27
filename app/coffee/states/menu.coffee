Phaser = require 'Phaser'

config      = require '../config/config.coffee'

debug       = require '../utils/debug.coffee'
debugThemes = require '../utils/debug-themes.coffee'

class Menu extends Phaser.State
  constructor: ->
    debug 'Constructor...', @, 'info', 30, debugThemes.Phaser
    super

  preload: ->
    debug 'Preload...', @, 'info', 30, debugThemes.Phaser
    @load.pack 'menu', config.pack

  create: ->
    debug 'Create...', @, 'info', 30, debugThemes.Phaser

    @state.start 'Game'

  update: ->
    if @input.activePointer.justPressed()
      @state.start 'Game'


module.exports = Menu

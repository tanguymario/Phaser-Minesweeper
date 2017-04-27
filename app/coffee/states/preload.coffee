Phaser = require 'Phaser'

config      = require '../config/config.coffee'

debug       = require '../utils/debug.coffee'
debugThemes = require '../utils/debug-themes.coffee'

class Preload extends Phaser.State
  constructor: ->
    debug 'Constructor...', @, 'info', 30, debugThemes.Phaser
    super

  preload: ->
    debug 'Preload...', @, 'info', 30, debugThemes.Phaser

    # @load.setPreloadSprite @add.sprite @game.world.centerX - 160, @game.world.centerY - 16, 'preloadBar'

    @stage.backgroundColor = 'black'

    @load.pack 'main', config.pack

  create: ->
    debug 'Create...', @, 'info', 30, debugThemes.Phaser

    @state.start 'Menu'

module.exports = Preload

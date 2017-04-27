Phaser = require 'Phaser'

config      = require '../config/config.coffee'

debug       = require '../utils/debug.coffee'
debugThemes = require '../utils/debug-themes.coffee'

class Boot extends Phaser.State
  constructor: ->
    debug 'Constructor...', @, 'info', 30, debugThemes.Phaser
    super


  preload: ->
    debug 'Preload...', @, 'info', 30, debugThemes.Phaser
    @load.pack 'preload', config.pack


  create: ->
    debug 'Create...', @, 'info', 30, debugThemes.Phaser
    @state.start 'Preload'


module.exports = Boot

###

app.coffee

###


Phaser   = require 'Phaser'

# States
Boot     = require './states/boot.coffee'
Preload  = require './states/preload.coffee'
Menu     = require './states/menu.coffee'
Game     = require './states/game.coffee'

config      = require './config/config.coffee'
debug       = require './utils/debug.coffee'
debugThemes = require './utils/debug-themes.coffee'

game = new Phaser.Game config.width, config.height, Phaser.AUTO, config.canvasId

if game?
  debug 'Phaser Game created successfully!', null, 'info', 0, debugThemes.Phaser
else
  debug 'Phaser Game could not be created!', null, 'error', 0, debugThemes.Phaser

game.state.add 'Boot', Boot
game.state.add 'Preload', Preload
game.state.add 'Menu', Menu
game.state.add 'Game', Game

debug 'Phaser States : ', null, 'info', 10, debugThemes.Phaser, game.state.states

game.state.start 'Boot'

Phaser = require 'Phaser'

assert = require 'assert'

debug       = require '../utils/debug.coffee'
debugThemes = require '../utils/debug-themes.coffee'

class Case
  # Sprite keys
  @S_CASE_UNCLICKED = 'case-unclicked'
  @S_CASE_CLICKED = 'case-clicked'
  @S_CASE_FLAG = 'case-flag'
  @S_CASE_DUNNO_UNCLICKED = 'case-dunno-unclicked'
  @S_CASE_DUNNO_CLICKED = 'case-dunno-clicked'
  @S_CASE_BOMB_UNCLICKED = 'case-bomb-unclicked'
  @S_CASE_BOMB_CLICKED = 'case-bomb-clicked'
  @S_CASE_WRONG_FLAG = 'case-wrong-flag'
  @S_CASE_NUMBERS = [
    'case-clicked'
    'case-1'
    'case-2'
    'case-3'
    'case-4'
    'case-5'
    'case-6'
    'case-7'
    'case-8'
  ]

  # Sprite default size
  @S_SIZE = 16

  constructor: (game, grid, gridCoords, bomb, gameCoords, spriteScale) ->
    @game = game
    @grid = grid

    @coords = gridCoords
    @hasBomb = bomb
    @hasFlag = false
    @discovered = false

    @sprite = @grid.sprites.create gameCoords.x, gameCoords.y, Case.S_CASE_UNCLICKED
    @sprite.inputEnabled = true
    @sprite.events.onInputDown.add @show, @
    @sprite.scale.setTo spriteScale, spriteScale


  show: ->
    @discovered = true
    if @hasBomb
      @clickBomb()
    else
      @grid.sweepCase(@)


  showNbBombsAround: (nbBombsAround) ->
    assert nbBombsAround >= 0 and nbBombsAround <= 8, "Too much bombs : " + nbBombsAround
    @sprite.loadTexture Case.S_CASE_NUMBERS[nbBombsAround]


  clickBomb: ->
    @showBomb true
    @grid.removeListeners()
    @grid.showBombs()


  showBomb: (clicked = false) ->
    if clicked
      spriteKey = Case.S_CASE_BOMB_CLICKED
    else
      spriteKey = Case.S_CASE_BOMB_UNCLICKED

    @sprite.loadTexture spriteKey


  toggleFlag: ->
    @hasFlag = !hasFlag

    if @hasFlag
      spriteKey = Case.S_CASE_FLAG
    else
      spriteKey = Case.S_CASE_UNCLICKED

    @sprite.loadTexture spriteKey


  toggleBomb: ->
    @hasBomb = !@hasBomb


  addBomb: ->
    @hasBomb = true


  removeBomb: ->
    @hasBomb = false


  toString: ->
    return """
    Case :
      - coords : #{@coords}
      - bomb : #{@hasBomb}
      - flag : #{@hasFlag}
      - discovered : #{@discovered}
    """

module.exports = Case

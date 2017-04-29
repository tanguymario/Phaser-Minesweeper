Phaser = require 'Phaser'

assert = require '../utils/assert.coffee'

debug       = require '../utils/debug.coffee'
debugThemes = require '../utils/debug-themes.coffee'

class Case
  # Sprite keys
  @S_CASE_UNCLICKED = 9
  @S_CASE_CLICKED = 0
  @S_CASE_FLAG = 10
  @S_CASE_DUNNO_UNCLICKED = 12
  @S_CASE_DUNNO_CLICKED = 12
  @S_CASE_BOMB_UNCLICKED = 14
  @S_CASE_BOMB_CLICKED = 13
  @S_CASE_WRONG_FLAG = 11
  @S_CASE_NUMBERS = [0, 1, 2, 3, 4, 5, 6, 7, 8]

  constructor: (game, grid, gridCoords, bomb, spritesheetKey) ->
    debug 'constructor...', @, 'info', 100, debugThemes.Case

    @game = game
    @grid = grid

    @coords = gridCoords
    @hasBomb = bomb
    @hasFlag = false
    @discovered = false
    @nbBombsAround = 0
    @nbFlagsAround = 0

    @sprite = @grid.sprites.create 0, 0, spritesheetKey, Case.S_CASE_UNCLICKED
    @sprite.inputEnabled = true
    @sprite.events.onInputDown.add @onClick, @


  onClick: ->
    debug 'onClick...', @, 'info', 100, debugThemes.Case
    if @game.input.activePointer.leftButton.isDown
      @show()
    else if @game.input.activePointer.rightButton.isDown
      @toggleFlag()
    else if @game.input.activePointer.middleButton.isDown
      @showWithFlags()


  show: (sprite, pointer) ->
    debug 'show...', @, 'info', 100, debugThemes.Case
    if not @isClickable()
      return

    @discovered = true
    @grid.nbCasesDiscoveredTotal += 1
    if @hasBomb
      @clickBomb()
    else
      @showNbBombsAround()
      if @nbBombsAround == 0
        cases = @grid.getCasesAround(@)
        for currentCase in cases
          currentCase.show()
      else
        @grid.checkWin()


  showWithFlags: ->
    debug 'showWithFlags...', @, 'info', 100, debugThemes.Case
    if not @discovered
      return

    if @nbFlagsAround == @nbBombsAround
      cases = @grid.getCasesAround(@)
      for currentCase in cases
        currentCase.show()


  showNbBombsAround: ->
    debug 'showNbBombsAround...', @, 'info', 100, debugThemes.Case
    @sprite.frame = Case.S_CASE_NUMBERS[@nbBombsAround]


  clickBomb: ->
    debug 'clickBomb...', @, 'info', 100, debugThemes.Case
    @showBomb true
    @grid.triggerEnd()


  showBomb: (clicked = false) ->
    debug 'showBomb...', @, 'info', 100, debugThemes.Case
    if clicked
      spriteKey = Case.S_CASE_BOMB_CLICKED
    else
      spriteKey = Case.S_CASE_BOMB_UNCLICKED

    @sprite.frame = spriteKey


  showWrongFlag: ->
    debug 'showWrongFlag...', @, 'info', 100, debugThemes.Case
    @sprite.frame = Case.S_CASE_WRONG_FLAG


  showInitial: ->
    debug 'showInitial...', @, 'info', 100, debugThemes.Case
    @sprite.frame = Case.S_CASE_UNCLICKED


  showMaybe: ->
    debug 'showMaybe...', @, 'info', 100, debugThemes.Case
    @sprite.frame = Case.S_CASE_CLICKED


  toggleFlag: ->
    debug 'toggleFlag...', @, 'info', 100, debugThemes.Case
    if @discovered
      return

    @hasFlag = !@hasFlag

    if @hasFlag
      nbFlagsDifference = 1
      spriteKey = Case.S_CASE_FLAG
    else
      nbFlagsDifference = -1
      spriteKey = Case.S_CASE_UNCLICKED

    cases = @grid.getCasesAround(@)
    for currentCase in cases
      currentCase.nbFlagsAround += nbFlagsDifference

    @grid.nbFlagsTotal += nbFlagsDifference
    @grid.checkWin()

    @sprite.frame = spriteKey


  toggleBomb: ->
    debug 'toggleBomb...', @, 'info', 100, debugThemes.Case
    @hasBomb = !@hasBomb


  addBomb: ->
    debug 'addBomb...', @, 'info', 100, debugThemes.Case
    @hasBomb = true


  removeBomb: ->
    debug 'removeBomb...', @, 'info', 100, debugThemes.Case
    @hasBomb = false


  isClickable: ->
    debug 'isClickable...', @, 'info', 100, debugThemes.Case
    return not @discovered and not @hasFlag


  isANeighbourOf: (otherCase) ->
    casesAround = @grid.getCasesAround @
    for caseAround in casesAround
      return true if caseAround == otherCase

    return false


  getCasesAround: ->
    return @grid.getCasesAround @


  toString: ->
    debug 'toString...', @, 'info', 100, debugThemes.Case
    return """
    Case :
      - coords : #{@coords}
      - bomb : #{@hasBomb}
      - flag : #{@hasFlag}
      - discovered : #{@discovered}
    """

module.exports = Case

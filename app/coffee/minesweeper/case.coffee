Phaser = require 'Phaser'

Coordinates = require '../utils/coordinates.coffee'

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


  show: (sprite, pointer) ->
    debug 'show...', @, 'info', 100, debugThemes.Case
    if not @isClickable()
      return

    @showDownDiselected()

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


  showDownDiselected: ->
    debug 'showDiselected...', @, 'info', 100, debugThemes.Case

    # Simple change frame
    ###
    @sprite.frame = Case.S_CASE_UNCLICKED
    ###

    # Reset 1st tween
    ###
    tween = @game.add.tween @sprite
    tween.to @topLeft, 100, Phaser.Easing.Exponential.easeOut
    tween.start()
    ###

    ###
    tween = @game.add.tween @sprite.scale
    tween.to {x: @scale, y: @scale}, 100, Phaser.Easing.Exponential.easeOut
    tween.start()
    ###

    tween = @game.add.tween @sprite
    tween.to {angle: 0}, 100, Phaser.Easing.Exponential.easeOut
    tween.start()


  showDownSelected: ->
    debug 'showSelected...', @, 'info', 100, debugThemes.Case

    # Simple change frame
    ###
    @sprite.frame = Case.S_CASE_CLICKED
    ###

    ###
    tween = @game.add.tween @sprite
    targetCoords = Coordinates.Add @topLeft, new Coordinates -3, -3
    tween.to targetCoords, 100, Phaser.Easing.Exponential.easeOut
    tween.start()
    ###

    ###
    tween = @game.add.tween @sprite.scale
    tween.to {x: @scale * 1.15, y: @scale * 1.15}, 100, Phaser.Easing.Exponential.easeOut
    tween.start()
    ###

    tween = @game.add.tween @sprite
    tween.to {angle: 90}, 100, Phaser.Easing.Exponential.easeOut
    tween.start()


  showOverDiselected: ->
    # TODO


  showOverSelected: ->
    # TODO


  updateCaseTransform: (gameCoords, spriteScale) ->
    @topLeft = @grid.layout.getGameCoords(@)
    @scale = spriteScale

    @sprite.x = @topLeft.x
    @sprite.y = @topLeft.y
    @sprite.scale.setTo spriteScale, spriteScale

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

Coordinates = require '../utils/coordinates.coffee'

Case = require './case.coffee'

assert = require 'assert'

debug       = require '../utils/debug.coffee'
debugThemes = require '../utils/debug-themes.coffee'

class GridLayout
  constructor: (grid) ->
    @grid = grid
    @game = @grid.game

    @isMoving = false
    @offset = new Coordinates @game.world.centerX, @game.world.centerY


  getTopLeftCoords: ->
    topLeftX = @offset - (@grid.caseSize * @grid.w) / 2 - @grid.caseSize / 2
    topLeftY = @offset - (@grid.caseSize * @grid.h) / 2 - @grid.caseSize / 2
    return new Coordinates topLeftX, topLeftY


  zoomGrid: (event) ->
    @caseSize += event.wheelDeltaY / Grid.I_ZOOM_FACTOR
    @updateCasesTransform()


  updateCasesTransform: ->
    topLeftCoords = @getTopLeftCoords()
    currentGameCoords = topLeftCoords.clone()

    spriteScale = @grid.caseSize / Case.S_SIZE

    for i in [0..@grid.w - 1] by 1
      for j in [0..@grid.h - 1] by 1
        currentSprite = @grid.tab[i][j].sprite

        # Position
        currentSprite.x = currentGameCoords.x
        currentSprite.y = currentGameCoords.y

        # Scale
        currentSprite.scale.setTo spriteScale

        currentGameCoords.y += @grid.caseSize

      currentGameCoords.y = topLeftCoords.y
      currentGameCoords.x += @grid.caseSize


  # Mouse events
  onMouseDown: (event) ->
    if event.shiftKey
      if event.button == 1
        @isMoving = true
    else
      caseClicked = @grid.getCaseAtGameCoords()
      if caseClicked?
        caseClicked.show()


  onMouseMove: (event) ->
    if not @isMoving
      return

    console.log event
    # @offset.x += event.
    # @offset.y += event.

    @grid.updateCasesTransform()


  onMouseUp: (event) ->
    if @isMoving and event.button == 1
      @isMoving = false


  onMouseWheel: (event) ->
    if event.shiftKey
      @zoomGrid event


module.exports = GridLayout

Coordinates = require '../utils/coordinates.coffee'

Case = require './case.coffee'
GridInput = require './grid-input.coffee'

Rectangle = require '../utils/geometry/rectangle.coffee'

assert = require '../utils/assert.coffee'

debug       = require '../utils/debug.coffee'
debugThemes = require '../utils/debug-themes.coffee'

class GridLayout

  @I_ZOOM_FACTOR = 50

  constructor: (game, grid, caseSize) ->
    @game = game
    @grid = grid
    @caseSize = caseSize

    @offset = new Coordinates @game.world.centerX, @game.world.centerY

    @updateGridRect()

    @input = new GridInput @game, @

  getCaseAtGameCoords: (coords) ->
    if @rect.isInside coords, false
      topLeft = @rect.getTopLeft()
      coords = Coordinates.Sub coords, topLeft
      column = Math.floor coords.x / @caseSize
      line = Math.floor coords.y / @caseSize

      gridCoords = new Coordinates column, line
      return @grid.getCaseAtGridCoords gridCoords

    return null


  moveGrid: (coords) ->
    @offset = Coordinates.Add @offset, coords
    @updateGridRect()
    @updateCasesTransform()


  zoomGrid: (value) ->
    @updateGridRect @caseSize + value
    @updateCasesTransform()


  updateGridRect: (caseSize = @caseSize) ->
    @caseSize = caseSize

    topLeftX = @offset.x - (@caseSize * @grid.w) / 2 - @caseSize / 2
    topLeftY = @offset.y - (@caseSize * @grid.h) / 2 - @caseSize / 2
    topLeftCoords = new Coordinates topLeftX, topLeftY

    widthPixels = @caseSize * @grid.w
    heightPixels = @caseSize * @grid.h

    @rect = new Rectangle topLeftCoords, widthPixels, heightPixels


  updateCasesTransform: ->
    currentGameCoords = @rect.getTopLeft().clone()

    spriteScale = @caseSize / Case.S_SIZE

    for i in [0..@grid.w - 1] by 1
      for j in [0..@grid.h - 1] by 1
        currentSprite = @grid.tab[i][j].sprite

        # Position
        currentSprite.x = currentGameCoords.x
        currentSprite.y = currentGameCoords.y

        # Scale
        currentSprite.scale.setTo spriteScale, spriteScale

        currentGameCoords.y += @caseSize

      currentGameCoords.y = @rect.getTopLeft().y
      currentGameCoords.x += @caseSize


module.exports = GridLayout

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
    debug 'Constructor...', @, 'info', 100, debugThemes.Grid
    @game = game
    @grid = grid
    @caseSize = caseSize

    @offset = new Coordinates @game.world.centerX, @game.world.centerY

    @updateGridRect()

    @input = new GridInput @game, @

  getCaseAtGameCoords: (coords) ->
    debug 'getCaseAtGameCoords...', @, 'info', 100, debugThemes.Grid
    if @rect.isInside coords, false
      topLeft = @rect.getTopLeft()
      coords = Coordinates.Sub coords, topLeft
      column = Math.floor coords.x / @caseSize
      line = Math.floor coords.y / @caseSize

      gridCoords = new Coordinates column, line
      return @grid.getCaseAtGridCoords gridCoords

    return null


  getGameCoords: (currentCase) ->
    debug 'getGameCoords...', @, 'info', 100, debugThemes.Grid
    assert currentCase?, 'Current case null'

    gameCoords = @rect.getTopLeft().clone()
    gameCoords.x += currentCase.coords.x * @caseSize
    gameCoords.y += currentCase.coords.y * @caseSize

    return gameCoords

  moveGrid: (coords) ->
    debug 'moveGrid...', @, 'info', 100, debugThemes.Grid
    @offset = Coordinates.Add @offset, coords
    @updateGridRect()
    @updateCasesTransform()


  zoomGrid: (value) ->
    debug 'zoomGrid...', @, 'info', 100, debugThemes.Grid
    @updateGridRect @caseSize + value
    @updateCasesTransform()


  updateGridRect: (caseSize = @caseSize) ->
    debug 'updateGridRect...', @, 'info', 100, debugThemes.Grid
    @caseSize = caseSize

    topLeftX = @offset.x - (@caseSize * @grid.w) / 2 - @caseSize / 2
    topLeftY = @offset.y - (@caseSize * @grid.h) / 2 - @caseSize / 2
    topLeftCoords = new Coordinates topLeftX, topLeftY

    widthPixels = @caseSize * @grid.w
    heightPixels = @caseSize * @grid.h

    @rect = new Rectangle topLeftCoords, widthPixels, heightPixels


  updateCasesTransform: ->
    debug 'updateCasesTransform...', @, 'info', 100, debugThemes.Grid
    currentGameCoords = @rect.getTopLeft().clone()

    spriteScale = @caseSize / @grid.theme.spriteSize

    for i in [0..@grid.w - 1] by 1
      for j in [0..@grid.h - 1] by 1
        @grid.tab[i][j].updateCaseTransform currentGameCoords, spriteScale

        currentGameCoords.y += @caseSize

      currentGameCoords.y = @rect.getTopLeft().y
      currentGameCoords.x += @caseSize


module.exports = GridLayout

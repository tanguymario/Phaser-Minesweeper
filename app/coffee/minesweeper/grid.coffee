Coordinates = require '../utils/coordinates.coffee'

Rectangle = require '../utils/geometry/rectangle.coffee'

GridLayout = require './grid-layout.coffee'

Case = require './case.coffee'

assert = require '../utils/assert.coffee'

debug       = require '../utils/debug.coffee'
debugThemes = require '../utils/debug-themes.coffee'

class Grid
  constructor: (game, w, h, nbBombs, caseSize) ->
    assert nbBombs < w * h, "Too much bombs!"

    @game = game

    @w = w
    @h = h
    @nbBombs = nbBombs
    @sprites = @game.add.group()
    @layout = new GridLayout @game, @, caseSize

    @nbCasesTotal = w * h
    @nbFlagsTotal = 0
    @nbCasesDiscoveredTotal = 0

    # Generate blank map
    @tab = new Array(@w)
    for i in [0..@w - 1] by 1
      @tab[i] = new Array(@h)
      for j in [0..@h - 1] by 1
        currentGridCoords = new Coordinates(i, j)
        @tab[i][j] = new Case @game, @, currentGridCoords, false

    # Generate bombs in the map
    @generateBombs()

    # Update bombs
    for i in [0..@w - 1] by 1
      for j in [0..@h - 1] by 1
        @tab[i][j].updateNbBombsAroundCase()

    @layout.updateCasesTransform()



  checkWin: ->
    if @nbCasesDiscoveredTotal >= @nbCasesTotal - @nbBombs and @nbFlagsTotal == @nbBombs
      alert 'win!'


  getNbBomsAroundCase: (centerCase) ->
    nbBombsAround = 0
    currCaseCoords = centerCase.coords.clone()
    for i in [-1..1] by 1
      for j in [-1..1] by 1
        if i == 0 and j == 0
          continue

        currCaseCoords.x = centerCase.coords.x + i
        currCaseCoords.y = centerCase.coords.y + j

        # Check if case in grid
        if not @isInGridCoords currCaseCoords
          continue

        # Check if the case was not discovered
        currentCase = @getCaseAtGridCoords currCaseCoords
        if currentCase.hasBomb
          nbBombsAround += 1

    return nbBombsAround


  getCasesAround: (centerCase) ->
    cases = new Array()
    currCaseCoords = centerCase.coords.clone()

    for i in [-1..1] by 1
      for j in [-1..1] by 1
        if i == 0 and j == 0
          continue

        currCaseCoords.x = centerCase.coords.x + i
        currCaseCoords.y = centerCase.coords.y + j

        # Check if case in grid
        if not @isInGridCoords currCaseCoords
          continue

        # Check if the case was not discovered
        currentCase = @getCaseAtGridCoords currCaseCoords
        cases.push currentCase

    return cases


  showBombs: ->
    for i in [0..@w - 1] by 1
      for j in [0..@h - 1] by 1
        currentCase = @tab[i][j]
        if not currentCase.discovered
          if currentCase.hasBomb
            currentCase.showBomb()
          else if currentCase.hasFlag
            currentCase.showWrongFlag()


  generateBombs: () ->
    for i in [0..@nbBombs - 1] by 1
      currentCase = @getRandomCase()
      while currentCase.hasBomb
        currentCase = @getRandomCase()

      currentCase.addBomb()


  getCaseAtGridCoords: (gridcoords) ->
    assert gridcoords.x >= 0 and gridcoords.x < @w, "Column out of range : " + gridcoords.x
    assert gridcoords.y >= 0 and gridcoords.y < @h, "Line out of range : " + gridcoords.y

    return @tab[gridcoords.x][gridcoords.y]


  getRandomCase: ->
    randomCoords = @getRandomCoordinates()
    return @getCaseAtGridCoords randomCoords


  getRandomCoordinates: ->
    randomX = Math.floor(Math.random() * @w)
    randomY = Math.floor(Math.random() * @h)
    randomCoords = new Coordinates randomX, randomY


  isInGridCoords: (gridcoords) ->
    return gridcoords.x >= 0 and gridcoords.y >= 0 and gridcoords.x < @w and gridcoords.y < @h


  toString: ->
    return """
    Grid :
      - w : #{@w}
      - h : #{@h}
      - nbBombs : #{@nbBombs}
      - tab : #{@tab}
    """


module.exports = Grid

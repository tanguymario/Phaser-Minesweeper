Coordinates = require '../utils/coordinates.coffee'

Rectangle = require '../utils/geometry/rectangle.coffee'

GridLayout = require './grid-layout.coffee'

Case = require './case.coffee'

assert = require '../utils/assert.coffee'

debug       = require '../utils/debug.coffee'
debugThemes = require '../utils/debug-themes.coffee'

class Grid
  constructor: (game, w, h, nbBombs, caseSize, minesweeperTheme) ->
    debug 'Constructor...', @, 'info', 100, debugThemes.Grid

    assert nbBombs < w * h, "Too much bombs!"

    @game = game

    @w = w
    @h = h
    @nbBombs = nbBombs
    @sprites = @game.add.group()
    @layout = new GridLayout @game, @, caseSize
    @theme = minesweeperTheme
    @firstCaseCanBeEmpty = @nbBombs + 9 < w * h

    @isOver = false
    @hasWin = false

    @nbCasesTotal = w * h
    @nbFlagsTotal = 0
    @nbCasesDiscoveredTotal = 0

    # Generate blank map
    @tab = new Array(@w)
    for i in [0..@w - 1] by 1
      @tab[i] = new Array(@h)
      for j in [0..@h - 1] by 1
        currentGridCoords = new Coordinates(i, j)
        @tab[i][j] = new Case @game, @, currentGridCoords, false, @theme.key

    @layout.updateCasesTransform()


  checkWin: ->
    debug 'checkWin...', @, 'info', 100, debugThemes.Grid
    if @nbCasesDiscoveredTotal >= @nbCasesTotal - @nbBombs and @nbFlagsTotal == @nbBombs
      alert 'win!'
      @isOver = true
      @hasWin = true


  triggerEnd: ->
    debug 'triggerEnd...', @, 'info', 100, debugThemes.Grid
    @isOver = true
    @showBombs()


  getNbBomsAroundCase: (centerCase) ->
    debug 'getNbBombsAroundCase...', @, 'info', 100, debugThemes.Grid
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
    debug 'getCasesAround...', @, 'info', 100, debugThemes.Grid
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
    debug 'showBombs...', @, 'info', 100, debugThemes.Grid
    for i in [0..@w - 1] by 1
      for j in [0..@h - 1] by 1
        currentCase = @tab[i][j]
        if not currentCase.discovered
          if currentCase.hasBomb
            if not currentCase.hasFlag
              currentCase.showBomb()
          else if currentCase.hasFlag
            currentCase.showWrongFlag()


  generateBombs: (firstCaseClicked) ->
    debug 'generateBombs...', @, 'info', 100, debugThemes.Grid
    for i in [0..@nbBombs - 1] by 1
      currentCase = @getRandomCase()
      while not @isBombAtCorrectPlace currentCase, firstCaseClicked
        currentCase = @getRandomCase()

      currentCase.addBomb()

      cases = @getCasesAround currentCase
      for myCase in cases
        myCase.nbBombsAround += 1


  isBombAtCorrectPlace: (currentCase, firstCaseClicked) ->
    if not currentCase.hasBomb
      if currentCase != firstCaseClicked
        if @firstCaseCanBeEmpty
          return not currentCase.isANeighbourOf firstCaseClicked
        else
          return true

    return false


  getCaseAtGridCoords: (gridcoords) ->
    debug 'getCaseAtGridCoords...', @, 'info', 100, debugThemes.Grid

    assert gridcoords.x >= 0 and gridcoords.x < @w, "Column out of range : " + gridcoords.x
    assert gridcoords.y >= 0 and gridcoords.y < @h, "Line out of range : " + gridcoords.y

    return @tab[gridcoords.x][gridcoords.y]


  getRandomCase: ->
    debug 'getRandomCase...', @, 'info', 100, debugThemes.Grid
    randomCoords = @getRandomCoordinates()
    return @getCaseAtGridCoords randomCoords


  getRandomCoordinates: ->
    debug 'getRandomCoordinates...', @, 'info', 100, debugThemes.Grid
    randomX = Math.floor(Math.random() * @w)
    randomY = Math.floor(Math.random() * @h)
    randomCoords = new Coordinates randomX, randomY


  isInGridCoords: (gridcoords) ->
    debug 'isInGridCoords...', @, 'info', 100, debugThemes.Grid
    return gridcoords.x >= 0 and gridcoords.y >= 0 and gridcoords.x < @w and gridcoords.y < @h


  toString: ->
    debug 'toString...', @, 'info', 100, debugThemes.Grid
    return """
    Grid :
      - w : #{@w}
      - h : #{@h}
      - nbBombs : #{@nbBombs}
      - tab : #{@tab}
    """


module.exports = Grid

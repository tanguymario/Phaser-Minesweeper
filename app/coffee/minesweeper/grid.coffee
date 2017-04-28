Coordinates = require '../utils/coordinates.coffee'

Case = require './case.coffee'

assert = require 'assert'

debug       = require '../utils/debug.coffee'
debugThemes = require '../utils/debug-themes.coffee'

class Grid

  @I_ZOOM_FACTOR = 50

  constructor: (game, w, h, nbBombs, caseSize) ->
    assert nbBombs < w * h, "Too much bombs!"

    @game = game

    @w = w
    @h = h
    @nbBombs = nbBombs
    @caseSize = caseSize
    @sprites = @game.add.group()

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


    @updateCasesTransform()

  zoomGrid: (event) ->
    if event.shiftKey
      @caseSize += event.wheelDeltaY / Grid.I_ZOOM_FACTOR
      @updateCasesTransform()


  updateCasesTransform: ->
    topLeftX = @game.world.centerX - (@caseSize * @w) / 2 - @caseSize / 2
    topLeftY = @game.world.centerY - (@caseSize * @h) / 2 - @caseSize / 2
    topLeftCoords = new Coordinates topLeftX, topLeftY
    currentGameCoords = topLeftCoords.clone()

    spriteScale = @caseSize / Case.S_SIZE

    for i in [0..@w - 1] by 1
      for j in [0..@h - 1] by 1
        currentSprite = @tab[i][j].sprite

        # Position
        currentSprite.x = currentGameCoords.x
        currentSprite.y = currentGameCoords.y

        # Scale
        currentSprite.scale.setTo spriteScale

        currentGameCoords.y += @caseSize

      currentGameCoords.y = topLeftCoords.y
      currentGameCoords.x += @caseSize


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
        if not @isInGrid currCaseCoords
          continue

        # Check if the case was not discovered
        currentCase = @getCaseAt currCaseCoords
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
        if not @isInGrid currCaseCoords
          continue

        # Check if the case was not discovered
        currentCase = @getCaseAt currCaseCoords
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


  removeListeners: ->
    for i in [0..@w - 1] by 1
      for j in [0..@h - 1] by 1
        @tab[i][j].sprite.inputEnabled = false


  generateBombs: () ->
    for i in [0..@nbBombs - 1] by 1
      currentCase = @getRandomCase()
      while currentCase.hasBomb
        currentCase = @getRandomCase()

      currentCase.addBomb()


  getCaseAt: (gridcoords) ->
    assert gridcoords.x >= 0 and gridcoords.x < @w, "Column out of range : " + gridcoords.x
    assert gridcoords.y >= 0 and gridcoords.y < @h, "Line out of range : " + gridcoords.y

    return @tab[gridcoords.x][gridcoords.y]


  getRandomCase: ->
    randomCoords = @getRandomCoordinates()
    return @getCaseAt randomCoords


  getRandomCoordinates: ->
    randomX = Math.floor(Math.random() * @w)
    randomY = Math.floor(Math.random() * @h)
    randomCoords = new Coordinates randomX, randomY


  isInGrid: (gridcoords) ->
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

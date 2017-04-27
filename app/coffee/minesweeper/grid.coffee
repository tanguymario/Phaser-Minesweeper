Coordinates = require '../utils/coordinates.coffee'

Case = require './case.coffee'

assert = require 'assert'

debug       = require '../utils/debug.coffee'
debugThemes = require '../utils/debug-themes.coffee'

class Grid
  constructor: (game, w, h, nbBombs, caseSize) ->
    assert nbBombs < w * h, "Too much bombs!"

    @game = game

    @w = w
    @h = h
    @nbBombs = nbBombs
    @caseSize = caseSize
    @sprites = @game.add.group()

    topLeftX = @game.world.centerX - (@caseSize * @w) / 2 - @caseSize / 2
    topLeftY = @game.world.centerY - (@caseSize * @h) / 2 - @caseSize / 2
    topLeftCoords = new Coordinates topLeftX, topLeftY
    currentGameCoords = topLeftCoords.clone()

    spriteScale = @caseSize / Case.S_SIZE

    # Generate blank map
    @tab = new Array(@w)
    for i in [0..@w - 1] by 1
      @tab[i] = new Array(@h)
      for j in [0..@h - 1] by 1
        currentGridCoords = new Coordinates(i, j)
        @tab[i][j] = new Case @game, @, currentGridCoords, false, currentGameCoords, spriteScale

        currentGameCoords.y += @caseSize

      currentGameCoords.y = topLeftCoords.y
      currentGameCoords.x += @caseSize

    # Generate bombs in the map
    @generateBombs()

    for i in [0..@w - 1] by 1
      for j in [0..@h - 1] by 1
        currentCase = @tab[i][j]
        currentCase.nbBombsAround = @getNbBomsAroundCase currentCase


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


  getCaseAt: (coords) ->
    assert coords.x >= 0 and coords.x < @w, "Column out of range : " + coords.x
    assert coords.y >= 0 and coords.y < @h, "Line out of range : " + coords.y

    return @tab[coords.x][coords.y]


  getRandomCase: ->
    randomCoords = @getRandomCoordinates()
    return @getCaseAt randomCoords


  getRandomCoordinates: ->
    randomX = Math.floor(Math.random() * @w)
    randomY = Math.floor(Math.random() * @h)
    randomCoords = new Coordinates randomX, randomY


  isInGrid: (coords) ->
    return coords.x >= 0 and coords.y >= 0 and coords.x < @w and coords.y < @h


  toString: ->
    return """
    Grid :
      - w : #{@w}
      - h : #{@h}
      - nbBombs : #{@nbBombs}
      - tab : #{@tab}
    """


module.exports = Grid

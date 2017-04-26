Coordinates = require '../utils/coordinates.coffee'

Case = require '../mines/case.coffee'
CaseVide = require '../mines/case-vide.coffee'
CaseBomb = require '../mines/case-bomb.coffee'

class Grid
  constructor: (game, w, h, nbBombs) ->
    @game = game

    @w = w
    @h = h
    @nbBombs = nbBombs

    @bombsCoords = @generateBombs w, h, nbBombs

    # TODO Array getAT()

    @tab = new Array(w)
    for i in [0..@w - 1] by 1
      @tab[i] = new Array(h)
      for j in [0..@h - 1] by 1
        @tab[i][j] = new CaseVide @game, i, j

    for i in [0..@bombsCoords.length - 1] by 1
      bombCoords = @bombsCoords[i]
      @tab[bombCoords.x][bombCoords.y] = new CaseBomb @game, bombCoords


  generateBombs: () ->
    bombsCoords = new Array()

    for i in [0..@nbBombs - 1] by 1
      randomX = Math.floor(Math.random() * @w)
      randomY = Math.floor(Math.random() * @h)
      randomCoords = new Coordinates randomX, randomY

      # TODO check if bomb already exists
      bombsCoords.push randomCoords

    return bombs

module.exports = Grid

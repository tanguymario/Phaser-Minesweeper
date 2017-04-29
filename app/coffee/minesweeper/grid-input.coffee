Coordinates = require '../utils/coordinates.coffee'

Case = require './case.coffee'

CanvasUtils = require '../utils/canvas-utils.coffee'

assert = require '../utils/assert.coffee'

debug       = require '../utils/debug.coffee'
debugThemes = require '../utils/debug-themes.coffee'

class GridInput

  @I_ZOOM_FACTOR = 50
  @I_MOUSE_LEFT = 0
  @I_MOUSE_MIDDLE = 1
  @I_MOUSE_RIGHT = 2

  constructor: (game, gridLayout) ->
    debug 'constructor...', @, 'info', 100, debugThemes.Grid
    @game = game
    @gridLayout = gridLayout
    @grid = @gridLayout.grid

    @caseActive = null
    @currentButton = null
    @isMoving = false

    @isFirstMouseUp = true


  # Mouse events
  onMouseDown: (event) ->
    debug 'onMouseDown...', @, 'info', 100, debugThemes.Grid
    if @currentButton?
      return

    @currentButton = event.button

    if event.shiftKey
      @isMoving = true
    else if not @grid.isOver
      caseClicked = @getCaseFromMouse event
      if caseClicked?
        switch @currentButton
          when GridInput.I_MOUSE_LEFT, GridInput.I_MOUSE_MIDDLE then @setCaseActive caseClicked
          when GridInput.I_MOUSE_RIGHT then caseClicked.toggleFlag()


  onMouseMove: (event) ->
    debug 'onMouseMove...', @, 'info', 1000, debugThemes.Grid
    if not @currentButton?
      return

    if @isMoving
      movement = new Coordinates event.movementX, event.movementY
      @gridLayout.moveGrid movement
    else if @currentButton? and not @grid.isOver
      if @currentButton != GridInput.I_MOUSE_RIGHT
        caseOnMouse = @getCaseFromMouse event
        if caseOnMouse != @caseActive
          switch @currentButton
            when GridInput.I_MOUSE_LEFT, GridInput.I_MOUSE_MIDDLE then @setCaseActive caseOnMouse


  onMouseUp: (event) ->
    debug 'onMouseUp...', @, 'info', 100, debugThemes.Grid
    if @isMoving
      @isMoving = false
    else if not event.shiftKey and not @grid.isOver
      if @caseActive?
        switch event.button
          when GridInput.I_MOUSE_MIDDLE then @caseActive.showWithFlags()
          when GridInput.I_MOUSE_LEFT
            if @isFirstMouseUp
              @grid.generateBombs @caseActive
              @isFirstMouseUp = false
            @caseActive.show()

      @setCaseActive null

    @currentButton = null


  onMouseWheel: (event) ->
    debug 'onMouseDown...', @, 'info', 1000, debugThemes.Grid
    if event.shiftKey
      @gridLayout.zoomGrid event.wheelDeltaY / GridInput.I_ZOOM_FACTOR


  setCaseActive: (caseActive) ->
    debug 'setCaseActive...', @, 'info', 1000, debugThemes.Grid
    if @caseActive?
      @caseActive.showInitial() if @caseActive.isClickable()
      switch @currentButton
        when GridInput.I_MOUSE_MIDDLE
          casesAround = @caseActive.getCasesAround()
          for caseAround in casesAround
            if caseAround.isClickable()
              caseAround.showInitial()

    if caseActive?
      caseActive.showMaybe() if caseActive.isClickable()
      switch @currentButton
        when GridInput.I_MOUSE_MIDDLE
          casesAround = caseActive.getCasesAround()
          for caseAround in casesAround
            if caseAround.isClickable()
              caseAround.showMaybe()

    @caseActive = caseActive


  getCaseFromMouse: (event) ->
    debug 'getCaseFromMouse...', @, 'info', 1000, debugThemes.Grid
    mouseCoords = CanvasUtils.GetMouseCoordinatesInCanvas event
    return @gridLayout.getCaseAtGameCoords mouseCoords


module.exports = GridInput

Coordinates = require '../utils/coordinates.coffee'

Case = require './case.coffee'

CanvasUtils = require '../utils/canvas-utils.coffee'

assert = require '../utils/assert.coffee'

debug       = require '../utils/debug.coffee'
debugThemes = require '../utils/debug-themes.coffee'

class GridInput

  @I_ZOOM_FACTOR = 50
  @I_MOUSE_LEFT_BUTTON = 0
  @I_MOUSE_MIDDLE_BUTTON = 1
  @I_MOUSE_RIGHT_BUTTON = 2

  constructor: (game, gridLayout) ->
    @game = game
    @gridLayout = gridLayout

    @caseActive = null
    @currentButton = null
    @isMoving = false


  # Mouse events
  onMouseDown: (event) ->
    @currentButton = event.button

    if event.shiftKey
      if event.button == 1
        @isMoving = true
    else
      caseClicked = @getCaseFromMouse event
      if caseClicked?
        switch event.button
          when 0, 1 then @setCaseActive caseClicked
          when 2 then caseClicked.toggleFlag()


  onMouseMove: (event) ->
    if not @currentButton?
      return

    if @isMoving
      movement = new Coordinates event.movementX, event.movementY
      @gridLayout.moveGrid movement
    else if @currentButton?
      if @currentButton != GridInput.I_MOUSE_RIGHT_BUTTON
        caseOnMouse = @getCaseFromMouse event
        if caseOnMouse != @caseActive
          @setCaseActive caseOnMouse


  onMouseUp: (event) ->
    if @isMoving and event.button == 1
      @isMoving = false
    else if not event.shiftKey
      if @caseActive?
        switch event.button
          when 0 then @caseActive.show()
          when 1 then @caseActive.showWithFlags()

      @caseActive = null

    @currentButton = null


  onMouseWheel: (event) ->
    if event.shiftKey
      @gridLayout.zoomGrid event.wheelDeltaY / GridInput.I_ZOOM_FACTOR


  setCaseActive: (caseActive) ->
    if @caseActive? and @caseActive.isClickable()
      @caseActive.showInitial()

    if caseActive? and caseActive.isClickable()
      if @currentButton == GridInput.I_MOUSE_LEFT_BUTTON
        caseActive.showMaybe()

    @caseActive = caseActive


  getCaseFromMouse: (event) ->
    mouseCoords = CanvasUtils.GetMouseCoordinatesInCanvas event
    return @gridLayout.getCaseAtGameCoords mouseCoords


module.exports = GridInput

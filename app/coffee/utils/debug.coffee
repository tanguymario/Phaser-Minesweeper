debugThemes = require './debug-themes.coffee'

environmentVars = require '../config/environment-vars.coffee'
env = require '../config/env.coffee'

DEBUG = env != environmentVars.release

PRIORITY = 50

WHITELIST = []

# Get console function
getConsoleFunction = (type) ->
  switch type
    when 'log' then return console.log
    when 'info' then return console.info
    when 'debug' then return console.debug
    when 'warn' then return console.warn
    when 'error' then return console.error
    else return console.log


# Return CSS properties associated to a theme
getOptionsFromTheme = (theme) ->
  switch theme
    when debugThemes.Phaser then return 'color:white; background:rgba(225, 0, 0, 0.85); display:block;'
    when debugThemes.Player then return 'color:white; background:rgba(0, 0, 225, 0.85); display: block;'
    when debugThemes.Case then return 'color:white; background:rgba(92, 11, 232, 0.85); display: block;'
    when debugThemes.Grid then return 'color:white; background:rgba(0, 245, 0, 0.9); display:block'
    when debugThemes.Other then return 'color:white; background:rgba(125, 125, 125, 0.85); display: block;'
    else return null


module.exports = (message, caller=null, type='log', priority=Infinity, theme=null, stuff...) ->
  # No Debug or no message
  if not DEBUG or not message?
    return

  # Priority
  if priority > PRIORITY
    return

  # If a caller was informed and it was an object
  if caller? and typeof caller == "object"
    message = """
    -- #{caller.constructor.name} --
    #{message}
    """

  # Get console function (log, info..)
  consoleFunction = getConsoleFunction type

  # Get theme
  if theme? and theme in debugThemes.enums
    options = getOptionsFromTheme theme

  if stuff? and stuff.length == 0
    stuff = null

  # Do the output
  if options?
    if stuff?
      consoleFunction "%c " + message, options, stuff
    else
      consoleFunction "%c " + message, options
  else if stuff?
    consoleFunction message, stuff
  else
    consoleFunction message

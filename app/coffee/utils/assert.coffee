assert = require 'assert'

environmentVars = require '../config/environment-vars.coffee'
env = require '../config/env.coffee'

if env != environmentVars.release
  module.exports = (condition, message) ->
    assert condition, message
else
  module.exports = () ->
    undefined

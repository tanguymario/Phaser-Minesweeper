clamp = require './clamp.coffee'

module.exports = (a, b, t) ->
  # Set t in [0..1]
  t = clamp t, 0, 1
  return a + t * (b - a)

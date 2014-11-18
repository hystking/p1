browserify = require "browserify"
transform = require "vinyl-transform"
colors = require "colors"

coffeeify = (param) ->
  transform (filename) ->
    browserify filename, param
      .transform {}, "coffeeify"
      .bundle()
      .on "error", (err) ->
        console.log colors.red err
        @emit "end"

module.exports = coffeeify

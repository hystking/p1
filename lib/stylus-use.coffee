_ = require "lodash"
stylus = require "stylus"

nodes = stylus.nodes

parse = (obj) ->
  switch typeof obj
    when "string"
      ltr = new nodes.Literal obj
      ltr.filename = ""
      ltr
    when "object"
      _.mapValues obj, parse

module.exports = ({globalParam}) -> (styl) ->
  _.each globalParam, (val, key) ->
    styl.define key, (parse val), true

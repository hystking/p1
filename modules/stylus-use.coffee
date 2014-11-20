_ = require "lodash"
path = require "path"
stylus = require "stylus"
fs = require "fs"

nodes = stylus.nodes

uint16 = (b) -> b[1] << 8 | b[0]
uint32 = (b) -> b[0] << 24 | b[1] << 16 | b[2] << 8 | b[3]

class ImageData
  constructor: ({@path, @url}) ->
  getSize: ->
    return @_size if @_size?
    fd = fs.openSync @path, "r"
    ext = (_.last @path.split ".").toUpperCase()
    switch ext
      when "PNG"
        # IHDR chunk width / height uint32_t big-endian
        buf = new Buffer 8
        fs.readSync fd, buf, 0, 8, 16
        width = uint32 buf
        height = uint32 buf.slice 4, 8
    
    @_size =
      width: width
      height: height

class ImageDataManager
  constructor: ({@urlPrefix, @pathPrefix}) ->
    @imageDatas = {}

  get: (fileName) ->
    fileUrl = path.join @urlPrefix, fileName
    filePath = path.join @pathPrefix, fileName
    return @imageDatas[filePath] if @imageDatas[filePath]?
    @imageDatas[filePath] = new ImageData
      path: filePath
      url: fileUrl

parse = (obj) ->
  switch typeof obj
    when "string"
      ltr = new nodes.Literal obj
      ltr.filename = ""
      ltr
    when "object"
      _.mapValues obj, parse

module.exports = (paths, globalParam) -> (styl) ->
  
  imageDataMaanager = new ImageDataManager
    urlPrefix: path.relative paths.dest.css, paths.dest.img
    pathPrefix: paths.src.img

  imageUrl = (node) ->
    imageData = imageDataMaanager.get node.val
    new nodes.Literal "url(#{imageData.url})"

  imageSize = (node) ->
    imageData = imageDataMaanager.get node.val
    _.mapValues imageData.getSize(), (d) -> new nodes.Unit d, "px"

  imageWidth = (node) -> (imageSize node).width
  imageHeight = (node) -> (imageSize node).height
  
  styl.define "image-url", imageUrl
  styl.define "image-width", imageWidth
  styl.define "image-height", imageHeight

  _.each globalParam, (val, key) ->
    styl.define key, (parse val), true

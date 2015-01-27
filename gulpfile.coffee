# modules
gulp = require "gulp"
args = (require "yargs").argv
del = require "del"
runSequence = require "run-sequence"
mainBowerFiles = require "main-bower-files"

$ = (require "gulp-load-plugins")()
coffeeify = require "./lib/coffeeify"
guruguru = require "./lib/guruguru"

nib = require "nib"
nsg = require "node-sprite-generator"
stylusUse = require "./lib/stylus-use"

##################################################

GLOBAL_PARAM_PATH = "./global-param"
PC_GLOBAL_PARAM_PATH = "./pc-global-param"

isPc = args.pc?
isDebug = not args.release?

getGlobalParam = ->
  if isPc
    require PC_GLOBAL_PARAM_PATH
  else
    require GLOBAL_PARAM_PATH

getSuffix = ->
  if isPc
    "-pc"
  else
    ""

##################################################

src = args.src or "src"
dest = args.dest or "debug"
unless isDebug
  dest = "release"
dest = "#{dest}#{getSuffix()}"

##################################################

gulp.task "jade", ->
  gulp
    .src "#{src}/jade/index.jade"
    .pipe $.plumber
      errorHandler: (err) -> console.log err.message
    .pipe $.jade
      pretty: true
      data: getGlobalParam()
    .pipe gulp.dest dest
    .pipe $.connect.reload()

gulp.task "stylus", ->
  gulp
    .src "#{src}/stylus/style.styl"
    .pipe $.plumber
      errorHandler: (err) -> console.log err.message
    .pipe $.stylus
      use: [
        nib()
        stylusUse
          globalParam: getGlobalParam()
      ]
      compress: not isDebug
      sourcemap: inline: isDebug if isDebug
    .pipe gulp.dest "#{dest}/css"
    .pipe $.connect.reload()
  
gulp.task "coffeeify", ->
  gulp
    .src "#{src}/coffee/app.coffee"
    .pipe $.if isDebug, $.sourcemaps.init()
    .pipe coffeeify
      extensions: [".coffee", ".json"]
      debug: isDebug
    .pipe $.if not isDebug, $.uglify
      preserveComments: "some"
    .pipe $.if isDebug, $.sourcemaps.write()
    .pipe $.sourcemaps.write()
    .pipe $.rename
      extname: ".js"
    .pipe gulp.dest "#{dest}/js"
    .pipe $.connect.reload()

gulp.task "copy", ->
  gulp
    .src [
      "#{src}/img/**/*.png"
      "#{src}/img/**/*.jpg"
      "#{src}/img/**/*.gif"
      "#{src}/js/**/*.js"
    ],
      base: src
    .pipe gulp.dest dest
    .pipe $.connect.reload()

gulp.task "sprite", ->
  dirname = args.dir
  pixelRatio = if isPc then 1 else 2
  return if not dirname?
  nsg
    src: ["#{src}/img/#{dirname}/*.png"]
    spritePath: "#{src}/img/#{dirname}.png"
    stylesheetPath: "#{src}/stylus/sprite/#{dirname}#{getSuffix()}.styl"
    stylesheetOptions:
      prefix: "#{dirname}-"
      spritePath: "../img/#{dirname}.png"
      pixelRatio: pixelRatio

gulp.task "serve", ->
  $.connect.server
    root: [dest]
    host: "0.0.0.0"
    port: 9000
    livereload: true

gulp.task "test", ->
  gulp
    .src "test/**/*.coffee", read: false
    .pipe $.mocha reporter: "nyan"

gulp.task "guruguru", ->
  rotatingSpeed = args.speed
  guruguru gulp, rotatingSpeed

gulp.task "watch", ["guruguru"], ->
  
  gulp.watch [
    "#{src}/jade/**/*.jade"
    "#{src}/jade/**/*.html"
  ], ["jade"]

  gulp.watch [
    "#{src}/stylus/**/*.styl"
    "#{src}/stylus/**/*.css"
  ], ["stylus"]

  gulp.watch [
    "#{src}/coffee/**/*.coffee"
    "#{src}/coffee/**/*.js"
  ], ["coffeeify"]

  gulp.watch "*global-param.coffee", ->
    runSequence "delete-global-param-cache", [
      "jade"
      "stylus"
      "coffeeify"
    ]

gulp.task "bower-scaffold", ->
  gulp.src mainBowerFiles()
    .pipe $.if not isDebug, $.uglify
      preserveComments: "some"
    .pipe gulp.dest "#{dest}/js/lib"

gulp.task "clean", (callback) -> del dest, callback
  
gulp.task "delete-global-param-cache", ->
  delete require.cache[require.resolve GLOBAL_PARAM_PATH]
  delete require.cache[require.resolve PC_GLOBAL_PARAM_PATH]

gulp.task "build", ->
  runSequence "clean", [
    "jade"
    "stylus"
    "coffeeify"
    "copy"
    "bower-scaffold"
  ]

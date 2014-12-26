# modules
args = (require "yargs").argv
colors = require "colors"
del = require "del"
runSequence = require "run-sequence"

gulp = require "gulp"
jade = require "gulp-jade"
stylus = require "gulp-stylus"
rename = require "gulp-rename"
plumber = require "gulp-plumber"
connect = require "gulp-connect"
uglify = require "gulp-uglify"
sourcemaps = require "gulp-sourcemaps"
mocha = require "gulp-mocha"
gulpIf = require "gulp-if"
coffeeify = require "./lib/coffeeify"
guruguru = require "./lib/guruguru"

nib = require "nib"
nsg = require "node-sprite-generator"
stylusUse = require "./lib/stylus-use"

##################################################

isSp = args.sp?
isDebug = not args.release?

##################################################

src = args.src or "src"
dest = args.dest or "debug"

unless isDebug
  dest = "release"

##################################################


getGlobalParam = ->
  if isSp
    require "./global-param-sp"
  else
    require "./global-param-pc"

##################################################

gulp.task "jade", ->
  gulp
    .src "#{src}/jade/index.jade"
    .pipe plumber
      errorHandler: (err) -> console.log err.message
    .pipe jade
      pretty: true
      data: getGlobalParam()
    .pipe gulp.dest dest
    .pipe connect.reload()

gulp.task "stylus", ->
  gulp
    .src "#{src}/stylus/style.styl"
    .pipe plumber
      errorHandler: (err) -> console.log err.message
    .pipe stylus
      use: [
        nib()
        stylusUse
          globalParam: getGlobalParam()
      ]
      compress: not isDebug
      sourcemap: inline: isDebug if isDebug
    .pipe gulp.dest "#{dest}/css"
    .pipe connect.reload()

gulp.task "coffeeify", ->
  gulp
    .src "#{src}/coffee/app.coffee"
    .pipe gulpIf isDebug, sourcemaps.init()
    .pipe coffeeify
      extensions: [".coffee"]
      debug: isDebug
    .pipe gulpIf !isDebug, uglify
      preserveComments: "all"
    .pipe gulpIf isDebug, sourcemaps.write()
    .pipe sourcemaps.write()
    .pipe rename
      extname: ".js"
    .pipe gulp.dest "#{dest}/js"
    .pipe connect.reload()

gulp.task "copy", ->
  gulp
    .src [
      "#{src}/img/**/*.png"
      "#{src}/img/**/*.jpg"
      "#{src}/img/**/*.gif"
    ],
      base: src
    .pipe gulp.dest dest
    .pipe connect.reload()

gulp.task "sprite", ->
  dirname = args.dir
  spPrefix = if isSp then "-sp" else ""
  pixelRatio = if isSp then 2 else 1
  return if not dirname?
  nsg
    src: ["#{src}/img/#{dirname}/*.png"]
    spritePath: "#{src}/img/#{dirname}.png"
    stylesheetPath: "#{src}/stylus/sprite/#{dirname}#{spPrefix}.styl"
    stylesheetOptions:
      prefix: "#{dirname}-"
      spritePath: "../img/#{dirname}.png"
      pixelRatio: pixelRatio

gulp.task "serve", ->
  connect.server
    root: [__dirname]
    host: "0.0.0.0"
    port: 9000
    livereload: true

gulp.task "test", ->
  gulp
    .src "test/**/*.coffee", read: false
    .pipe mocha reporter: "nyan"

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

  gulp.watch "global-param*.coffee", ["jade", "stylus", "coffeeify"]

gulp.task "clean", -> del dest

gulp.task "build", ->
  runSequence "clean", [
    "jade",
    "stylus",
    "coffeeify",
    "copy",
  ]

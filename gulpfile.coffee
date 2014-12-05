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

isDebug = not args.release?
rotatingSpeed = args.speed
#isHighSpeedMode = args.hsm?
#isNoSpeedMode = args.stop?

src = "src"
dest = if isDebug then "debug" else "release"

gulp.task "jade", ->
  gulp
    .src "#{src}/jade/index.jade"
    .pipe plumber
      errorHandler: (err) -> console.log err.message
    .pipe jade
      pretty: true
      data: require "./global-param"
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
          imageUrlPrefix: "../img"
          imagePathPrefix: "#{src}/img"
          globalParam: require "./global-param"
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
  return if not dirname?
  nsg
    src: ["#{src}/img/#{dirname}/*.png"]
    spritePath: "#{src}/img/#{dirname}.png"
    stylesheetPath: "#{src}/stylus/sprite/#{dirname}.styl"
    stylesheetOptions:
      prefix: dirname + "-"
      spritePath: "../img/#{dirname}.png"

gulp.task "connect", ->
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
  guruguru gulp, rotatingSpeed

gulp.task "watch", ["connect", "guruguru"], ->
  gulp.watch "#{src}/jade/**/*.jade", ["jade"]
  gulp.watch "#{src}/stylus/**/*.styl", ["stylus"]
  gulp.watch "#{src}/coffee/**/*.coffee", ["coffeeify"]
  gulp.watch "global-param.coffee", ["jade", "stylus", "coffeeify"]

gulp.task "clean", -> del dest
gulp.task "default", ->
  runSequence "clean", [
    "jade",
    "stylus",
    "coffeeify",
    "copy",
  ]

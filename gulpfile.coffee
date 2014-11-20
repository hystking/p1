# PARAMS

ROOT =
  default:
    src: "src"
    debug: "debug"
    release: "release"

CONNECT_SETTING =
  root: [__dirname]
  host: "0.0.0.0"
  port: 9000
  livereload: true

PATH =
  jade: "jade"
  stylus: "stylus"
  coffee: "coffee"
  js: "js"
  json: "json"
  img: "img"
  css: "css"
  sound: "sound"
  video: "video"
  swf: "swf"
  html: "."

# utils
path = require "path"
args = (require "yargs").argv
_ = require "lodash"
colors = require "colors"

# gulp
gulp = require "gulp"

# gulp modules
jade = require "gulp-jade"
stylus = require "gulp-stylus"
rename = require "gulp-rename"
mocha = require "gulp-mocha-phantomjs"
plumber = require "gulp-plumber"
connect = require "gulp-connect"
uglify = require "gulp-uglify"
sourcemaps = require "gulp-sourcemaps"
gulpIf = require "gulp-if"
coffeeify = require "./modules/coffeeify"

# other modules for gulp tasks
nib = require "nib"
nsg = require "node-sprite-generator"
stylusUse = require "./modules/stylus-use"
globalParam = require "./global-param"
suddenDeath = require "./modules/sudden-death"

plumberParam =
  errorHandler: (err) ->
    console.log err.message

gulp.task "jade", ->
  gulp
    .src (path.join paths.src.jade, "index.jade"),
      base: paths.src.jade
    .pipe plumber plumberParam
    .pipe jade
      pretty: true
      data: globalParam
    .pipe gulp.dest paths.dest.html
    .pipe connect.reload()

gulp.task "stylus", ->
  param =
    use: [
      nib()
      stylusUse paths, globalParam
    ]
    compress: not isDebug

  if isDebug
    param.sourcemap =
      inline: isDebug

  gulp
    .src (path.join paths.src.stylus, "style.styl"),
      base: paths.src.stylus
    .pipe plumber plumberParam
    .pipe stylus param
    .pipe gulp.dest paths.dest.css
    .pipe connect.reload()

gulp.task "coffeeify", ->
  param =
    extensions: [".coffee"]
    debug: isDebug

  gulp
    .src (path.join paths.src.coffee, "app.coffee"),
      base: paths.src.coffee
    .pipe plumber plumberParam
    .pipe gulpIf isDebug, sourcemaps.init()
    .pipe coffeeify param
    .pipe gulpIf !isDebug, uglify
      preserveComments: "all"
    .pipe gulpIf isDebug, sourcemaps.write()
    .pipe sourcemaps.write()
    .pipe rename
      extname: ".js"
    .pipe gulp.dest paths.dest.js
    .pipe connect.reload()
  
gulp.task "test", ->
  gulp
    .src path.join paths.dest.html, "*.test.html"
    .pipe mocha()

gulp.task "copy-img", ->
  gulp
    .src (
      _.map ["**/*.png", "**/*.jpg", "**/*.jpeg", "**/*.gif"], (x) ->
        path.join paths.src.img, x
    ),
      base: paths.src.img
    .pipe gulp.dest paths.dest.img
    .pipe connect.reload()

gulp.task "copy-js", ->
  gulp
    .src (path.join paths.src.js, "**/*.js"),
      base: paths.src.js
    .pipe gulp.dest paths.dest.js
    .pipe connect.reload()

gulp.task "copy-swf", ->
  gulp
    .src (path.join paths.src.swf, "**/*.swf"),
      base: paths.src.swf
    .pipe gulp.dest paths.dest.swf
    .pipe connect.reload()


gulp.task "copy-json", ->
  gulp
    .src (path.join paths.src.json, "**/*.json"),
      base: paths.src.json
    .pipe gulp.dest paths.dest.json
    .pipe connect.reload()

gulp.task "copy-sound", ->
  gulp
    .src (
      _.map ["**/*.mp3", "**/*.wav", "**/*.org"], (x) ->
        path.join paths.src.sound, x
    ),
      base: paths.src.sound
    .pipe gulp.dest paths.dest.sound
    .pipe connect.reload()

gulp.task "copy-video", ->
  gulp
    .src (_.map ["**/*.mp4"], (x) -> path.join paths.src.video, x),
      base: paths.src.video
    .pipe gulp.dest paths.dest.video

gulp.task "sprite", ->
  dirname = args.dir
  return if not dirname?
  nsg
    src: [path.join paths.src.img, dirname, "*.png"]
    spritePath: path.join paths.src.img, dirname + ".png"
    stylesheetPath: path.join paths.src.stylus, "sprite", dirname + ".styl"
    stylesheetOptions:
      prefix: dirname + "-"
      spritePath: path.join "../img", dirname + ".png"

gulp.task "connect", ->
  param = _.clone CONNECT_SETTING
  connect.server param

gulp.task "guruguru", ->
  return if isNoSpeedMode

  lastTask = ""
  taskStarted = false
  times = 0

  gulp.on "task_start", (e) ->
    taskStarted = true
    stdout = process.stdout
    stdout.cursorTo 0, 0
    lines = process.stdout.getWindowSize()[1]
    for i in [0...lines]
      console.log "\n"
    stdout.cursorTo 0, 6

  gulp.on "task_stop", (e) ->
    lastTask = e.task
    times++
    taskStarted = false
  
  steps = 6
  duration = if isHighSpeedMode then 400 else 1800
  interval = duration / steps | 0

  setInterval =>
    return if taskStarted
    t = Date.now() / duration % 1
    t = 1 - t if times % 2 is 0
    process.stdout.cursorTo 0, 0
    suddenDeath lastTask, t
  , interval

gulp.task "watch", ["connect", "guruguru"], ->
  gulp.watch (path.join paths.src.jade, "**/*.jade"), ["jade"]
  gulp.watch (path.join paths.src.stylus, "**/*.styl"), ["stylus"]
  gulp.watch (path.join paths.src.coffee, "**/*.coffee"), ["coffeeify"]
  gulp.watch (path.join paths.src.json, "**/*.json"), ["copy-json"]

gulp.task "default", [
  "jade",
  "stylus",
  "coffeeify",
  "copy-img",
  "copy-js",
  "copy-json",
  "copy-sound",
  "copy-swf",
  "copy-video",
]

getPaths = (src_root, dest_root) ->
  src: _.mapValues PATH, (val) ->
    path.join src_root, val
  dest: _.mapValues PATH, (val) ->
    path.join dest_root, val

# MAIN #
isDebug = not args.release?
isHighSpeedMode = args.hs?
isNoSpeedMode = args.ns?

root = ROOT.default

src = root.src

if isDebug
  dest = root.debug
else
  dest = root.release

paths = getPaths src, dest


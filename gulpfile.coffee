# -----------DEPENDENCIES-----------

gulp		= require "gulp"
gutil		= require "gulp-util"
$			= require("gulp-load-plugins")()

express		= require "express"
open		= require "open"
path		= require "path"
lr			= require("tiny-lr")()

# --------------CONFIG--------------

Config =
	port: 9999
	livereloadport: 35729
	src: "./src"
	dist: "./"
	demo: "./demo"


gulp.task "jade", ->
	gulp.src Config.src + "/jade/index.jade"
		.pipe $.plumber()
		.pipe $.jade
			pretty: false
		.pipe gulp.dest Config.demo

gulp.task "stylus", ->
	gulp.src Config.src + "/stylus/panel.styl"
		.pipe $.plumber()
		.pipe $.stylus()
		.pipe $.autoprefixer "last 1 version", "> 1%", "ie 8", "ie 7"
		.pipe $.header "/* " + new Date() + " */\n"
		.pipe gulp.dest Config.demo

	# setTimeout ->
	# 	gulp.src "component.json"
	# 		.pipe $.component.styles
	# 			configure: (builder) ->
	# 		.pipe gulp.dest Config.demo
	# , 1000

gulp.task "coffeescript", ->
	gulp.src Config.src + "/coffee/demo.coffee"
		.pipe $.plumber()
		.pipe $.coffee()
		.pipe $.browserify
			transform: ["coffeeify"]
			extensions: [".coffee"]
		.pipe $.header "/* " + new Date() + " */\n"
		.pipe gulp.dest Config.demo

	# setTimeout ->
	# 	gulp.src "component.json"
	# 		.pipe $.component.scripts
	# 			standalone: false
	# 		.pipe gulp.dest Config.demo
	# , 1000

gulp.task "server", ->
	app = express()
	app.use require("connect-livereload")()
	app.use express.static(Config.demo)
	app.listen Config.port
	lr.listen Config.livereloadport
	gutil.log gutil.colors.yellow("Server listening on port " + Config.port)
	gutil.log gutil.colors.yellow("Livereload listening on port " + Config.livereloadport)

	setTimeout ->
		open("http://localhost:" + Config.port)
	, 1500

gulp.task "watch", ->

	gulp.watch Config.src + "/jade/**/*.jade", ["jade"]
	gulp.watch Config.src + "/stylus/**/*.styl", ["stylus"]
	gulp.watch Config.src + "/coffee/**/*.coffee", ["coffeescript", "test"]
	gulp.watch Config.src + "/test/spec.coffee", ["test"]

	gulp.watch Config.demo + "/*.{html,css,js}", notifyLivereload

notifyLivereload = (event) ->

	fileName = "/" + path.relative Config.dist, event.path
	gulp.src event.path, read: false
		.pipe require("gulp-livereload")(lr)
	gutil.log gutil.colors.yellow("Reloading " + fileName)

gulp.task "test", ->
	gulp.src "./test/spec.coffee"
		.pipe $.jasmine()

gulp.task "default", ["jade", "stylus", "coffeescript", "server", "watch"]

gulp.task "build", ->

	gulp.src Config.src + "/stylus/panel.styl"
		.pipe $.plumber()
		.pipe $.stylus()
		.pipe $.autoprefixer "last 1 version", "> 1%", "ie 8", "ie 7"
		.pipe gulp.dest Config.dist

	gulp.src Config.src + "/coffee/index.coffee"
		.pipe $.plumber()
		.pipe $.coffee()
		.pipe gulp.dest Config.dist
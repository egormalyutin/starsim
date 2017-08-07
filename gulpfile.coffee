gulp 	= require 'gulp'
concat 	= require 'gulp-concat'
zip		= require 'gulp-vinyl-zip'
del		= require 'del'
seq		= require 'run-sequence'
chmod	= require 'chmod'
execf	= require('child_process').exec
luamin	= require 'gulp-luaminify'
replace = require 'gulp-replace'
log 	= console.log

gulp.task 'dist:lua', () ->
	gulp
		.src 'app/**/*.lua'

		.pipe replace /dev_enable\(\)[\s\S]*?dev_disable\(\)/gi, (match) ->
			log "Development block removed:"
			log match
			return ""

		.pipe luamin()

		.pipe gulp.dest 'dist'

gulp.task 'copy:buildfiles', () ->
	gulp
		.src 'buildfiles/**/*'

		.pipe gulp.dest 'build'

gulp.task 'clean:build', () ->
	del 'build'

gulp.task 'pack:love', () ->
	gulp
		.src 'app/**/*'

		.pipe zip.dest 'build/game.love'


###

gulp.task 'build:example', () ->
	gulp
		.src [ 'build/example', 'build/game.love' ]

		.pipe concat 'example'

		.pipe gulp.dest 'build'

###

gulp.task 'build:linux32', () ->
	gulp.src(['build/linux32', 'build/game.love']).pipe(concat( 'linux32' )).pipe(gulp.dest 'build')

gulp.task 'build:linux62', () ->
	gulp.src(['build/linux64', 'build/game.love']).pipe(concat( 'linux64' )).pipe(gulp.dest 'build')

gulp.task 'build:win32', () ->
	gulp.src(['build/win32', 'build/game.love']).pipe(concat( 'win32' )).pipe(gulp.dest 'build')

gulp.task 'build:win64', () ->
	gulp.src(['build/win64', 'build/game.love']).pipe(concat( 'win64' )).pipe(gulp.dest 'build')

gulp.task 'build', () ->
	seq ['dist:lua', 'clean:build'], 'copy:buildfiles', 'pack:love', [ 'build:linux32', 'build:linux64', 'build:win32', 'build:win64', ], 'script'

gulp.task 'script', () ->
	execf './build.sh'

gulp.task 'default', [ 'build' ]

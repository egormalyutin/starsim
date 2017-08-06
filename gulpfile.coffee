gulp 	= require 'gulp'
concat 	= require 'gulp-concat'
zip		= require 'gulp-vinyl-zip'
del		= require 'del'
seq		= require 'run-sequence'
chmod	= require 'chmod'
execf	= require('child_process').exec
luamin	= require 'gulp-luaminify'
replace = require 'gulp-replace'

gulp.task 'dist:lua', () ->
	gulp
		.src 'app/**/*.lua'

		.pipe replace /dev_enable\(\)[\s\S]*dev_disable\(\)/gi, (match) ->
			return ""

		.pipe gulp.dest "test"

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

gulp.task 'build:linux32', () ->
	gulp
		.src [ 'build/linux32', 'build/game.love' ]

		.pipe concat 'linux32'

		.pipe gulp.dest 'build'

gulp.task 'build:linux64', () ->
	gulp
		.src [ 'build/linux64', 'build/game.love' ]

		.pipe concat 'linux64'

		.pipe gulp.dest 'build'

gulp.task 'build:win32', () ->
	gulp
		.src [ 'build/win32/game.exe', 'build/game.love' ]

		.pipe concat 'game.exe'

		.pipe gulp.dest 'build/win32'

gulp.task 'build:win64', () ->
	gulp
		.src [ 'build/win64/game.exe', 'build/game.love' ]

		.pipe concat 'game.exe'

		.pipe gulp.dest 'build/win64'

gulp.task 'build', () ->
	seq 'clean:build', 'copy:buildfiles', 'pack:love', [ 'build:linux32', 'build:linux64', 'build:win32', 'build:win64', ], 'script'

gulp.task 'script', () ->
	execf './build.sh'

gulp.task 'default', [ 'build' ]

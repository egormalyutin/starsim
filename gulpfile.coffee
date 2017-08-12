gulp 	= require 'gulp'
seq		= require 'run-sequence'

cache	= require 'gulp-cache'
concat 	= require 'gulp-concat'
chmod	= require 'gulp-chmod'
image	= require 'gulp-imagemin'
del		= require 'del'
luamin	= require 'gulp-luaminify'
replace = require 'gulp-replace'
zip		= require 'gulp-vinyl-zip'

execf	= require('child_process').exec

log 	= console.log

###########################
# DIST
###########################

gulp.task 'dist:lua', () ->
	gulp
		.src 'dist/**/*.lua'

		.pipe replace /dev_enable\(\)[\s\S]*?dev_disable\(\)/gi, (match) ->
			log "Development block removed:"
			log match
			return ""

		.pipe luamin()

		.pipe gulp.dest 'dist'

gulp.task 'dist:images', () ->
	gulp
		.src 'dist/**/*.+(png|jpg|jpeg|gif|svg)'

		.pipe cache image interplaced: true

		.pipe gulp.dest 'dist'
		
gulp.task 'dist:vendor', () ->
	del "dist/**/*.moon"

###########################
# COPY
###########################

gulp.task 'copy:buildfiles', () ->
	gulp.src 'buildfiles/**/*'
		.pipe gulp.dest 'build'

gulp.task 'copy:dist', () ->
	gulp.src 'app/**/*'
		.pipe gulp.dest 'dist'

###########################
# CLEAN
###########################

gulp.task 'clean:build', () ->
	del 'build'

gulp.task 'clean:dist', () ->
	del 'dist'

###########################
# PACKAGE:LOVE
###########################

gulp.task 'package:love', () ->
	gulp.src 'dist/**/*'
		.pipe zip.dest 'build/game.love'

###########################
# EXE
###########################

gulp.task 'exe:linux32', () ->
	gulp.src ['build/linux32', 'build/game.love']
		.pipe concat 'linux32'
		.pipe chmod 0o755
		.pipe gulp.dest 'build'

gulp.task 'exe:linux64', () ->
	gulp.src ['build/linux64', 'build/game.love']
		.pipe concat 'linux64'
		.pipe chmod 0o755
		.pipe gulp.dest 'build'

gulp.task 'exe:win32', () ->
	gulp.src ['build/win32/game.exe', 'build/game.love']
		.pipe concat 'game.exe'
		.pipe chmod 0o755
		.pipe gulp.dest 'build/win32'

gulp.task 'exe:win64', () ->
	gulp.src ['build/win64/game.exe', 'build/game.love']
		.pipe concat 'game.exe'
		.pipe chmod 0x755
		.pipe gulp.dest 'build/win64'

gulp.task 'exe', ['exe:linux32', 'exe:linux64', 'exe:win32', 'exe:win64']

###########################
# BUILD
###########################

gulp.task 'build', () ->
	seq(
		[ 'clean:build', 'clean:dist' ]
		[ 'copy:buildfiles', 'copy:dist' ]
		[ 'dist:lua', 'dist:images' ]
		'dist:vendor'
		'package:love'
		'exe'
	)

gulp.task 'default', [ 'build' ]
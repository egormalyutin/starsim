gulp 	= require 'gulp'
util    = require 'gulp-util'
seq		= require 'run-sequence'

cache	= require 'gulp-cache'
concat 	= require 'gulp-concat'
chmod	= require 'gulp-chmod'
image	= require 'gulp-imagemin'
del		= require 'del'
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
			util.log "Development block removed:"
			util.log match
			return ""

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
		.pipe zip.dest 'build/love/star-simulator.love'

###########################
# EXE
###########################

gulp.task 'exe:linux32', () ->
	gulp.src ['build/linux32/star-simulator', 'build/love/star-simulator.love']
		.pipe concat 'star-simulator'
		.pipe chmod 0o755
		.pipe gulp.dest 'build/linux32'

gulp.task 'exe:linux64', () ->
	gulp.src ['build/linux64/star-simulator', 'build/love/star-simulator.love']
		.pipe concat 'star-simulator'
		.pipe chmod 0o755
		.pipe gulp.dest 'build/linux64'

gulp.task 'exe:win32', () ->
	gulp.src ['build/win32/star-simulator.exe', 'build/love/star-simulator.love']
		.pipe concat 'star-simulator.exe'
		.pipe chmod 0o755
		.pipe gulp.dest 'build/win32'

gulp.task 'exe:win64', () ->
	gulp.src ['build/win64/star-simulator.exe', 'build/love/star-simulator.love']
		.pipe concat 'star-simulator.exe'
		.pipe chmod 0o755
		.pipe gulp.dest 'build/win64'

gulp.task 'exe', ['exe:linux32', 'exe:linux64', 'exe:win32', 'exe:win64']

###########################
# ZIP
###########################

gulp.task 'zip:linux32', () ->
	gulp.src ['build/linux32/**/*']
		.pipe zip.dest 'build/linux32.zip'

gulp.task 'zip:linux64', () ->
	gulp.src ['build/linux64/**/*']
		.pipe zip.dest 'build/linux64.zip'

gulp.task 'zip:win32', () ->
	gulp.src ['build/win32/**/*']
		.pipe zip.dest 'build/win32.zip'

gulp.task 'zip:win64', () ->
	gulp.src ['build/win64/**/*']
		.pipe zip.dest 'build/win64.zip'

gulp.task 'zip', ['zip:linux32', 'zip:linux64', 'zip:win32', 'zip:win64']

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
		'zip'
	)

gulp.task 'default', [ 'build' ]
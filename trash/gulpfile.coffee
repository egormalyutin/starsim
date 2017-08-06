gulp 	= require 'gulp'
concat 	= require 'gulp-concat'

gulp.task 'build', () ->
	gulp
		.src [ '/usr/bin/love', 'main.love' ]

		.pipe concat 'exe'

		.pipe gulp.dest './'
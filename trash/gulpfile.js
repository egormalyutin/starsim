// Generated by CoffeeScript 1.12.5
var concat, gulp;

gulp = require('gulp');

concat = require('gulp-concat');

gulp.task('build', function() {
  return gulp.src(['/usr/bin/love', 'main.love']).pipe(concat('exe')).pipe(gulp.dest('./'));
});

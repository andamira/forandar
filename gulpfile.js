var gulp   = require("gulp");
var dart   = require("gulp-dart");
var uglify = require("gulp-uglify");

gulp.task("default", function() {
	return gulp.src('src/*.dart')
	.pipe(dart({
		"dest": "dist",
		"minify": "true"
	}))
	.pipe(uglify())
	.pipe(gulp.dest('./'))
});

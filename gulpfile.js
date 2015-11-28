var gulp   = require("gulp");
var dart   = require("gulp-dart");
var uglify = require("gulp-uglify");
var gzip   = require("gulp-gzip");

gulp.task("default", function() {
	return gulp.src('web/main.dart')
	.pipe(dart({
		"dest": "dist",
		"minify": "true",
	}))
	.pipe(uglify())
	.pipe(gzip({ extension: 'gz', gzipOptions: { level: 9 } }))
	.pipe(gulp.dest('./'))
});

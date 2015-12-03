var gulp   = require("gulp");
var dart   = require("gulp-dart");
var uglify = require("gulp-uglify");
var rename = require("gulp-rename");

gulp.task("compile", function() {
	return gulp.src('web/main.dart')
	.pipe(dart({
		"dest": "dist",
		"minify": "true",
		"suppress-warnings": "true",
		"terse": "true",
		"no-source-maps": "true",
	}))
	.pipe(uglify())
	.pipe(rename('forandar.min.js'))
	.pipe(gulp.dest('./dist'))
});

gulp.task( 'default',
	[ 'compile' ]
);


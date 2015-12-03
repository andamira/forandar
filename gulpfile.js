var gulp   = require("gulp");
var dart   = require("gulp-dart");
var uglify = require("gulp-uglify");
var rename = require("gulp-rename");

gulp.task("dev", function() {
	return gulp.src('web/main.dart')
	.pipe(dart({
		"dest": "dist",
		"suppress-warnings": "true",
		"terse": "true",
		"no-source-maps": "true",
	}))
	.pipe(rename('forandar.js'))
	.pipe(gulp.dest('./dist'))
	.pipe(gulp.dest('html'))
});

gulp.task("prod", function() {
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
	.pipe(gulp.dest('html'))
});

gulp.task( 'default',
	[ 'dev' ]
);


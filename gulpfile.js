// Dependencies

var gulp   = require("gulp");
var dart   = require("gulp-dart");
var uglify = require("gulp-uglify");
var rename = require("gulp-rename");
var del    = require("del");

var exec = require('child_process').exec;


// Tasks for Compiling

gulp.task("compile-dev", function(cb) {
	return gulp.src('web/forandar.dart')
	.pipe(dart({
		"dest": "web",
		"checked": "true",
		"suppress-warnings": "true",
		"terse": "true",
	}))
	.pipe(rename('forandar.dart.js'))
	.pipe(gulp.dest('web'))
});

gulp.task("compile-prod", function(cb) {
	return gulp.src('web/forandar.dart')
	.pipe(dart({
		"dest": "web",
		"minify": "true",
		"suppress-warnings": "true",
		"terse": "true",
		"no-source-maps": "true",
	}))
	.pipe(uglify())
	.pipe(rename('forandar.dart.js'))
	.pipe(gulp.dest('web'))
});


// Tasks for Debugging

gulp.task('analyzer', function (cb) {
  exec('dartanalyzer lib/*.dart', function (err, stdout, stderr) {
    console.log(stdout);
    console.log(stderr);
    cb(err);
  });
})


// Misc Tasks

gulp.task('prune', ['compile-prod'], function(cb) {
    del([
        'web/forandar.dart.js.*'
    ], cb)
});

gulp.task('clean', function(cb) {
    del([
        'web/forandar.dart.js*'
    ], cb)
});


// Final (Development | Production) Tasks

gulp.task( 'dev',
	[ 'compile-dev' ]
);

gulp.task( 'prod',
	[ 'compile-prod', 'prune' ]
);


// Default Task

gulp.task( 'default',
	[ 'dev' ]
);


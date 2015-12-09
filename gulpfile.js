// Dependencies

var gulp   = require("gulp");
var dart   = require("gulp-dart");
var rename = require("gulp-rename");
var uglify = require("gulp-uglify");
var gutil  = require("gulp-util");
var del    = require("del");

var exec = require('child_process').exec;

// Help Task
gulp.task("help", function(cb) {
	gutil.log(gutil.colors.blue.bgBlack('+----Task-----------------Description---------------------------'));
	gutil.log(gutil.colors.blue.bgBlack('|'));

	gutil.log(gutil.colors.blue.bgBlack('|'), 'dev', '\t', gutil.colors.blue('compile js for development (sourcemaps)'));
	gutil.log(gutil.colors.blue.bgBlack('|'), '\t\t', gutil.colors.cyan('similar to `dart2js -c --terse --suppress-warnings \\'));
	gutil.log(gutil.colors.blue.bgBlack('|'), '\t\t', gutil.colors.cyan('-o web/forandar.dart.js web/forandar.dart`'));
	gutil.log(gutil.colors.blue.bgBlack('|'));
	gutil.log(gutil.colors.blue.bgBlack('|'), 'prod', '\t', gutil.colors.blue('compile js production (uglify)'));
	gutil.log(gutil.colors.blue.bgBlack('|'), '\t\t', gutil.colors.cyan('similar to `dart2js -c --terse --suppress-warnings \\'));
	gutil.log(gutil.colors.blue.bgBlack('|'), '\t\t', gutil.colors.cyan('-m --no-source-maps -o web/forandar.dart.js web/forandar.dart`'));
	gutil.log(gutil.colors.blue.bgBlack('|'));
	gutil.log(gutil.colors.blue.bgBlack('|'), 'clean', '\t', gutil.colors.blue('delete all js output'));
	gutil.log(gutil.colors.blue.bgBlack('|'), '\t\t', gutil.colors.cyan('alias for `rm web/forandar.dart.js*'));

	gutil.log(gutil.colors.blue.bgBlack('|'));

	gutil.log(gutil.colors.blue.bgBlack('|'), 'test', '\t', gutil.colors.blue('Run tests'));
	gutil.log(gutil.colors.blue.bgBlack('|'), '\t\t', gutil.colors.cyan('alias for `pub run test`'));
	gutil.log(gutil.colors.blue.bgBlack('|'));
	gutil.log(gutil.colors.blue.bgBlack('|'), 'debug', '\t', gutil.colors.blue('Debug library'));
	gutil.log(gutil.colors.blue.bgBlack('|'), '\t\t', gutil.colors.cyan('alias for `dartanalyzer lib/*.dart`'));
	gutil.log(gutil.colors.blue.bgBlack('|'));
	gutil.log(gutil.colors.blue.bgBlack('|'), 'speed', '\t', gutil.colors.blue('Speed benchmark'));
	gutil.log(gutil.colors.blue.bgBlack('|'), '\t\t', gutil.colors.cyan('alias for `dart benchmark/*.dart`'));

	gutil.log(gutil.colors.blue.bgBlack('|'));
	gutil.log(gutil.colors.blue.bgBlack('+---------------------------------------------------------------'));
});


// JavaScript related Tasks
// ------------------------

// Compiles to js for development.
gulp.task("js-dev", function(cb) {
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

// Compiles to js for production.
gulp.task("js-prod", function(cb) {
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

// Cleans unneeded dart2js output for production
gulp.task('prune', ['js-prod'], function(cb) {
    del([
        'web/forandar.dart.js.*'
    ], cb)
});

// Cleans all dart2js output, including the js file
gulp.task('clean', function(cb) {
    del([
        'web/forandar.dart.js*'
    ], cb)
});


// Debug Tasks
// -----------

// Run dartanalyzer over the library code
gulp.task('debug', function (cb) {
  exec('dartanalyzer lib/*.dart', function (err, stdout, stderr) {
    console.log(stdout);
    console.log(stderr);
    cb(err);
  });
})

// Run tests
gulp.task('test', function (cb) {
  exec('pub run test', function (err, stdout, stderr) {
    console.log(stdout);
    console.log(stderr);
    cb(err);
  });
});
// Benchmark
gulp.task('speed', function (cb) {
  exec('dart benchmark/*.dart', function (err, stdout, stderr) {
    console.log(stdout);
    console.log(stderr);
    cb(err);
  });
});


// Main (Development | Production) Tasks
// -------------------------------------

gulp.task( 'dev',
	[ 'js-dev' ]
);
gulp.task( 'prod',
	[ 'js-prod', 'prune' ]
);

// Default Task
gulp.task( 'default',
	[ 'help' ]
);


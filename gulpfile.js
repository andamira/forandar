// Dependencies

var gulp   = require("gulp");
var dart   = require("gulp-dart");
var rename = require("gulp-rename");
var uglify = require("gulp-uglify");
var gutil  = require("gulp-util");
var shell  = require("gulp-shell");
var del    = require("del");

var exec = require('child_process').exec;

// Help Task
gulp.task("help", function(cb) {
	gutil.log(gutil.colors.blue.bgBlack('+----Task-----------------Description---------------------------'));
	gutil.log(gutil.colors.blue.bgBlack('|'));
	gutil.log(gutil.colors.blue.bgBlack('|'), 'build', '\t\t', gutil.colors.blue('build release version in build/ directory'));
	gutil.log(gutil.colors.blue.bgBlack('|'), '\t\t\t', gutil.colors.cyan('alias for `gulp clean; pub build'));
	gutil.log(gutil.colors.blue.bgBlack('|'), 'build-debug', '\t', gutil.colors.blue('build debug version (includes .dart files)'));
	gutil.log(gutil.colors.blue.bgBlack('|'), '\t\t\t', gutil.colors.cyan('alias for `gulp clean; pub build --mode=debug'));
	gutil.log(gutil.colors.blue.bgBlack('|'));
	gutil.log(gutil.colors.blue.bgBlack('|'), 'js-dev', '\t', gutil.colors.blue('compile js for development in web/ directory'));
	gutil.log(gutil.colors.blue.bgBlack('|'), '\t\t', gutil.colors.cyan('similar to `dart2js -c --terse --suppress-warnings \\'));
	gutil.log(gutil.colors.blue.bgBlack('|'), '\t\t', gutil.colors.cyan('-o web/forandar.dart.js web/forandar.dart`'));
	gutil.log(gutil.colors.blue.bgBlack('|'), 'js-prod', '\t', gutil.colors.blue('compile js for production (uglify)'));
	gutil.log(gutil.colors.blue.bgBlack('|'), '\t\t', gutil.colors.cyan('similar to `dart2js -c --terse --suppress-warnings \\'));
	gutil.log(gutil.colors.blue.bgBlack('|'), '\t\t', gutil.colors.cyan('-m --no-source-maps -o web/forandar.dart.js web/forandar.dart`'));
	gutil.log(gutil.colors.blue.bgBlack('|'));
	gutil.log(gutil.colors.blue.bgBlack('|'), 'clean', '\t', gutil.colors.blue('delete all js output'));
	gutil.log(gutil.colors.blue.bgBlack('|'), '\t\t', gutil.colors.cyan('alias for `rm web/forandar.dart.js* build/web/'));
	gutil.log(gutil.colors.blue.bgBlack('|'));
	gutil.log(gutil.colors.blue.bgBlack('|'), 'test', '\t', gutil.colors.blue('Run tests'));
	gutil.log(gutil.colors.blue.bgBlack('|'), '\t\t', gutil.colors.cyan('alias for `pub run test`'));
	gutil.log(gutil.colors.blue.bgBlack('|'), 'debug', '\t', gutil.colors.blue('Debug library'));
	gutil.log(gutil.colors.blue.bgBlack('|'), '\t\t', gutil.colors.cyan('alias for `dartanalyzer lib/*.dart`'));
	gutil.log(gutil.colors.blue.bgBlack('|'), 'speed', '\t', gutil.colors.blue('Speed benchmark'));
	gutil.log(gutil.colors.blue.bgBlack('|'), '\t\t', gutil.colors.cyan('alias for `dart benchmark/*.dart`'));
	gutil.log(gutil.colors.blue.bgBlack('|'), 'cloc', '\t', gutil.colors.blue('Count lines of code'));
	gutil.log(gutil.colors.blue.bgBlack('|'), '\t\t', gutil.colors.cyan('alias for `cloc --exclude-dir=node_modules,build --exclude-ext=dart.js .`'));
	gutil.log(gutil.colors.blue.bgBlack('|'));
	gutil.log(gutil.colors.blue.bgBlack('+---------------------------------------------------------------'));
});


// JavaScript related Tasks
// ------------------------
//
// Alternative: https://www.dartlang.org/tools/pub/dart2js-transformer.html

// Compiles to js for development.
gulp.task("compile-js-dev", function(cb) {
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
gulp.task("compile-js-prod", function(cb) {
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
gulp.task('prune', ['compile-js-prod'], function(cb) {
	del(['web/forandar.dart.js.*'], cb)
});

// Cleans all dart2js output, including the js file
gulp.task('clean', function(cb) {
	del(['web/forandar.dart.js*'], cb)
	del(['build/web/'], cb)
});

// Builds the Web interface, minifying js with dart2js, without .dart sources
gulp.task('pub-build', shell.task([
	'pub build'
]));

// Builds the Web interface, without minification, with .dart sources
gulp.task('pub-build-debug', shell.task([
	'pub build --mode=debug'
]));

// Debug Tasks
// -----------

// Run dartanalyzer over the library code
gulp.task('debug', shell.task([
	'dartanalyzer lib/*.dart'
]));

// Run tests.
gulp.task('test', shell.task([
	'pub run test'
]));

// Benchmark.
gulp.task('speed', shell.task([
	'dart benchmark/*.dart'
]));

// Count Lines Of Code.
//
// Depends on: https://github.com/AlDanial/cloc
gulp.task('cloc', shell.task([
	'cloc --exclude-dir=node_modules,build --exclude-ext=dart.js .'
]));


// Main (Development | Production) Tasks
// -------------------------------------

// Build for development
gulp.task( 'build', ['clean', 'pub-build']);

// Build for production
gulp.task( 'build-debug', ['clean', 'pub-build-debug']);

// Compile JS for development
gulp.task( 'js-dev', [ 'compile-js-dev' ]);

// Compile JS for production
gulp.task( 'js-prod', [ 'compile-js-prod', 'prune' ]);

// Default Task
gulp.task( 'default', [ 'help' ]);


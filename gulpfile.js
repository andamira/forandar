// Dependencies

var gulp     = require("gulp");
var dart     = require("gulp-dart");
var rename   = require("gulp-rename");
var replace  = require("gulp-replace");
var uglify   = require("gulp-uglify");
var gutil    = require("gulp-util");
var sequence = require("run-sequence");
var shell    = require("gulp-shell");
var del      = require("del");
var fs       = require('fs');
var yaml     = require('js-yaml');

var exec = require('child_process').exec;


// Data
forandarVersion = yaml.safeLoad(fs.readFileSync('pubspec.yaml', 'utf8')).version;


// Help Task
gulp.task("help", function(cb) {
	gutil.log(gutil.colors.blue.bgBlack('+----Task-----------------Description---------------------------'));
	gutil.log(gutil.colors.blue.bgBlack('|'));
	gutil.log(gutil.colors.blue.bgBlack('|'), 'build', '\t\t', gutil.colors.blue('build release version in build/ directory'));
	gutil.log(gutil.colors.blue.bgBlack('|'), '\t\t\t', gutil.colors.cyan('alias for `gulp clean; pub build; gulp update-build-bver'));
	gutil.log(gutil.colors.blue.bgBlack('|'), 'build-debug', '\t', gutil.colors.blue('build debug version (includes .dart files)'));
	gutil.log(gutil.colors.blue.bgBlack('|'), '\t\t\t', gutil.colors.cyan('alias for `gulp clean; pub build --mode=debug; gulp update-bver'));
	gutil.log(gutil.colors.blue.bgBlack('|'));
	gutil.log(gutil.colors.blue.bgBlack('|'), 'js-dev', '\t', gutil.colors.blue('compile JS unminified with sourcemaps in web/ directory'));
	gutil.log(gutil.colors.blue.bgBlack('|'), '\t\t', gutil.colors.cyan('similar to `dart2js -c --terse --suppress-warnings \\'));
	gutil.log(gutil.colors.blue.bgBlack('|'), '\t\t', gutil.colors.cyan('-o web/forandar.dart.js web/forandar.dart && gulp update-jver`'));
	gutil.log(gutil.colors.blue.bgBlack('|'), 'js-prod', '\t', gutil.colors.blue('compile JS minified and uglified in web/ directory'));
	gutil.log(gutil.colors.blue.bgBlack('|'), '\t\t', gutil.colors.cyan('similar to `dart2js -c --terse --suppress-warnings -m \\'));
	gutil.log(gutil.colors.blue.bgBlack('|'), '\t\t', gutil.colors.cyan('--no-source-maps -o web/forandar.dart.js web/forandar.dart && gulp update-jver`'));
	gutil.log(gutil.colors.blue.bgBlack('|'));
	gutil.log(gutil.colors.blue.bgBlack('|'), 'clean', '\t', gutil.colors.blue('delete all JS and build output'));
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

// Compiles to JS for development.
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

// Compiles to JS for production.
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
gulp.task('prune', function() {
	del(['web/forandar.dart.js.*'])
});

// Cleans all dart2js output, including the JS output file
gulp.task('clean', function() {
	del(['web/forandar.dart.js*'])
	del(['build/web/'])
});

// Builds the Web interface, minifying js with dart2js, without .dart sources
gulp.task('pub-build', shell.task([
	'pub build'
]));

// Builds the Web interface, without minification, with .dart sources
gulp.task('pub-build-debug', shell.task([
	'pub build --mode=debug'
]));

// Updates the version in the JS build/ output
gulp.task('update-bver', function() {
	gulp.src('build/web/forandar.dart.js', {base: './'})
	.pipe(replace('FORANDAR_VERSION', forandarVersion))
	.pipe(gulp.dest('./'))
});

// Updates the version in the JS web/ output
gulp.task('update-jver', function() {
	gulp.src('web/forandar.dart.js', {base: './'})
	.pipe(replace('FORANDAR_VERSION', forandarVersion))
	.pipe(gulp.dest('./'))
});


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
gulp.task( 'build', function(cb) {
	sequence( 'clean', 'pub-build', 'update-bver', cb );
});

// Build for production
gulp.task( 'build-debug', function(cb) {
	sequence( 'clean', 'pub-build-debug', 'update-bver', cb );
});

// Compile JS for development
gulp.task( 'js-dev', function(cb) {
	sequence( 'compile-js-dev', 'update-jver', cb);
});

// Compile JS for production
gulp.task( 'js-prod', function(cb) {
	sequence( 'compile-js-prod', 'prune', 'update-jver', cb );
});

// Default Task
gulp.task( 'default', [ 'help' ]);


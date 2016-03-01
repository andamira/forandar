#!/bin/bash

# Fast fail the script on failures.
set -e

ALL_TESTS="test/all_tests.dart test/debug/all_tests.dart"

# Verify that the libraries are error and warning-free.
echo "Running dartanalyzer..."
dartanalyzer $DARTANALYZER_FLAGS bin/forandar.dart bin/forandar_debug.dart web/main.dart $ALL_TESTS | grep -v "^\[info\]"

# Run the tests.
echo "Running tests..."
pub run test $ALL_TESTS

# Gather and send coverage data.
if [ "$COVERALLS_TOKEN" ] && [ "$TRAVIS_DART_VERSION" = "stable" ]; then
	echo "Collecting coverage..."
	pub global activate dart_coveralls
	pub global run dart_coveralls report \
		--token $COVERALLS_TOKEN \
		--retry 2 \
		--exclude-test-files \
		--debug \
		test/all_tests.dart

		# NOTE: Currently is not possible to merge reports from different sources
		#
		#     test/debug/all_tests.dart
		#
		# Issues:
		#
		#     https://github.com/duse-io/dart-coveralls/issues/49
		#     https://github.com/duse-io/dart-coveralls/issues/50
		#
fi

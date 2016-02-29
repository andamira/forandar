#!/bin/bash

# Fast fail the script on failures.
set -e

# Verify that the libraries are error and warning-free.
echo "Running dartanalyzer..."
dartanalyzer $DARTANALYZER_FLAGS bin/forandar.dart bin/forandar_exception.dart web/main.dart test/all_tests.dart test/exception/all_tests.dart | grep -v "^\[info\]"

# Run the tests.
echo "Running tests..."
pub run test test/all_tests.dart test/exception/all_tests.dart

# Gather and send coverage data.
if [ "$COVERALLS_TOKEN" ] && [ "$TRAVIS_DART_VERSION" = "stable" ]; then
	echo "Collecting coverage..."
	pub global activate dart_coveralls
	pub global run dart_coveralls report \
		--token $COVERALLS_TOKEN \
		--retry 2 \
		--exclude-test-files \
		test/all_tests.dart
fi

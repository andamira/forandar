#!/bin/bash
#
# This must be executed from the root of the project:
# 
#     ./tool/test.sh
#
# NOTE: Not using `pub run test` because it doesn't work yet
# without a packages/ directories: 
#
#     https://github.com/dart-lang/test/issues/327
#

dart -c ./test/all_tests.dart &&
	dart -c ./test/debug/all_tests.dart


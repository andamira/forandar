#!/bin/bash
#
# This script must be executed from the root of the project:
# 
#     ./tool/analyzer.sh
#

set -e

dartanalyzer \
	lib/forandar.dart \
	lib/debug/forandar.dart \
	bin/forandar.dart \
	bin/forandar_debug.dart \
	web/main.dart \
	test/all_tests.dart \
	test/debug/all_tests.dart \
	| { grep -v "^\[info\]" || true; }

exit ${PIPESTATUS[0]}

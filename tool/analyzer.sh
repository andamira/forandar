#!/bin/bash
#
# This must be executed from the root of the project:
# 
#     ./tool/analyzer.sh
#

dartanalyzer bin/forandar.dart bin/forandar_debug.dart web/main.dart test/all_tests.dart test/debug/all_tests.dart | grep -v "^\[info\]"


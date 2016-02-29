#!/bin/bash
#
# This must be executed from the root of the project:
# 
#     ./tool/analyzer.sh
#

dartanalyzer bin/forandar.dart bin/forandar_exception.dart web/main.dart test/all_tests.dart test/exception/all_tests.dart | grep -v "^\[info\]"


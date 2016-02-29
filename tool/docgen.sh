#!/bin/bash
#
# This must be executed from the root of the project:
# 
#     ./tool/docgen.sh
#

mv README.md README.md.bkp
cp doc/README.md README.md

dartdoc --include forandar,forandar_cli,forandar_web

mv README.md.bkp README.md

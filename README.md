# <img src="https://raw.githubusercontent.com/andamira/forandar/master/web/img/logo-55x120.png" valign="bottom">  forandar

A Forth implementation in Dart.

![Version pre-alpha](https://img.shields.io/badge/version-pre--alpha-C70300.svg)
[![Build Status](https://travis-ci.org/andamira/forandar.svg?branch=master)](https://travis-ci.org/andamira/forandar)
[![Coverage Status](https://coveralls.io/repos/github/andamira/forandar/badge.svg?branch=master)](https://coveralls.io/github/andamira/forandar?branch=master)

## Information

### Features and WIP

- :globe_with_meridians: An interface-independant library.
- :new_moon: Includes a Command Line Interface.
- :earth_asia: Includes a Web Interface. :soon:
- :o: [Forth Standard](http://forth-standard.org/) compliant. :soon:
- :ideograph_advantage: Supports UTF-8.

### Future Goals

- Manipulate the Canvas.
- Manipulate the DOM.
- Interface with JavaScript.

### Current Status

- CLI interface is functional.
- The text interpreter works.
- Many essential Forth primitives still needs to be implemented.

## Instructions

### Installation

1. Install the appropriate version of [Dart](https://www.dartlang.org/downloads/) for your system.
2. Install the Dart project dependencies with `pub get`.

**To install the full build-chain:**

* Get: [npm](https://docs.npmjs.com/getting-started/installing-node) & [Gulp](https://github.com/gulpjs/gulp/blob/master/docs/getting-started.md) as the build tool.
* Install the Gulp dependencies with `npm install`.
* To see the build-chain help screen type: `gulp`.

### Command Line Interface

* To see the help screen type: `pub run forandar --help`

**Example**

* To *e*valuate Forth source code from a string: `pub run forandar -e "2 3 + ."`

### Web Interface

... :soon:


# forandar

A Forth implementation in Dart.

![Version pre-alpha](https://img.shields.io/badge/version-pre--alpha-C70300.svg)
[![Join the chat room](https://img.shields.io/badge/open-chat_room-0081C6.svg)](https://gitter.im/andamira/forandar)

## Information

### Features

- Runs both in the terminal and in the browser.
- Includes one core interface-independent Dart library (`forandar:forandar`), and two libraries depending on the interface (`forandar:cli` & `forandar:web`).

### Goals

- To fully support the [Forth 2012 Standard](http://forth-standard.org/).
- To interface with the Dart APIs to manipulate the Canvas, the DOM and third party JS libraries.

### Status

- Pre-Alpha. CLI interface is functional. The interpreter works, but still many essential Forth primitives needs to be defined.

## Instructions

### Installation

* First you need to install [Dart](https://www.dartlang.org/downloads/).
* Then install the Dart dependencies with `pub get`.
* Optionally, but recommended, install [npm](https://docs.npmjs.com/getting-started/installing-node) & [Gulp](https://github.com/gulpjs/gulp/blob/master/docs/getting-started.md) as the build tool.
* Then install the Gulp dependencies with `npm install`.
* To see the build tool help screen, run: `gulp`.

### Running from the Terminal (Command Line Interface)

* To see the help screen: `pub run forandar -h`
* To run the interactive console: `pub run forandar`
* To *e*valuate Forth source code from a string: `pub run forandar -e "1 1 + ."`
* To *i*nclude Forth source code from a file: `pub run forandar -i ./src/code.fs`

    _Note: You can combine multiple evaluations and inclusions and they'll be interpreted in the specified order._

### Running in the Browser (Web Interface)

. . .


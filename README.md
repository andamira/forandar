# <img src="https://raw.githubusercontent.com/andamira/forandar/master/web/img/logo-55x120.png" valign="bottom">  forandar

A Forth system implemented in Dart.

![Version pre-alpha](https://img.shields.io/badge/version-pre--alpha-C70300.svg)
[![Build Status](https://travis-ci.org/andamira/forandar.svg?branch=master)](https://travis-ci.org/andamira/forandar)
[![Coverage Status](https://coveralls.io/repos/github/andamira/forandar/badge.svg?branch=master)](https://coveralls.io/github/andamira/forandar?branch=master)

## Information

### Features and WIP

- :globe_with_meridians: An interface-independent library.
- :new_moon: Includes a Command Line Interface.
- :earth_asia: Includes a Web Interface. :soon:
- :o: [Forth Standard](http://forth-standard.org/) compliant. :soon:
- :ideograph_advantage: Supports UTF-8.

### Future Goals

- Manipulate the Canvas.
- Manipulate the DOM.
- Interface with JavaScript.

### Current Status

- The interactive interpreter from the CLI interface is pretty functional.
- Already implemented are almost all the words for: text interpreting, manipulating the stacks, mathematical operations (floats included), storing and fetching to the data space, and programming tools.
- Still many essential Forth primitives are not implemented yet, like for: defining words, saving and manipulating strings and control structures.

---

## Instructions

### Installation

You'll first need to install the appropriate version of [Dart](https://www.dartlang.org/downloads/) for your system. And then you could either:

1. **Simply activate the package.**

	*This is the quickest way of installing and running a snapshot of the forandar CLI.*

	```
	pub global activate --sgit https://github.com/andamira/forandar.git
	```

	To update the package, just run the same command again.

2. **Clone the project.**

	*Useful for tinkering with the sourcecode and also trying out the web interface.*

	```
	git clone https://github.com/andamira/forandar
	cd forandar
	pub get
	```

	Then you can activate the `forandar` command for global execution like this:

	```
	pub global activate --source path ./
	```

### Command Line Interface

**Usage Examples**

* To enter the interpretation console: `forandar`
* To see the help screen: `forandar -h`
* To evaluate Forth source code from a string, and exit: `forandar -e "2 3 + . bye"`
* To include Forth source code from a file: `forandar -i "path/to/forth-source.fs"`
* You can evaluate strings and include files in any number and combination:

	```
	forandar -e "1 2 swap .s" -i forth-source.fs -e "1e 2.7e 3e / .fs"`
	```

### Web Interface

Once you have cloned this project, there are several ways to try the web interface. For example:

1. Run `pub serve` from the project directory and then visit `http://localhost:8080`. You can either use the [Dartium](https://www.dartlang.org/tools/dartium/) browser (useful while developing) or a normal web browser (in which case you'll have to wait for the javascript transpilation to finish).
2. Build the web interface with `pub build` and open the file `./build/web/index.html` with any browser. You could also deploy the `build/web/` directory to a production server.

**Usage Examples**

*This interface is not functional yet.*


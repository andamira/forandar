# <img src="https://raw.githubusercontent.com/andamira/forandar/master/web/img/logo-55x120.png" valign="bottom">  forandar

A Forth implementation in Dart.

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

- CLI interface is functional.
- The text interpreter works.
- Many essential Forth primitives still needs to be implemented.

---

## Instructions

### Installation

You'll first need to install the appropriate version of [Dart](https://www.dartlang.org/downloads/) for your system. And then you could either:

1. **Clone the project.**

	*Useful for tinkering with the sourcecode and trying out the web interface.*

	```
	git clone https://github.com/andamira/forandar
	cd forandar
	pub get
	pub run forandar
	```

	You can activate the `forandar` command for global execution from anywhere in your system:

	```
	pub global activate --source path ./
	```

2. **Activate the package.**

	*This is the quickest way of installing the command line interface.*

	```
	pub global activate --source git path https://github.com/andamira/forandar.git
	```

*Read more about [pub global](https://www.dartlang.org/tools/pub/cmd/pub-global.html).*

---

### Command Line Interface

**Usage Examples**

* To enter the interpretation console: `forandar`
* To see the help screen: `forandar --help`
* To **E**valuate Forth source code from a string, and exit: `forandar -e "2 3 + . bye"`
* To **I**nclude Forth source code from a file: `forandar -i "path/to/forth-source.fs"`
* To evaluate and include, in any combination: `forandar -e "1 2 swap .s" -i forth-source.fs -e "1e 2.7e 3e / .fs"` 

More examples in the wiki. :soon:

---

### Web Interface

Once you have cloned this project, there are several ways to try the web interface. For example:

1. Run `pub serve` from the project directory and then visit `http://localhost:8080`. You can use for that either the [Dartium](https://www.dartlang.org/tools/dartium/) browser (useful for developers) or a normal web browser (in which case you'll have to wait for the javascript transpilation to finish).
2. Build the web interface with `pub build` and open the file `./build/web/index.html` with any browser. You could also deploy the `build/web/` directory to a production server.

**Usage Examples**

* ... :soon:


**Live Demo**

* ... :soon:

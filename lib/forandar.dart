/// Core functionality of the Forth Virtual Machine.
library forandar;

import 'dart:collection';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'src/util.dart' as util;

part 'src/core/errors.dart';
part 'src/core/dict/dictionary.dart';
part 'src/core/dict/nt_enum.dart';
part 'src/core/dict/primitives.dart';
part 'src/core/input.dart';
part 'src/core/space/data.dart';
part 'src/core/space/object.dart';
part 'src/core/stack.dart';
part 'src/core/vm.dart';

/// The version of this library.
///
/// This placeholder must be filled by the implementation.
String forandarVersion = 'FORANDAR_VERSION';

/// The global options.
///
/// The default options can be overriden later,
/// by providing new values either in the JavaScript context,
/// in the case of web apps, or with command line parameters.
class Configuration {

	// The Map that stores the options.
	Map<String, dynamic> option = new Map();

	// Initializes with the default values.
	Configuration () {
		option['dataStackSize']    = 256; // in cells
		option['floatStackSize']   = 128;
		option['returnStackSize']  = 32;
		option['controlStackSize'] = 32;

		option['dataSpaceSize']    = 1024 * 1024; // in bytes (1M)
	}
}

void main() {}


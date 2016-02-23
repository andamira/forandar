library forandar;

import 'dart:collection';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

part 'core/data_space.dart';
part 'core/dictionary.dart';
part 'core/enums.dart';
part 'core/errors.dart';
part 'core/input.dart';
part 'core/object_space.dart';
part 'core/stack.dart';
part 'core/vm.dart';
part 'core/words.dart';
part 'util.dart';

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


library forandar;

import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:typed_data';

part 'core/dictionary.dart';
part 'core/errors.dart';
part 'core/stack.dart';
part 'core/vm.dart';

part 'core/words.dart';

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
		option['dataStackSize']    = 256;
		option['returnStackSize']  = 32;
		option['controlStackSize'] = 32;

		option['dataSpaceSize']    = 16384;
	}
}

void main() {}


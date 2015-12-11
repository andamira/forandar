library forandar;

//import 'dart:async';
import 'dart:collection';
//import 'dart:convert';
import 'dart:typed_data';

part 'core/dictionary.dart';
part 'core/stack.dart';
part 'core/vm.dart';

/// The version of this library.
String forandarVersion = '0.2.13';

/// The default [Configuration] object.
Configuration config = new Configuration();

/// The default [SourceQueue] object.
InputQueue input = new InputQueue();

/// The global options.
///
/// The default options can be overriden later,
/// by providing new values either in the javascript context,
/// in the case of web apps, or with command line parameters.
class Configuration {

	// The Map that stores the options.
	Map<String, dynamic> option = new Map();

	// Initializes with the default values.
	Configuration () {
		option['dataStackSize']    = 256;
		option['returnStackSize']  = 32;
		option['controlStackSize'] = 32;

		option['dataSpaceSize']    = 1024;
		option['codeSpaceSize']    = 1024;
	}
}

/// Supported types of input
enum InputType { String, File, Url }

/// The global source code inputs queue.
///
/// Stores in order the series of source codes for interpreting,
/// either as a string, or as a file / URL to be loaded.
class InputQueue {

	/// Storage for the source code inputs, in order.
	List<Map<InputType, String>> queue = [ ];

	add(ResourceFrom t, String s) {
		this.queue.add({t: s});
	}
}

void main() {}


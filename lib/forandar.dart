library forandar;

//import 'dart:async';
import 'dart:collection';
//import 'dart:convert';
import 'dart:typed_data';

part 'core/dictionary.dart';
part 'core/stack.dart';
part 'core/vm.dart';

String forandarVersion = '0.2.10';

/// The global options.
///
/// The default options can be overriden later,
/// by providing new values either in the javascript context,
/// in the case of web apps, or with command line parameters.
class Configuration {

	Map<String, dynamic> option = new Map();

	Configuration () {
		option['dataStackSize']    = 256;
		option['returnStackSize']  = 32;
		option['controlStackSize'] = 32;

		option['dataSpaceSize']    = 1024;
		option['codeSpaceSize']    = 1024;
	}
}

void main() {}


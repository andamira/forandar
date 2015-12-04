library forandar;

import 'dart:collection';
import 'dart:convert' show JSON;
import 'dart:html';
import 'dart:js' show context, JsObject;
import 'dart:typed_data';

part 'parts/dictionary.dart';
part 'parts/stack.dart';
part 'parts/temp_tests.dart';
part 'parts/vm.dart';

/// The global options.
///
/// This default values can be overriden later,
/// by values provided in the javascript context.
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

/// The main function
void main() {

	/// Initializes the configuration.
	///
	/// Overrides any configuration specified in the javascript context.
	Configuration config = loadConfiguration();

	/// Creates the Forth [VirtualMachine]
	VirtualMachine forth = new VirtualMachine(config);

	/// Runs the temporary tests
	TempTests test = new TempTests(forth);
	test.TestStack(forth.dataStack, "forth.dataStack");
	test.TestDictionary(forth.dict, "forth.dict");
}


/// Defines and loads the global options.
///
/// Overrides the default values with the fetched data.
loadConfiguration() {

	/// Create the default [Configuration] object
	Configuration c = new Configuration();

	if (context.hasProperty('forandar')) {

		/// Overrides the properties specified in
		c.option.forEach((key, value) {

			var newValue = context['forandar']['config'][key];

			// If it's valid and different from the default
			if (newValue != null && newValue != value) {
				window.console.info("Override config.option['$key'] $value > $newValue");
				c.option[key] = newValue;
			}
		});

		// Fetches a single Forth source code (TODO)
		// var source = context(['forandar']['source']);
	}

	return c;
}



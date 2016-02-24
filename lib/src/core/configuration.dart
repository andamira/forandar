library forandar.core.configuration;

/// The global options.
///
/// The default options can be overriden later,
/// by providing new values either in the JavaScript context,
/// in the case of web apps, or with command line parameters.
class Configuration {

	// The Map that stores the options.
	Map<String, dynamic> option = new Map();

	// Singleton constructor, allowing only one instance.
	factory Configuration() {
		_instance ??= new Configuration._internal();
		return _instance;
	}
	static Configuration _instance;

	/// Creates the configuration object with the default values.
	Configuration._internal() {
		option['dataStackSize']    = 256; // in cells
		option['floatStackSize']   = 128;
		option['returnStackSize']  = 32;
		option['controlStackSize'] = 32;

		option['dataSpaceSize']    = 1024 * 1024; // in bytes (1M)
	}
}


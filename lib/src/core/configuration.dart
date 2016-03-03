library forandar.core.configuration;

/// The global options.
///
/// The default options can be overriden later,
/// by providing new values either in the JavaScript context,
/// in the case of web apps, or with command line parameters.
class Configuration {

	static const defaultDataStackSize    = 256;
	static const defaultFloatStackSize   = 128;
	static const defaultReturnStackSize  = 32;
	static const defaultControlStackSize = 32;
	static const defaultDataSpaceSize    = 1024 * 1024; // in bytes

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
		option['dataStackSize']    = defaultDataStackSize;
		option['floatStackSize']   = defaultFloatStackSize;
		option['returnStackSize']  = defaultReturnStackSize;
		option['controlStackSize'] = defaultControlStackSize;

		option['dataSpaceSize']    = defaultDataSpaceSize;
	}
}


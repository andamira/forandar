library forandar.core.configuration;

// Core
import 'package:forandar/src/core/globals.dart';
import 'package:forandar/src/core/errors.dart';

/// Configuration option value wrapper class.
///
/// - Allows the values to be passed by reference.
/// - Performs type checking and fixing.
class ConfigOption {
	var _value;

	ConfigOption(this._value);

	/// Gets the value.
	get value => _value;

	/// Sets the value.
	///
	/// Performs type checking and conversion from: String to: int and double.
	/// An exception will be thrown if the type of the old value doesn't match the type of the new value.
	set value(dynamic newValue) {

		// Value type conversion.
		if (newValue is String) {

			if (_value is int) {
				newValue = int.parse(newValue);
			}
			else if (_value is double) {
				newValue = double.parse(newValue);
			}
		}

		// Value type check.
		if (newValue.runtimeType == _value.runtimeType) {
			_value = newValue;
		} else {
			print(ForthError.unmanaged('Can\'t replace configuration value "$_value" (of type ${_value.runtimeType}) with "$newValue" (of type ${newValue.runtimeType})'));
		}
	}
}

/// The configuration object.
///
/// The default options can be overriden later,
/// by providing new values either in the JavaScript context,
/// in the case of web apps, or with command line parameters.
class Configuration {

	// Private map structure to save the options.
	final Map<String, ConfigOption> _options = new Map();

	// Default values
	//
	// VirtualMachine
	static const int defaultDataStackSize    = 256;
	static const int defaultFloatStackSize   = 128;
	static const int defaultReturnStackSize  = 32;
	static const int defaultControlStackSize = 32;
	static const int defaultDataSpaceSize    = 1024 * 1024; // in bytes
	// Terminal
	static const TerminalType defaultTerminalType = TerminalType.auto;
	static const int defaultTerminalHistoryLines = 128;

	/// Creates the configuration object with the default values.
	Configuration() {
		// VirtualMachine
		_options['dataStackSize']    = new ConfigOption(defaultDataStackSize);
		_options['floatStackSize']   = new ConfigOption(defaultFloatStackSize);
		_options['returnStackSize']  = new ConfigOption(defaultReturnStackSize);
		_options['controlStackSize'] = new ConfigOption(defaultControlStackSize);
		_options['dataSpaceSize']    = new ConfigOption(defaultDataSpaceSize);
		// Terminal
		_options['terminalType']         = new ConfigOption(defaultTerminalType);
		_options['terminalHistoryLines'] = new ConfigOption(defaultTerminalHistoryLines);
	}

	/// Returns the value of an option.
	dynamic getOption(String key) => optionObject(key).value;

	/// Changes the value of an option.
	void setOption(String key, dynamic value) => optionObject(key).value = value;

	/// Returns an iterable of the keys.
	Iterable<String> get keys => _options.keys;

	/// Returns a reference to the [ConfigOption] option.
	ConfigOption optionObject(String key) {
		if (_options.containsKey(key))
			return _options[key];
		else {
			throw 'Configuration option "$key" doesn\'t exist.';
		}
	}
}

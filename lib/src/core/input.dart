library forandar.core.input;

// Core
import 'package:forandar/src/core/globals.dart';

class InputQueueElement {
	InputType type;
	String str;

	InputQueueElement(InputType t, String s) {
		type = t;
		str = s;
	}
}

/// Base class for implementing a source code input queue.
///
/// Stores in order the series of source codes for interpreting,
/// either as a code string, or as a file / URL to be loaded.
class InputQueueBase {

	/// Storage for the source code input references, in original order.
	List<InputQueueElement> queue = [ ];

	/// The identification of the input source.
	///
	/// This is the value returned by SOURCE-ID.
	int id = 0;

	/// The number of characters in the input buffer.
	///
	/// This is the length value returned by SOURCE.
	int length = 0;

	/// Returns true if the input source is set to the interactive terminal.
	bool fromTerm() => id == 0 ? true : false;

	/// Returns true if the input source is set to a string for EVALUATE .
	bool fromEval() => id == -1 ? true : false;

	/// Returns true if the input source is set to a file id.
	bool fromFile() => id > 0 ? true : false;

	/// Adds a new source to the [queue].
	void add(InputType t, String s) {
		queue.add(new InputQueueElement(t, s));
	}

	/// Clears the [queue].
	void clear() {
		queue = [ ];
	}

	// Methods dependent on the specific interface:

	loadFile(String f) {}
	loadUrl(String u) {}
	readLineFromTerminal() {}
}

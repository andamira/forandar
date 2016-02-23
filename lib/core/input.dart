part of forandar;

/// The size for the input buffer.
///
/// Enough for one line.
const int inputBufferSize = 512;

/// The size for the PAD region.
const int padSize = inputBufferSize;

/// Supported types of input.
enum InputType { String, File, Url }

class InputQueueElement {
	InputType type;
	String str;

	InputQueueElement(InputType t, String s) {
		type = t;
		str = s;
	}
}

/// The global source code (input) queue.
///
/// Stores in order the series of source codes for interpreting,
/// either as a string, or as a file / URL to be loaded.
class InputQueue {

	/// Reference to the parent forth virtual machine.
	VirtualMachine vm;

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

	loadFile(String f) {}
	loadUrl(String u) {}
	readLineFromTerminal() {}
}

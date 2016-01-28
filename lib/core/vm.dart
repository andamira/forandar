part of forandar;

// Library Constants.

/// The size of a cell in bytes.
const int cellSize = 4;

// Addresses.

/// Address for storing the base conversion radix in the data space.
const int addrBASE = 0;

/// Address for storing the compilation-state flag.
///
/// It is true (!=flagFALSE) when in compilation state.
const int addrSTATE = addrBASE + cellSize;

// Flags.

const int flagTRUE = -1;
const int flagFALSE = 0;


/// The Forth Virtual Machine.
///
/// Contains the dictionary, stacks, data and object spaces, input queued...
class VirtualMachine {

	// Dictionary.
	Dictionary dict;

	// Stacks.
	LifoStackInt dataStack;
	LifoStackInt returnStack;
	LifoStackInt controlStack;
	LifoStackFloat floatStack;

	// Data Spaces.
	DataSpace dataSpace;
	ObjectSpace objectSpace;

	// Input Queue.
	InputQueue input;

	/// Constructs the [VirtualMachine].
	VirtualMachine (Configuration config, InputQueue input) {

		/// Creates the Stacks.
		dataStack    = new LifoStackInt(config.option['dataStackSize']);
		returnStack  = new LifoStackInt(config.option['returnStackSize']);
		controlStack = new LifoStackInt(config.option['controlStackSize']);
		floatStack   = new LifoStackFloat(config.option['floatStackSize']);

		/// Creates the main data space.
		dataSpace = new DataSpace(config.option['dataSpaceSize']);
		/// Creates the code data space for storing the instructions for non-primitive words.
		objectSpace = new ObjectSpace();

		/// Creates the source code input queue.
		this.input = input;

		/// Creates the [Dictionary] containing the [Word]s.
		dict = new Dictionary(this);

		initDataSpace();
	}

	/// Initializes the default data in [dataSpace].
	void initDataSpace() {

		/// Reserves space: 2 cells.
		dataSpace.pointer += cellSize * 2;

		/// Sets a default decimal BASE (radix).
		dataSpace.storeCell(addrBASE, 10);

		/// Sets the default STATE to interpretation-mode.
		dataSpace.storeCell(addrSTATE, flagFALSE);
	}

	/// Returns [true] when in compilation-mode.
	///
	/// And [false] in interpretation-mode.
	/// The true value in STATE is non-zero.
	/// http://forth-standard.org/standard/core/STATE
	bool get inCompileMode {
		if (dataSpace.fetchCell(addrSTATE) == flagFALSE ) {
			return false;
		} else {
			return true;
		}
	}
}

/// TODO http://stackoverflow.com/questions/28026648/how-to-improve-dart-performance-of-data-conversion-to-from-binary
// https://api.dartlang.org/stable/dart-typed_data/ByteData-class.html
// https://en.wikipedia.org/wiki/Two%27s_complement
class DataSpace {
	ByteData data;
	final int maxSize;
	int pointer = 0;

	DataSpace(this.maxSize) {
		data = new ByteData(maxSize);
	}

	int fetchChar(int address) => data.getInt8(address);

	int fetchCell(int address) => data.getInt32(address);

	double fetchFloat(int address) => data.getFloat64(address);

	/// Stores an integer using 1 byte at the specified address.
	void storeChar(int address, int value) => data.setInt8(address, value);

	/// Stores an integer using 1 byte at the current pointer position, and increments it.
	void storeCharHere(int value) => data.setInt8(pointer++, value);

	/// Stores an integer using 4 bytes at the specified address.
	void storeCell(int address, int value) => data.setInt32(address, value);

	/// Stores an integer using 4 bytes at the current pointer position, and increments it.
	void storeCellHere(int value) => data.setInt32(pointer += cellSize, value);

	/// Stores a float using 8 bytes at the specified address.
	void storeFloat(int address, double value) => data.setFloat64(address, value);

	/// Stores a float using 8 bytes at the current pointer position, and increments it.
	void storeFloatHere(double value) => data.setFloat64(pointer += cellSize * 2, value);
}

/// 
class ObjectSpace {
	List<Object> data = [];
	int pointer = 0;
}

/// Supported types of input.
enum InputType { String, File, Url }

class InputQueueElement {
	InputType type;
	String str;

	InputQueueElement(InputType t, String s) {
		type = t;
		str = s;

		// print("InputQueueElement($t, «$s»)"); // TEMP
	}
}

/// The global source code inputs queue.
///
/// Stores in order the series of source codes for interpreting,
/// either as a string, or as a file / URL to be loaded.
class InputQueue {

	/// Storage for the source code inputs references, in order.
	List<InputQueueElement> queue = [ ];

	/// All the source codes concatenated.
	String sourceCode = "";

	/// Position marker in the [sourceCode].
	int index = 0;

	// Constants
	static const int SPACE = 0x20;

	/// Adds a new input to the [queue].
	void add(InputType t, String s) {
		queue.add(new InputQueueElement(t, s));
	}

	/// Clears the [queue].
	void clear() {
		queue = [ ];
		sourceCode = "";
		index = 0;
	}

	/// Loads some URL.
	///
	/// This function is redefined in the Web library.
	/// TODO: in CLI too.
	Future<String> loadUrl();

	/// Loads some file.
	///
	/// This function is redefined in the CLI library.
	Future<String> loadFile();

	/// 
	Future loadSourceCode() async {

		for (var x in queue) {

			switch (x.type) {
				case InputType.String:
					sourceCode += "\n" + x.str;
					break;
				case InputType.File:
					/*
					String fileSrc = await loadFile(x.str);
					sourceCode += fileSrc;
					*/
					sourceCode += " " + await loadFile(x.str);
					//print("fileSrc: $fileSrc sourceCode: $sourceCode");
					break;
				case InputType.Url:
					sourceCode += "\n" + await loadUrl(x.str);
					break;
			}
		}

		//print("sourceCode: «$sourceCode»"); //TEMP
	}

	/// Returns the next word as a string.
	///
	/// The word is first converted to uppercase.
	String nextWord() {

		while (index < sourceCode.length) {

			var letter = nextLetter(index);
			if (letter == null) break;

			index = nextSpace(letter);
			if (index == null) index = sourceCode.length;

			var wordStr = sourceCode.substring(letter, index);

			if (wordStr == "") {
				index = 0;
			} else {
				return wordStr;
			}
		}
	}

	/// Returns the index for the next letter, from [i].
	int nextLetter(int i) {
		for (i; i < sourceCode.length; i++) {

			int codeUnit = sourceCode.codeUnitAt(i);

			if (!_isWhitespace(codeUnit)) {
				return i;
			}
		}
	}

	/// Returns the index for the next whitespace, from [i].
	int nextSpace(int i) {
		for (i; i < sourceCode.length; i++) {

			int codeUnit = sourceCode.codeUnitAt(i);

			if (_isWhitespace(codeUnit)) {
				return i;
			}
		}
	}

	/// TODO: Returns the index for the next newline, from [i].
	//
	// [Dart semantics depends on newline encoding][https://github.com/dart-lang/sdk/issues/23888]
	// http://stackoverflow.com/a/1331840/940200
	int nextNewLine(int i) {
		// RegExp exp = new RegExp("\r\n?|\n";);
	}

	/// Returns true when [codeUnit] is whitespace (for Forth).
	///
	/// White space parsing does not have to treat code points greater than $20 as white space.
	/// http://forth-standard.org/standard/xchar
	static bool _isWhitespace(int codeUnit) {
		switch (codeUnit) {
			case 0x09: // <control-0009>..<control-000D>
			case 0x0A: //
			case 0x0B: //
			case 0x0C: //
			case 0x0D: //
			case 0x20: // SPACE
		//	case 0x85: // <control-0085>
		//	case 0xA0: // NO-BREAK SPACE
				return true;
			default:
				return false;
		}
	}

}


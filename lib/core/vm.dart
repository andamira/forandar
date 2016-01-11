part of forandar;

// Global Constants.

// Address for storing the base conversion radix in the data space.
const addrBASE = 0;


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

	// Data Space.
	DataSpace dataSpace;
	ObjectSpace objectSpace;

	// Input Queue.
	InputQueue input;

	// Compile Mode
	bool inCompileMode = false;

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

		/// Sets a default decimal BASE (radix).
		dict.wordsMap['DECIMAL'].exec();
	}
}


/// 
///
/// TODO http://stackoverflow.com/questions/28026648/how-to-improve-dart-performance-of-data-conversion-to-from-binary
class DataSpace {
	ByteData data;
	final int maxSize;
	int size = 0;

	DataSpace(this.maxSize) {
		data = new ByteData(maxSize);
	}
}

/// 
class ObjectSpace {
	List<Object> data = [];
}

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

/// The global source code inputs queue.
///
/// Stores in order the series of source codes for interpreting,
/// either as a string, or as a file / URL to be loaded.
class InputQueue {

	/// Storage for the source code inputs, in order.
	List<InputQueueElement> queue = [ ];

	/// Storage for the source code lines.
	List<String> sourceCodeLines = [ ];

	/// Position markers for the current interpretation.
	int currentLine = 0;
	int currentLineIndex = 0;

	/// Adds a new input to the [queue].
	void add(InputType t, String s) {
		queue.add(new InputQueueElement(t, s));
	}

	/// Clears the [queue].
	void clear() {
		queue = [ ];
		sourceCodeLines = [ ];
		currentLine = 0;
		currentLineIndex = 0;
	}

	/// Loads some URL.
	///
	/// This function is replaced in the Web library.
	Future<String> loadUrl();

	/// Loads some file.
	///
	/// This function is replaced in the CLI library.
	Future<String> loadFile();

	/// 
	Future fillSourceCodeLines() async {

		for (var x in queue) {

			String sourceCode = ""; 

			switch (x.type) {
				case InputType.String:
					sourceCode = x.str;
					break;
				case InputType.File:
					sourceCode = await loadFile(x.str);
					break;
				case InputType.Url:
					sourceCode = await loadUrl(x.str);
					break;
			}

			sourceCodeLines = new List.from(sourceCodeLines)
				..addAll(const LineSplitter().convert(sourceCode));
		}

		//print(sourceCodeLines); // TEMP
		//print(sourceCodeLines.length); // TEMP
	}


	/// Returns the next word as a string.
	///
	/// The word is first converted to uppercase.
	String nextWord() {

		while (currentLine < sourceCodeLines.length) {

			// Index of the next letter.
			var letter = nextLetter(currentLine, currentLineIndex);

			// Index of the next space.
			currentLineIndex = nextSpace(currentLine, letter);
			var wordStr = sourceCodeLines[currentLine].substring(letter, currentLineIndex);

			if (wordStr == "") {
				currentLine++;
				currentLineIndex = 0;
			} else {
				return wordStr;
			}
		}

	}

	/// Returns the next letter (not whitespace).
	int nextLetter(int line, int index) {

		while (index < sourceCodeLines[line].length) {

			int codeUnit = sourceCodeLines[line].codeUnitAt(index);

			// SPACE = 0x20;
			if (codeUnit != 0x20 && !_isWhitespace(codeUnit)) {
				break;
			}
			index++;
		}
		return index;
	}

	int nextSpace(int line, int index) {

		while (index < sourceCodeLines[line].length) {

			int codeUnit = sourceCodeLines[line].codeUnitAt(index);

			// SPACE = 0x20;
			if (codeUnit == 0x20 && _isWhitespace(codeUnit)) {
				break;
			}
			index++;
		}
		return index;
	}

	/// Returns true when [codeUnit] is whitespace
	//
	// This function has been extracted from the String class in Dart source code.
	//
	// Characters with Whitespace property (Unicode 6.2).
	// 0009..000D		; White_Space # Cc			 <control-0009>..<control-000D>
	// 0020					; White_Space # Zs			 SPACE
	// 0085					; White_Space # Cc			 <control-0085>
	// 00A0					; White_Space # Zs			 NO-BREAK SPACE
	// 1680					; White_Space # Zs			 OGHAM SPACE MARK
	// 180E					; White_Space # Zs			 MONGOLIAN VOWEL SEPARATOR
	// 2000..200A		; White_Space # Zs			 EN QUAD..HAIR SPACE
	// 2028					; White_Space # Zl			 LINE SEPARATOR
	// 2029					; White_Space # Zp			 PARAGRAPH SEPARATOR
	// 202F					; White_Space # Zs			 NARROW NO-BREAK SPACE
	// 205F					; White_Space # Zs			 MEDIUM MATHEMATICAL SPACE
	// 3000					; White_Space # Zs			 IDEOGRAPHIC SPACE
	//
	// BOM: 0xFEFF
	static bool _isWhitespace(int codeUnit) {
		// Most codeUnits should be less than 256. Special case with a smaller
		// switch.
		if (codeUnit < 256) {
			switch (codeUnit) {
				case 0x09:
				case 0x0A:
				case 0x0B:
				case 0x0C:
				case 0x0D:
				case 0x20:
				case 0x85:
				case 0xA0:
					return true;
				default:
					return false;
			}
		}
		switch (codeUnit) {
			case 0x1680:
			case 0x180E:
			case 0x2000:
			case 0x2001:
			case 0x2002:
			case 0x2003:
			case 0x2004:
			case 0x2005:
			case 0x2006:
			case 0x2007:
			case 0x2008:
			case 0x2009:
			case 0x200A:
			case 0x2028:
			case 0x2029:
			case 0x202F:
			case 0x205F:
			case 0x3000:
			case 0xFEFF:
				return true;
			default:
				return false;
		}
	}

}


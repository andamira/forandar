part of forandar;

/// The size for the input buffer.
///
/// Enough for one line.
const int inputBufferSize = 255;

/// The size for the PAD region;
const int padSize = 255;

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

	/// All the source code inputs concatenated. TODO FIXME
	String sourceCode = "";

	/// Position marker in the [sourceCode]. TODO FIXME
	int index = 0;

	/// Where SOURCE-ID value is stored.
	int id = 0;

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
		sourceCode = "";
		index = 0;
	}

	/// Loads some URL.
	///
	/// TODO: This function is redefined in the CLI & Web libraries.
	Future<String> loadUrl();

	/// Loads some file.
	///
	/// This function is redefined in the CLI library.
	Future<String> loadFile();

	/// Reads a string from the terminal input and saves it to the input buffer.
	///
	/// This function is redefined in the CLI & Web libraries.
	readLineFromTerminal();

	/// TODO FIXME
	Future loadSourceCode() async {

		for (var x in queue) {

			switch (x.type) {
				case InputType.String:
					sourceCode += "\n" + x.str;
					break;
				case InputType.File:
					sourceCode += "\n" + await loadFile(x.str);
					//print("fileSrc: $fileSrc sourceCode: $sourceCode"); //TEMP
					break;
				case InputType.Url:
					sourceCode += "\n" + await loadUrl(x.str);
					break;
			}
		}
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

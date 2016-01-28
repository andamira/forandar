part of forandar;

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

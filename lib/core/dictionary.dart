part of forandar;

/// A Forth definition.
class Word {

	/// The word name as it is used by Forth.
	///
	/// All uppercase. This is its key in [wordsMap].
	String name;

	/// An index pointer to this word in [wordsList].
	int st;

	/// A flag that indicates if the word is immediate.
	bool isImmediate;

	/// A flag that indicates if the word is restricted.
	bool isCompileOnly;

	/// A flag that indicates if the compilation has completed.
	bool hasCompleted;

	/// The execution code for this word.
	final Function exec;

	// TODO: pointer to dataSpace and/or codeSpace.

	Word(this.isImmediate, this.isCompileOnly, this.exec, [this.name, this.st]);
}

/// A searchable collection for all defined [Word]s.
///
/// Defines the primitives and contains both primitives and : words.
class Dictionary {

	/// List of [Word]s retrievable by the word's name.
	Map<String, Word> wordsMap = new SplayTreeMap();

	/// List of [Word]s retrievable by index.
	List<Word> wordsList = [ ];

	/// Constants for the flags of the [Word].
	static const immediate      = true;
	static const compileOnly    = true;

	/// Creates the dictionary and adds the primitives.
	///
	/// The majority of the words are defined in the file: core/words.dart.
	///
	/// The words whose implementation depends on the specific Dart interface
	/// are defined in the files: cli/dictionary.dart and web/dictionary.dart,
	/// and included from the corresponding implementations in: /bin and /web.
	Dictionary(VirtualMachine vm) {

		// Must receive the Virtual Machine as an argument because its constructor
		// has not finished yet, and therefore the global variable forth is null.
		// The same things happens with this dictionary, and the following words:

		// Core.
		includeWordsStandardCore(vm, this);

		includeWordsNotStandardCore(vm, this);
		includeWordsNotStandardExtra(vm, this);

		// Optional Standard Sets.
		// -----------------------

		// Floats.
		includeWordsStandardOptionalFloat(vm, this);

		// Block.
		includeWordsStandardOptionalBlock(vm, this);

		// Tools.
		includeWordsStandardOptionalProgrammingTools(vm, this);
	}

	/// Adds a new word to this dictionary's [wordsMap] and [wordsList].
	addWord(String str, bool isImmediate, bool isCompileOnly, Function f) {
		str = str.toUpperCase();
		wordsList.add(new Word(isImmediate, isCompileOnly, f, str, wordsList.length));
		wordsMap[str] = wordsList.last;
	}

	/// Adds a new word, overwriting a pre-existing same-name word.
	///
	/// This is used only for 
	addWordOver(String str, bool isImmediate, bool isCompileOnly, Function f) {
		str = str.toUpperCase();

		if (wordsMap.containsKey(str)) {
			int st = wordsMap[str].st;
			wordsList[st] = new Word(isImmediate, isCompileOnly, f, str, st);
			wordsMap[str] = wordsList[st];
		} else {
			addWord(str, isImmediate, isCompileOnly, f);
		}
	}

	/// Adds a new word that does nothing at all (no operation).
	///
	/// Convenience function to create a placeholder to be later overriden
	/// by calling [addWordOver] from cli/words.dart o web/words.dart.
	/// It's also useful to define words with no behaviour in the current
	/// implementation, like ALIGN and ALIGNED.
	addWordNope(String str, [bool isImmediate = false, bool isCompileOnly = false]) {
		str = str.toUpperCase();
		wordsList.add(new Word(isImmediate, isCompileOnly, (){}, str, wordsList.length));
		wordsMap[str] = wordsList.last;
	}
}


part of forandar;

/// A Forth definition.
class Word {

	/// The word name as it is used by Forth.
	///
	/// All uppercase. It is its key in [wordsMap].
	String name;

	/// A pointer to this word in [wordsList].
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
	List<Word> wordsList = [];

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

		includeWordsStandardCore(vm, this);
		includeWordsStandardCoreExtended(vm, this);

		includeWordsNotStandardCore(vm, this);
		includeWordsNotStandardExtra(vm, this);

		// Optional Standard Sets.
		// -----------------------

		// The optional Block word set.
		includeWordsStandardOptionalBlock(vm, this);

		// The optional Programming-Tools word set.
		includeWordsStandardOptionalProgrammingTools(vm, this);
	}

	/// Adds a new word to this dictionary's [wordsMap] and [wordsList].
	addWord(String str, bool isImmediate, bool isCompileOnly, Function f) {
		this.wordsList.add(new Word(isImmediate, isCompileOnly, f, str, this.wordsList.length + 1));
		this.wordsMap[str] = this.wordsList.last;
	}
}


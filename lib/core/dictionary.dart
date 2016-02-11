part of forandar;

/// A Forth definition.
class Word {

	/// The word name as it is used by Forth.
	///
	/// All uppercase. This is its key in [wordsMap].
	String name;

	/// An index pointer to this word in [wordsList].
	int nt;

	/// A flag that indicates if the word is immediate.
	bool isImmediate;

	/// A flag that indicates if the word is restricted.
	bool isCompileOnly;

	/// A flag that indicates if the compilation has completed.
	bool hasCompleted;

	/// The execution code for this word.
	final Function exec;

	// TODO: pointer to dataSpace and/or codeSpace.

	Word(this.isImmediate, this.isCompileOnly, this.exec, [this.name, this.nt]);
}

/// A searchable collection for all defined [Word]s.
///
/// Defines the primitives and contains both primitives and : words.
class Dictionary {

	/// List of [Word]s retrievable by the word's name.
	Map<String, Word> wordsMap = new SplayTreeMap();

	/// List of [Word]s retrievable by index.
	///
	/// Starting size is the number of reserved nt.
	List<Word> wordsList = new List()..length = Nt.values.length;

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
	addWord(String name, Function f, {int nt: -1, bool immediate: false, bool compileOnly: false}) {
		name = name.toUpperCase();
		if ( nt >= 0 ) {
			wordsList[nt] = new Word(immediate, compileOnly, f, name, nt);
			wordsMap[name] = wordsList[nt];
		} else {
			wordsList.add(new Word(immediate, compileOnly, f, name, wordsList.length));
			wordsMap[name] = wordsList.last;
		}
		//print("$name \t\t $nt (${wordsList.length - 1}) | ${wordsList.length}"); //TEMP DEBUG
	}

	/// Adds a new word that does nothing at all (no operation).
	///
	/// A convenience wrapper for defining words with no behaviour
	/// in the current implementation, like ALIGN and ALIGNED.
	///
	/// Also useful for creating a placeholder that will be overriden
	/// by calling [addWordOver] from the specific interface libraries.
	addWordNope(String name, {nt: -1, bool immediate: false, bool compileOnly: false}) {
		addWord(name, (){}, nt: nt, immediate: immediate, compileOnly: compileOnly);
	}

	/// Adds a new word, overwriting a pre-existing same-name word.
	///
	/// This is inteded to be used only in conjunction with [addWordNope].
	addWordOver(String name, Function f, {bool immediate: false, bool compileOnly: false}) {
		name = name.toUpperCase();
		if (wordsMap.containsKey(name)) {
			int nt = wordsMap[name].nt;
			wordsList[nt] = new Word(immediate, compileOnly, f, name, nt);
			wordsMap[name] = wordsList[nt];
		} else {
			throwError(-2049, msg: name);
		}
	}

	void execNt(int wordNt) => wordsList[wordNt].exec();

	void execWord(String wordName) => wordsMap[wordName].exec();
}


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
	final bool isImmediate;

	/// A flag that indicates if the word is restricted.
	final bool isCompileOnly;

	/// A flag that indicates if the compilation has completed.
	bool hasCompleted;

	/// The execution code for this word.
	final Function code;

	// TODO: pointer to dataSpace and/or codeSpace.

	Word(this.isImmediate, this.isCompileOnly, this.code, [this.name, this.st]);
}

/// A searchable collection for all defined [Word]s.
///
/// Defines the primitives and contains both primitives and : words.
class Dictionary {

	/// List of [Word]s retrievable by the word's name.
	Map<String, Word> wordsMap = new SplayTreeMap();

	/// List of [Word]s retrievable by index.
	List<Word> wordsList = [];

	/// The parent [VirtualMachine].
	VirtualMachine vm;

	/// Constants for the flags of the [Word]
	static const immediate      = true;
	static const compileOnly    = true;

	Dictionary(this.vm) {

		/// Adds the primitives to the dictionary.
		includeStandardPrimitives();
		includeExtendedPrimitives();
	}

	/// Adds a new word to this dictionary's [wordsMap] and [wordsList].
	void addWord(String str, bool isImmediate, bool isCompileOnly, Function f) {
		this.wordsList.add(new Word(isImmediate, isCompileOnly, f, str, this.wordsList.length + 1));
		this.wordsMap[str] = this.wordsList.last;
	}

	/// Defines the [Forth standard primitives][core].
	///
	/// [core]: http://forth-standard.org/standard/core/
	includeStandardPrimitives() {
		
		// Words that manipulate [dataStack].

		addWord(".", false, false, (){}); // TODO
		addWord(".S", false, false, (){}); // TODO

		addWord("DUP", false, false, this.vm.dataStack.Dup);
		addWord("?DUP", false, false, () {
			if (this.vm.dataStack.size > 0) vm.dataStack.Dup();
		});
		addWord("DROP", false, false, this.vm.dataStack.Drop);
		addWord("OVER", false, false, this.vm.dataStack.Over);
		addWord("SWAP", false, false, this.vm.dataStack.Swap);
		addWord("ROT", false, false, this.vm.dataStack.Rot);
		addWord("-ROT", false, false, this.vm.dataStack.RotCC);
		addWord("NIP", false, false, this.vm.dataStack.Nip);
		addWord("TUCK", false, false, this.vm.dataStack.Tuck);

		/// Moves data FROM [dataStack] TO [returnStack].
		///
		/// [toR][link] ( x -- ) ( R: -- x )
		/// [link]: http://forth-standard.org/standard/core/toR
		addWord(">R", false, false, () {
			vm.returnStack.Push(vm.dataStack.Pop());
		});

	}

	/// Forth Primitives that are not part of the standard.
	///
	/// [Gforth Word Index][http://www.complang.tuwien.ac.at/forth/gforth/Docs-html/Word-Index.html#Word-Index]
	includeExtendedPrimitives() {

		/// Tries to find the name token nt of the word represented by xt.
		///
		/// Returns 0 if it fails.
		/// Note that in the current implementation xt and nt are exactly the same.
		/// [toName] ( xt -- nt|0 )
		/// [link]: http://www.complang.tuwien.ac.at/forth/gforth/Docs-html/Name-token.html
		addWord(">NAME", false, false, () {}); // TODO


		/// Tries to find the name of the [Word] represented by nt.
		///
		/// Note that in the current implementation xt and nt are exactly the same.
		/// [nameToString] ( nt -- addr count )
		/// [link]: http://www.complang.tuwien.ac.at/forth/gforth/Docs-html/Name-token.html
		addWord("NAME>STRING", false, false, () {}); // TODO


		///
		/// : id.  ( nt -- )  name>string type ;
		addWord("ID.", false, false, () {}); // TODO
	}
}


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

	/// Constants for the flags of the [Word].
	static const immediate      = true;
	static const compileOnly    = true;

	Dictionary(this.vm) {

		/// Adds the primitives to the dictionary.
		///
		/// The primitives whose implementation depends on the specific interface
		/// are defined in the files: cli/dictionary.dart and web/dictionary.dart.
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

		// Control
		addWord("INTERPRET", false, false, (){

			/// Reads the next word from source.

				/// Search this word in the current dictionary.

					/// If this word = [isCompileOnly] and we are not in compile mode, throw err -14.

					/// If this word != [isImmediate] and we are in compile mode, compile it.

					/// Executes the word In any other case.

				/// If word is not found, tries to convert it to a number in current base.

					/// If that's not possible, throw not-standard sys err "not a word not a number" (not understood).

					/// If we are in compiling, compile the number in the data space.

					/// If we are interpreting leave it in the stack.

			/// Loop ends when there are no more words.

		});
		
		/// Words that manipulate [dataStack].

		addWord(".", false, false, (){}); // TODO
		addWord(".S", false, false, (){}); // TODO

		addWord("DUP", false, false, this.vm.dataStack.Dup);

		/// Duplicate cell pair x1 x2.
		///
		/// : [2DUP][link] ( x1 x2 -- x1 x2 x1 x2 )
		///	  over over ;
		/// [link]: http://forth-standard.org/standard/core/TwoDUP
		addWord("2DUP", false, false, this.vm.dataStack.Dup2);

		addWord("?DUP", false, false, () {
			if (this.vm.dataStack.size > 0) vm.dataStack.Dup();
		});

		/// Remove x from the stack.
		///
		/// [DROP][link] ( x -- )
		/// [link]: http://forth-standard.org/standard/core/DROP
		addWord("DROP", false, false, this.vm.dataStack.Drop);

		/// Drop cell pair x1 x2 from the stack.
		///
		/// [2DROP][link] ( x1 x2 -- )
		/// [link]: http://forth-standard.org/standard/core/TwoDROP
		addWord("2DROP", false, false, this.vm.dataStack.Drop2);

		/// Place a copy of x1 on top of the stack.
		///
		/// [OVER][link] ( x1 x2 -- x1 x2 x1 )
		/// [link]: http://forth-standard.org/standard/core/OVER
		addWord("OVER", false, false, this.vm.dataStack.Over);

		/// Exchange the top two stack items.
		///
		/// [SWAP][link] ( x1 x2 -- x2 x1 )
		/// [link]: http://forth-standard.org/standard/core/SWAP
		addWord("SWAP", false, false, this.vm.dataStack.Swap);

		/// Rotate the top three stack entries.
		///
		/// [ROT][link] ( x1 x2 x3 -- x2 x3 x1 )
		/// [link]: http://forth-standard.org/standard/core/ROT
		addWord("ROT", false, false, this.vm.dataStack.Rot);
		addWord("-ROT", false, false, this.vm.dataStack.RotCC);
		addWord("NIP", false, false, this.vm.dataStack.Nip);
		addWord("TUCK", false, false, this.vm.dataStack.Tuck);

		/// Moves data FROM [dataStack] TO [returnStack].
		///
		/// [toR][link] ( x -- ) ( R: -- x )
		/// [link]: http://forth-standard.org/standard/core/toR
		addWord(">R", false, false, () {
			this.vm.returnStack.Push(this.vm.dataStack.Pop());
		});

		/// Make the most recent definition an immediate word.
		///
		/// [IMMEDIATE][link] ( -- )
		/// [link]: http://forth-standard.org/standard/core/IMMEDIATE
		addWord("IMMEDIATE", false, false, () {
			this.wordsList.last.isImmediate = true;
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
		/// [toName][link] ( xt -- nt|0 )
		/// [link]: http://www.complang.tuwien.ac.at/forth/gforth/Docs-html/Name-token.html
		addWord(">NAME", false, false, () {}); // TODO

		/// Tries to find the name of the [Word] represented by nt.
		///
		/// Note that in the current implementation xt and nt are exactly the same.
		/// [nameToString][link] ( nt -- addr count )
		/// [link]: http://www.complang.tuwien.ac.at/forth/gforth/Docs-html/Name-token.html
		addWord("NAME>STRING", false, false, () {}); // TODO

		/// TODO
		///
		/// [id.][link] ( nt -- )  name>string type ;
		/// [link]: TODO
		addWord("ID.", false, false, () {}); // TODO
	}
}


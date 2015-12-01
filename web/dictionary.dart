part of forandar;

/// Encapsulates a Forth Word
class Word {

	/// The forth word, same as map key 
	final String name; 

	/// Word Flags
	final bool isImmediate;
	final bool isCompileOnly; // restricted word?
	bool hasCompleted; // compilation finished?

	/// The execution code for this word
	final Function code;

	/// Integer Pointer to this word in [wordsList]
	int st;

	// TODO: pointer to dataSpace and/or codeSpace 


	/// [Word] Constructor
	Word(this.name, this.isImmediate, this.isCompileOnly, this.code) {}
}

/// Encapsulates all the dictionary properties and methods
class Dictionary {

	/// List of Words retrievable by the word's name
	Map<String, Word> wordsMap = new SplayTreeMap();

	/// List of words retrievable by index
	List<Word> wordsList = [];

	/// Stores the parent Virtual Machine
	VM vm;

	/// [Dictionary] Constructor
	Dictionary(this.vm) {

		/// Populates [wordsMap] with the primitives
		createPrimitives();

		/// Copies all the words from [wordsMap] to [wordsList] and update its [Word.st] property.
		this.wordsMap.forEach(this.wordFromMapToList);
	}

	/*
	void addWord() {
	}
	*/

	/// Adds a word already present in [wordsMap] to the [wordsList]
	void wordFromMapToList(key, value) {

		this.wordsList.add(value);
		this.wordsList.last.st = this.wordsList.length;
	}

	/// Defines the Forth Primitives and adds them to [wordsMap]
	createPrimitives() {
		
		// Words that manipulate [dataStack]

		this.wordsMap["."] = new Word("-ROT", false, false, this.vm.dataStack.RotCC);
		this.wordsMap[".S"] = new Word("-ROT", false, false, this.vm.dataStack.RotCC);
		this.wordsMap["DUP"] = new Word("DUP", false, false, this.vm.dataStack.Dup);
		this.wordsMap["?DUP"] = new Word("?DUP", false, false, () {
			if (this.vm.dataStack.size > 0) vm.dataStack.Dup();
		});
		this.wordsMap["DROP"] = new Word("DROP", false, false, this.vm.dataStack.Drop);
		this.wordsMap["OVER"] = new Word("OVER", false, false, this.vm.dataStack.Over);
		this.wordsMap["SWAP"] = new Word("SWAP", false, false, this.vm.dataStack.Swap);
		this.wordsMap["ROT"] = new Word("ROT", false, false, this.vm.dataStack.Rot);
		this.wordsMap["-ROT"] = new Word("-ROT", false, false, this.vm.dataStack.RotCC);
		this.wordsMap["NIP"] = new Word("NIP", false, false, this.vm.dataStack.Nip);
		this.wordsMap["TUCK"] = new Word("TUCK", false, false, this.vm.dataStack.Tuck);

		// Words that manipulate [returnStack]

		// Words that manipulate multiple stacks.

		// Move data FROM the [dataStack] TO the [returnStack]
		// ( a -- R: a )
		this.wordsMap[">R"] = new Word(">R", true, false, () {
			vm.returnStack.Push(vm.dataStack.Pop());
		});
	}
}


/// The structure of a forth [Word].
library forandar.core.word;

/// A Forth definition.
class Word {

	/// The word name as it is used by Forth.
	///
	/// All words names are stored in uppercase.
	/// This is its key in the inner map of words.
	String name;

	/// The "name token" index to this word.
	///
	/// This is an index in the inner list of words.
	int nt;

	/// A flag that indicates if the word is immediate.
	bool isImmediate;

	/// A flag that indicates if the word is restricted.
	bool isCompileOnly;

	/// A flag that indicates if the compilation has completed.
	bool hasCompleted; // TODO

	/// The execution code for this word.
	final Function exec;

	// TODO: code space.

	/// Word constructor accepts [nt] either as Nt type or int (Nt.index).
	Word(this.isImmediate, this.isCompileOnly, this.exec, this.name, var nt) {
		try {
			this.nt = nt.index;
		}
		catch(e) {
			this.nt = nt;
		}
	}
}

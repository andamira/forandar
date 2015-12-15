part of web;

/// Forth Primitives that depends on the web interface.
/// 
/// [The optional File-Access word set][http://forth-standard.org/standard/file]
void includeWordsWeb(VirtualMachine vm, Dictionary d) {

	/// Loads a file (URL) and interprets it.
	///
	/// [INCLUDED][link] ( i * x c-addr u -- j * x )
	/// [link]: http://forth-standard.org/standard/file/INCLUDED
	d.addWord("INCLUDED", false, false, () {}); // TODO

	/// TODO
	///
	/// [][link] ( -- )  name>string type ;
	/// [link]: TODO
	// d.addWord("", false, false, () {}); // TODO

	/// TODO
	///
	/// [][link] ( -- )  name>string type ;
	/// [link]: TODO
	// d.addWord("", false, false, () {}); // TODO
}

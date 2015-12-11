part of cli;

/// Forth Primitives that depends on the CLI interface.
/// 
/// [The optional File-Access word set][http://forth-standard.org/standard/file]
void includeCliPrimitives(Dictionary d) {

	/// Loads a file (URL) and interprets it.
	///
	/// [INCLUDED][link] ( i * x c-addr u -- j * x )
	/// [link]: http://forth-standard.org/standard/file/INCLUDED
	d.addWord("INCLUDED", false, false, () {}); // TODO

	/// TODO
	///
	/// [][link] ( nt -- )  name>string type ;
	/// [link]: TODO
	// d.addWord("", false, false, () {}); // TODO

	/// TODO
	///
	/// [][link] ( nt -- )  name>string type ;
	/// [link]: TODO
	// d.addWord("", false, false, () {}); // TODO

}

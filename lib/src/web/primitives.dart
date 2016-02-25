library forandar_web;

import 'package:forandar/src/core/dictionary.dart';
import 'package:forandar/src/core/virtual_machine.dart';

/// Forth Primitives that depends on the web interface.
/// 
/// [The optional File-Access word set][http://forth-standard.org/standard/file]
void includeWordsWeb(VirtualMachine vm, Dictionary d) {

	/// 
	///
	/// [][link] ( -- )  name>string type ;
	/// [link]: 
	// d.addWord("", () {});
}

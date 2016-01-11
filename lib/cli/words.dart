part of cli;

/// Forth Primitives that depends on the CLI interface.
/// 
void includeWordsCli(VirtualMachine vm, Dictionary d) {
	includeWordsCliCore(vm, d);
	includeWordsCliFile(vm, d);
	includeWordsCliDebug(vm, d);
}

void includeWordsCliCore(VirtualMachine vm, Dictionary d) {

	/// 
	///
	/// [BYE][link]
	/// [link]:
	d.addWordOver("BYE", false, false, () {
		exit(0);
	});

	/// 
	///
	/// [][link]
	/// [link]:
	// d.addWordOver("", false, false, () {}); // TODO
}

/// [The optional File-Access word set][http://forth-standard.org/standard/file]
void includeWordsCliFile(VirtualMachine vm, Dictionary d) {

	/// Loads a file (URL) and interprets it.
	///
	/// [INCLUDED][link] ( i * x c-addr u -- j * x )
	/// [link]: http://forth-standard.org/standard/file/INCLUDED
	//d.addWordOver("INCLUDED", false, false, () {}); // TODO

	/// 
	///
	/// [][link]
	/// [link]:
	// d.addWordOver("", false, false, () {}); // TODO
}

void includeWordsCliDebug(VirtualMachine vm, Dictionary d) {

	/// Prints the [DataSpace] content as a string of Bytes in hex.
	d.addWordOver(".DD", false, false, () {
		for (var x in vm.dataSpace.data.buffer.asUint8List()) {
			stdout.write(x.toRadixString(16).replaceAll(new RegExp(r'0'),'_'));
		}
		stdout.writeln();
	});

	/// Prints the [ObjectSpace] content as a string of Bytes in hex.
	d.addWordOver(".OD", false, false, () {
		for (var x in vm.objectSpace.data) {
			print(x);
		}
	});
}


part of cli;

/// Forth Primitives that depends on the CLI interface.
/// 
void includeWordsCli(VirtualMachine vm, Dictionary d) {
	includeWordsCliStandardCore(vm, d);
	includeWordsCliStandardOptionalFile(vm, d);
	includeWordsCliStandardOptionalProgrammingTools(vm, d);
	includeWordsCliNotStandardExtra(vm, d);
}

void includeWordsCliStandardCore(VirtualMachine vm, Dictionary d) {

	// . U.

	/// Display n in free field format.
	///	
	/// [.][link] ( n -- )
	/// [link]: http://forth-standard.org/standard/core/d
	d.addWordOver(".", (){
		stdout.write("${vm.dataStack.pop()} ");
	});

	/// Display u in free field format.
	///
	/// [U.][link] ( u -- )
	/// [link]: http://forth-standard.org/standard/core/Ud
	d.addWordOver("U.", (){
		stdout.write("${vm.dataStack.pop().toUnsigned(32)} ");
	});
}

/// [The optional File-Access word set][http://forth-standard.org/standard/file]
void includeWordsCliStandardOptionalFile(VirtualMachine vm, Dictionary d) {

	/// Loads a file (URL) and interprets it.
	///
	/// [INCLUDED][link] ( i * x c-addr u -- j * x )
	/// [link]: http://forth-standard.org/standard/file/INCLUDED
	//d.addWordOver("INCLUDED", () {}); // TODO
}

void includeWordsCliStandardOptionalProgrammingTools(VirtualMachine vm, Dictionary d) {

	// ? BYE

	/// Display the value stored at a-addr.
	///
	/// [?][link] ( a-addr -- )
	/// [link]: http://forth-standard.org/standard/tools/q
	d.addWordOver("?", (){
		stdout.write("${vm.dataSpace.fetchCell(vm.dataStack.pop()).toRadixString(vm.dataSpace.fetchCell(addrBASE))} ");
	});

	/// Return control to the host operating system, if any.
	///
	/// [BYE][link] ( -- )
	/// [link]: https://forth-standard.org/standard/tools/BYE
	d.addWordOver("BYE", () {
		exit(0);
	});
}

void includeWordsCliNotStandardExtra(VirtualMachine vm, Dictionary d) {

	// BIN. ODUMP

	/// Prints the object space content. TODO
	d.addWordOver("ODUMP", () {
		for (var obj in vm.objectSpace.data) {
			stdout.write("$obj ");
		}
	});

	/// Display an integer binary format.
	d.addWordOver("BIN.", () {
		stdout.write("${int32ToBin(vm.dataStack.pop())} ");
	});
}


part of forandar_cli.primitives;

/// Forth Primitives that depends on the CLI interface.
/// 
void includeWordsCli(VirtualMachine vm, Dictionary d) {
	includeWordsCliStandardCore(vm, d);
	includeWordsCliStandardOptionalFile(vm, d);
	includeWordsCliStandardOptionalProgrammingTools(vm, d);
	includeWordsCliNotStandardExtra(vm, d);
}

void includeWordsCliStandardCore(VirtualMachine vm, Dictionary d) {

	// . SPACE SPACES U.

	/// Display n in free field format.
	///	
	/// [.][link] ( n -- )
	/// [link]: http://forth-standard.org/standard/core/d
	d.addWordOver(".", (){
		stdout.write("${vm.dataStack.pop()} ");
	});

	/// Display one space.
	///
	/// [SPACE][link] ( -- )
	/// [link]: http://forth-standard.org/standard/core/SPACE
	d.addWordOver("SPACE", () {
		stdout.write(" ");
	});

	/// If n is greater than zero, display n spaces.
	///
	/// [SPACES][link] ( u -- )
	/// [link]: http://forth-standard.org/standard/core/SPACES
	d.addWordOver("SPACES", () {
		var times = vm.dataStack.pop();
		if (times > 0) {
			var str = new StringBuffer();
			for (int i = 0; i < times; i++) {
				str.write(" ");
			}
			stdout.write(str.toString());
		}
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

	// ?STRING BIN. ODUMP

	/// Display the string stored at ( c-addr u -- )
	d.addWord("?STRING", (){
		vm.dataStack.swap();
		stdout.write(vm.dataSpace.fetchString(vm.dataStack.pop(), vm.dataStack.pop()));
	});

	/// Display an integer binary format.
	d.addWordOver("BIN.", () {
		stdout.write("${util.int32ToBin(vm.dataStack.pop())} ");
	});

	/// Prints the object space content. TODO
	d.addWordOver("ODUMP", () {
		for (var obj in vm.objectSpace.data) {
			stdout.write("$obj ");
		}
	});
}


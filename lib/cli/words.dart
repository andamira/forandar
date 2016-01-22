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

	// . QUIT U.

	/// Display n in free field format.
	///	
	/// [.][link] ( n -- )
	/// [link]: http://forth-standard.org/standard/core/d
	d.addWordOver(".", false, false, (){
		stdout.write("${vm.dataStack.pop()} ");
	});

	/// TODO FIXME
	///
	d.addWordOver("QUIT", false, false, () async {

		//stdout.writeln("andamira forandar v${await getVersion()}");
		stdout.writeln("Type `bye' to exit");
		
		while(true) {
		
			vm.input.clear();
			vm.input.add(InputType.String, stdin.readLineSync());

			await d.wordsMap['INTERPRET'].exec();

			stdout.writeln("  ok"); // TEMP
		}
	});

	/// Display u in free field format.
	///
	/// [U.][link] ( u -- )
	/// [link]: http://forth-standard.org/standard/core/Ud
	d.addWordOver("U.", false, false, (){
		stdout.write("${vm.dataStack.pop().toUnsigned(32)} ");
	});
}

/// [The optional File-Access word set][http://forth-standard.org/standard/file]
void includeWordsCliStandardOptionalFile(VirtualMachine vm, Dictionary d) {

	/// Loads a file (URL) and interprets it.
	///
	/// [INCLUDED][link] ( i * x c-addr u -- j * x )
	/// [link]: http://forth-standard.org/standard/file/INCLUDED
	//d.addWordOver("INCLUDED", false, false, () {}); // TODO
}

void includeWordsCliStandardOptionalProgrammingTools(VirtualMachine vm, Dictionary d) {

	// ? BYE

	/// Display the value stored at a-addr.
	///
	/// [?][link] ( a-addr -- )
	/// [link]: http://forth-standard.org/standard/tools/q
	d.addWordOver("?", false, false, (){
		stdout.write("${vm.dataSpace.data.getInt32(vm.dataStack.pop()).toRadixString(vm.dataSpace.data.getInt32(addrBASE))} ");
	});

	/// Return control to the host operating system, if any.
	///
	/// [BYE][link] ( -- )
	/// [link]: https://forth-standard.org/standard/tools/BYE
	d.addWordOver("BYE", false, false, () {
		exit(0);
	});
}

void includeWordsCliNotStandardExtra(VirtualMachine vm, Dictionary d) {

	// BIN. ODUMP

	/// Prints the object space content. TODO
	d.addWordOver("ODUMP", false, false, () {
		for (var obj in vm.objectSpace.data) {
			stdout.write("$obj ");
		}
	});

	/// Display an integer binary format.
	d.addWordOver("BIN.", false, false, () {
		stdout.write("${int32ToBin(vm.dataStack.pop())} ");
	});
}


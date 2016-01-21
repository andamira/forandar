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

	/// 
	///
	/// [][link]
	/// [link]:
	// d.addWordOver("", false, false, () {}); // TODO
}

void includeWordsCliStandardOptionalProgrammingTools(VirtualMachine vm, Dictionary d) {

	// BYE

	/// Return control to the host operating system, if any.
	///
	/// [BYE][link] ( -- )
	/// [link]: https://forth-standard.org/standard/tools/BYE
	d.addWordOver("BYE", false, false, () {
		exit(0);
	});
}

void includeWordsCliNotStandardExtra(VirtualMachine vm, Dictionary d) {

	// BIN. .DD .OD

	/// Display an integer binary format.
	d.addWordOver("BIN.", false, false, () {
		stdout.write("${int32tobin(vm.dataStack.pop())} ");
	});

	/// Prints the data space content as a string of Bytes in hex. // TEMP
	d.addWordOver(".DD", false, false, () {
		for (var x in vm.dataSpace.data.buffer.asUint8List()) {
			stdout.write(x.toRadixString(16).replaceAll(new RegExp(r'0'),'_') + " ");
		}
		stdout.writeln();
	});

	/// Prints the object space content.
	d.addWordOver(".OD", false, false, () {
		for (var obj in vm.objectSpace.data) {
			stdout.write("$obj ");
		}
	});
}


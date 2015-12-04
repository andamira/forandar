part of forandar;

/// Custom Tests
class TempTests {

	final VirtualMachine vm;

	TempTests(VirtualMachine this.vm);

	/// Wraps console print for debug, info warn & error
	///
	/// https://api.dartlang.org/1.13.0/dart-html/Console-class.html
	printD(String s) => window.console.debug(s);
	printI(String s) => window.console.info(s);
	printW(String s) => window.console.warn(s);
	printE(String s) => window.console.error(s);

	header(String str, e, name) {
		print("");
		printI("\n");
		printD(">>>>>>TEST>>>>>> $str");
		printD('"$name" $e');
	}

	footer(String str) {
		printD("<<<<<<<<<<<<<<<< $str");
	}

	separator() {
		printD("----------------");
	}
	

	/// Tests a [Stack] instance
	TestStack(Stack t, String name) {
		this.header("stack", t, name);
		printD("length: ${t.data.length} cells, ${t.data.lengthInBytes} bytes");
		this.separator();

		t.Push(82); printD("Push(82) >\t${t}");
		t.Push(25); printD("Push(25) >\t${t}");
		t.Push(11); printD("Push(11) >\t${t}");
		t.Push(3);  printD("Push(11) >\t${t}");

		t.Rot(); printD("Rot() >\t\t${t}");
		t.RotCC(); printD("Rotcc() >\t${t}");

		t.Over(); printD("Over() >\t${t}");
		printD("Pop() > ${t.Pop()}\t${t}");
		t.Swap(); printD("Swap() >\t${t}");
		t.Dup(); printD("Dup() >\t\t${t}");

		t.Pick(4); printD("Pick(4) >\t${t}");

		//t.Roll(4); printD("Roll(4) >\t${t)}");

		t.Nip(); printD("Nip() >\t\t${t}");
		printD("Pop() > ${t.Pop()}\t${t}");
		t.Tuck(); printD("Tuck() >\t${t}");

		this.footer("/stack");
	}

	/// Tests a [DataSpace] instance.
	TestDataSpace(DataSpace t, String name) {
		this.header("dataSpace", t, name);
		this.separator();
		this.footer("/dataSpace");
	}

	/// Tests a [Dictionary] instance.
	TestDictionary(Dictionary t, String name) {

		this.header("dictionary", t, name);
		printD("nº words: ${t.wordsMap.length} in map, ${t.wordsList.length} in list");
		this.separator();

		// lists the words
		t.wordsMap.forEach( (key, value) {
			printD("${value.st}\t${value.name}\t"
				"${value.isImmediate ? "[immediate]" : ""} "
				"${value.isCompileOnly ? "[compileOnly]" : ""} "
			);
		});
		this.separator();

		/// Tests some [dataStack] manipulation calling [Word]s from the [Dictionary] 
		t.wordsMap["OVER"].code(); printD("OVER >\t\t${this.vm.dataStack}");
		t.wordsMap["?DUP"].code(); printD("?DUP >\t\t${this.vm.dataStack}");
		


		this.footer("/dictionary");
	}

	/// TODO: Tests a [VirtualMachine] instance.
	TestVirtualMachine(VirtualMachine t, String name) {
		this.header("VirtualMachine", t, name);
		this.separator();
		this.footer("/VirtualMachine");
	}
}


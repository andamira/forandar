part of daranfor;

/// Custom Tests
class TempTests {

	final VM vm;

	TempTests(VM this.vm) {
	}

	header(String str, e, name) {
		print("\n>>>>>>TEST>>>>>> $str");

		print('"$name" $e');
	}

	footer(String str) {
		print("<<<<<<<<<<<<<<<< $str");
	}

	separator() {
		print("----------------");
	}
	

	/// Tests a [Stack] instance
	TestStack(Stack t, String name) {
		this.header("stack", t, name);

		print("length: ${t.data.length} cells, ${t.data.lengthInBytes} bytes");
		print("size: (${t.size}) ${t.Print()}");

		this.separator();

		t.Push(82); print("Push(82) >\t${t}");
		t.Push(25); print("Push(25) >\t${t}");
		t.Push(11); print("Push(11) >\t${t}");
		t.Push(3);  print("Push(11) >\t${t}");

		t.Rot(); print("Rot() >\t\t${t}");
		t.RotCC(); print("Rotcc() >\t${t}");

		t.Over(); print("Over() >\t${t}");
		t.Swap(); print("Swap() >\t${t}");
		t.Dup(); print("Dup() >\t\t${t}");

		t.Pick(4); print("Pick(4) >\t${t}");

		//t.Roll(4); print("Roll(4) >\t${t)}");

		t.Nip(); print("Nip() >\t\t${t}");
		t.Tuck(); print("Tuck() >\t${t}");

		print("Pop() > ${t.Pop()}\t${t}");

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
		print("nº words: ${t.wordsMap.length} in map, ${t.wordsList.length} in list");
		this.separator();

		// lists the words
		t.wordsMap.forEach( (key, value) {
			print("${value.st} \"$key\" ${value.isImmediate ? "[Immediate]" : ""} ${value.isCompileOnly ? "[CompileOnly]" : ""} "
				//"code=\"${value.code.toString().substring(15)}\"");
				"code=\"${value.code}\"");
		});
		this.separator();

		/// Tests some [dataStack] manipulation calling [Word]s from the [Dictionary] 
		t.wordsMap["OVER"].code(); print("OVER >\t\t${this.vm.dataStack}");
		t.wordsMap["?DUP"].code(); print("?DUP >\t\t${this.vm.dataStack}");
		


		this.footer("/dictionary");
	}

	// Test VM (Virtual Machine)
	// TODO
	TestVM(VM t, String name) {
		this.header("VM", t, name);
		this.separator();
		this.footer("/VM");
	}
}


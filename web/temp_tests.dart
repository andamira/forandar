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

		t.Push(82); print("Push(82) > (${t.size}) ${t.Print()}");
		t.Push(25); print("Push(25) > (${t.size}) ${t.Print()}");
		t.Push(11); print("Push(11) > (${t.size}) ${t.Print()}");
		t.Push(3);  print("Push(11) > (${t.size}) ${t.Print()}");

		t.Rot(); print("Rot() > (${t.size}) ${t.Print()}");
		t.RotCC(); print("Rotcc() > (${t.size}) ${t.Print()}");

		t.Over(); print("Over() > (${t.size}) ${t.Print()}");
		t.Swap(); print("Swap() > (${t.size}) ${t.Print()}");
		t.Dup(); print("Dup() > (${t.size}) ${t.Print()}");

		t.Pick(4); print("Pick(4) > (${t.size}) ${t.Print()}");

		//t.Roll(4); print("Roll(4) > (${t.size}) ${t.Print()}");

		t.Nip(); print("Nip() > (${t.size}) ${t.Print()}");
		t.Tuck(); print("Tuck() > (${t.size}) ${t.Print()}");

		print("Pop() > ${t.Pop()} (${t.size}) ${t.Print()}");

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
		t.wordsMap["OVER"].code(); print("OVER > (${this.vm.dataStack.size}) ${this.vm.dataStack.Print()}");
		t.wordsMap["?DUP"].code(); print("?DUP > (${this.vm.dataStack.size}) ${this.vm.dataStack.Print()}");
		


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


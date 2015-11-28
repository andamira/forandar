part of daranfor;

class TempTests {

	TempTests() {
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


	// Test the Stack
	TestStack(Stack s, String name) {
		this.header("stack", s, name);

		print("length: ${s.data.length} cells, ${s.data.lengthInBytes} bytes");
		print("size: (${s.size}) ${s.List()}");

		this.separator();

		s.Push(82); print("push 82 > (${s.size}) ${s.List()}");
		s.Push(25); print("push 25 > (${s.size}) ${s.List()}");
		s.Push(11); print("push 11 > (${s.size}) ${s.List()}");
		s.Push(3);  print("push 11 > (${s.size}) ${s.List()}");

		s.Rot(); print("rot > (${s.size}) ${s.List()}");
		s.RotCC(); print("rotcc > (${s.size}) ${s.List()}");
		//s.rotate(3); print("rotate > (${s.size}) ${s.List()}");

		s.Over(); print("over > (${s.size}) ${s.List()}");
		s.Swap(); print("swap > (${s.size}) ${s.List()}");

		print("pop > ${s.Pop()} (${s.size}) ${s.List()}");
		s.Dup(); print("dup > (${s.size}) ${s.List()}");
		print("pop > ${s.Pop()} (${s.size}) ${s.List()}");

		this.footer("/stack");
	}

	// Test the ...
}


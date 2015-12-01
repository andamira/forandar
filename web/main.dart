library forandar;

import 'dart:collection';
import 'dart:typed_data';

part 'dictionary.dart';
part 'stack.dart';
part 'temp_tests.dart';
part 'vm.dart';

void main() {

	/// Creates the Forth [VirtualMachine]
	VirtualMachine forth = new VirtualMachine();

	/// Runs the temporary tests
	TempTests test = new TempTests(forth);
	test.TestStack(forth.dataStack, "forth.dataStack");
	test.TestDictionary(forth.dict, "forth.dict");
}

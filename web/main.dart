library forandar;

import 'dart:collection';
import 'dart:typed_data';

part 'dictionary.dart';
part 'stack.dart';
part 'temp_tests.dart';
part 'vm.dart';

void main() {

	/// Creates the Forth Virtual Machine
	VM forth = new VM();

	/// Runs the temporary tests
	var test = new TempTests(forth);
	test.TestStack(forth.dataStack, "forth.dataStack");
	test.TestDictionary(forth.dict, "forth.dict");
}

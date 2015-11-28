library daranfor;

import 'dart:typed_data';

part 'stack.dart';
part 'temp_tests.dart';

void main() {
	var stackData = new LifoStack(256);
	var stackReturn = new LifoStack(32);

	// Temporary Tests
	var test = new TempTests();
	test.TestStack(stackData, "stackData");
}


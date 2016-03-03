library forandar.cli.input;

import 'dart:async';
import 'dart:io';

// Core
import 'package:forandar/src/core/input.dart';

// The input queue adapted for the CLI interface.
class InputQueue extends InputQueueBase {

	@override
	Future<String> loadFile(String f) async {
		var contents = await new File(f).readAsString();
		return contents;
	}

	@override
	Future<String> readLineFromTerminal() async {
		return await stdin.readLineSync();
	}
}

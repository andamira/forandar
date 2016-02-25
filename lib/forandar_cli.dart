library forandar_cli;

import 'dart:async';
import 'dart:io';

import 'src/core/input.dart';

export 'forandar.dart';
export 'src/cli/primitives.dart';

// TODO:
// - load forandar version from here
// - define CLI class, and common methods

// The input queue adapted for the CLI interface.
class InputQueueCli extends InputQueue {

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


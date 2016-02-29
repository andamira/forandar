library forandar_cli.exception;

import 'dart:async';
import 'dart:io';

// Core
import 'package:forandar/src/core/input.dart';

// Core Exception
export 'package:forandar/exception/forandar.dart';
export 'package:forandar/src/cli/exception/primitives.dart';

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


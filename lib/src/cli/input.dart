library forandar.cli.input;

import 'dart:async';
import 'dart:io';

// Core
import 'package:forandar/src/core/configuration.dart';
import 'package:forandar/src/core/input.dart';
import 'package:forandar/src/core/globals.dart';

// Cli
//import 'package:forandar/src/cli/ansi.dart';

// The input queue adapted for the CLI interface.
class InputQueue extends InputQueueBase {

	@override
	Future<String> loadFile(String f) async {
		var contents = await new File(f).readAsString();
		return contents;
	}

	@override
	Future<String> readLineFromTerminal() async {

		// Be the most compatible by default.
		if (globalConfig.getOption('terminalType') == TerminalType.auto) {

			if (Platform.isWindows) {
				return await readLineFromSimpleTerminal();
			} else {
				return await readLineFromAnsiTerminal();
			}

		} else if (globalConfig.getOption('terminalType') == TerminalType.ansi) {
			return await readLineFromAnsiTerminal();
		} else {
			return await readLineFromSimpleTerminal();
		}
	}


	// A simple terminal, that works.
	Future<String> readLineFromSimpleTerminal() async {
		return await stdin.readLineSync();
	}

	// An ANSI compatible terminal, with extended functionality.
	Future<String> readLineFromAnsiTerminal() async {
		return await stdin.readLineSync(); // TEMP
	}

}

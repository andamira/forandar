library forandar.cli.input;

import 'dart:async';
import 'dart:io';

// Core
import 'package:forandar/src/core/configuration.dart';
import 'package:forandar/src/core/input.dart';
import 'package:forandar/src/core/globals.dart';

// Cli
import 'package:forandar/src/cli/terminal.dart';

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

			if (Platform.isLinux || Platform.isMacOS) {
				return await readLineFromXTerm();
			} else {
				return await readLineFromSimpleTerminal();
			}

		} else if (globalConfig.getOption('terminalType') == TerminalType.xterm) {
			return await readLineFromXTerm();
		} else {
			return await readLineFromSimpleTerminal();
		}
	}

	// A simple unfeatured terminal, that simply works.
	Future<String> readLineFromSimpleTerminal() async {
		return await stdin.readLineSync();
	}

	// An XTerm compatible full-featured terminal, with extra functionality.
	Future<String> readLineFromXTerm() async {
		return await Terminal.readLineSync(); // works, but problem is UTF8
	}
}

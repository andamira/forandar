import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';

import 'package:forandar/forandar.dart';
import 'package:forandar/cli.dart';

main(List<String> args) async {

	parseArguments(args);

}

/// Parses the CLI arguments
void parseArguments(List<String> args) {

	ArgResults results;
	ArgParser parser = new ArgParser(allowTrailingOptions: true);

	parser
		// Usage header
		..addSeparator('Usage: pub run forandar [options]')
	    ..addSeparator('Options:')

		/// Argument -e, --evaluate
		..addOption('evaluate', abbr: 'e',
			valueHelp: 'STRING',
			help: "Interpret STRING (with `EVALUATE')"
		)

		/// Argument -f, --file
		..addOption('file', abbr: 'f',
			valueHelp: 'FILE',
			help: "Load FILE (with `require')"
		)

		/// Argument -h, --help
		..addFlag('help', abbr: 'h',
			help: "This help",
			negatable: false,
			callback: (help) {
				if (help) displayUsage(parser);
			}
		)

		/// Argument -v, --version
		..addFlag('version', abbr: 'v',
			negatable: false,
			help: "Print version and exit",
			callback: (version) {
				if (version) {
					print("forandar $forandarVersion");
					exit(0);
				}
			}
		);

	if (args.isEmpty) {
		// TODO: run CLI interpreter
	}

	try {
		results = parser.parse(args);
	} catch (e) {
		print(e);
		displayUsage(parser);
	}

	if (results['evaluate'] != null) {
		// TODO: pass contents to interpreter
	}

	if (results['file'] != null) {
		// TODO: open file and pass contents to interpreter
	}
}

// Displays usage and exits
void displayUsage(ArgParser p) {
	print(p.getUsage());
	exit(0);
}


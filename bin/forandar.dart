import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:yaml/yaml.dart';

import 'package:forandar/cli.dart';

VirtualMachine forth;

main(List<String> args) async {

	var c = new Configuration();
	var i = new InputQueueCli();

	/// Parses the arguments from the command line.
	///
	/// Updates the default configuration in [c].
	/// fills the source code input queue in [i].
	parseArguments(args, i);

	/// Creates the Forth [VirtualMachine].
	forth = new VirtualMachine(c, i);

	/// Includes the primitives dependent on the CLI interface.
	includeWordsCli(forth, forth.dict);

	/// TODO: Interprets the code in the input queue.
	forth.dict.wordsMap['INTERPRET'].exec();
}

/// Parses the CLI arguments
void parseArguments(List<String> args, InputQueue i) {

	ArgResults results;
	ArgParser parser = new ArgParser(allowTrailingOptions: false);

	parser
		..addSeparator('Usage: pub run forandar [options]')
	    ..addSeparator('Options:')

		/// Argument -e, --evaluate
		..addOption('evaluate', abbr: 'e',
			allowMultiple: true,
			valueHelp: 'STRING',
			help: "Interpret STRING (with `EVALUATE')"
		)

		/// Argument -i, --include
		..addOption('include', abbr: 'i',
			allowMultiple: true,
			valueHelp: 'FILE',
			help: "Load FILE (with `INCLUDE')"
		)

		/// Argument -h, --help
		..addFlag('help', abbr: 'h',
			hide: false,
			negatable: false,
			// help: "This help",
			callback: (help) {
				if (help) displayUsage(parser);
			}
		)

		/// Argument -v, --version
		..addFlag('version', abbr: 'v',
			negatable: false,
			help: "Print version and exit",
			callback: (version) async {
				if (version) {
					print("forandar ${await getVersion()}");
					exit(0);
				}
			}
		);

	if (args.isEmpty) {
		//forth.dict.wordsMap['ACCEPT'].exec(); // TODO
		tempAccept(); // TEMP
		return;
	}

	try {
		results = parser.parse(args);
	} catch (e) {
		print(e);
		displayUsage(parser);
	}

	int eCounter = 0;
	int iCounter = 0;

	args.forEach( (a){

		switch (a) {

			case '-e':
			case '--evaluate':
				try {
					i.add(InputType.String, results['evaluate'][eCounter++]);
				} catch(e) {
					print(e);
				}
				break;

			case '-i':
			case '--include':
				try {
					i.add(InputType.File, results['include'][iCounter++]);
				} catch(e) {
					print(e);
				}
				break;
		}
	});
}

/// Displays usage and exits.
void displayUsage(ArgParser p) {
	print(p.getUsage());
	exit(0);
}


/// Returns version from pubspec.yaml. Updates global the first time.
Future<String> getVersion() async {
	if (forandarVersion == "FORANDAR_VERSION") {
		forandarVersion = await new File('pubspec.yaml').readAsString().then((String contents) {
			return loadYaml(contents)['version'];
		});
	}
	return forandarVersion;
}


// TEMP CLI Interpreter
tempAccept() async {
	stdout.writeln("andamira forandar v${await getVersion()}");
	stdout.writeln("Type `bye' to exit");

	while(true) {

		forth.input.clear();
		forth.input.add(InputType.String, stdin.readLineSync());

		await forth.dict.wordsMap['INTERPRET'].exec();

		stdout.writeln("   ok");
	}
}


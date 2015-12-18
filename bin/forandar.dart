import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:yaml/yaml.dart';

import 'package:forandar/forandar.dart';
import 'package:forandar/cli.dart';

VirtualMachine forth;


main(List<String> args) async {

	parseArguments(args);

	/// Creates the Forth [VirtualMachine].
	forth = new VirtualMachine(config);

	/// Includes the primitives dependant on the CLI interface.
	includeWordsCli(forth, forth.dict);
}

/// Parses the CLI arguments
void parseArguments(List<String> args) {

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
		print("TODO: `ACCEPT'");
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
					input.add(InputType.String, results['evaluate'][eCounter++]);
				} catch(e) {
					print(e);
				}
				break;

			case '-i':
			case '--include':
				try {
					input.add(InputType.File, results['include'][iCounter++]);
				} catch(e) {
					print(e);
				}
				break;
		}
	});

	print("TEMP: InputQueue = ${input.queue}"); // TEMP
}

/// Displays usage and exits.
void displayUsage(ArgParser p) {
	print(p.getUsage());
	exit(0);
}


/// Returns version from pubspec.yaml. Updates global the first time.
String getVersion() async {
	if (forandarVersion == "FORANDAR_VERSION") {
		forandarVersion = await new File('pubspec.yaml').readAsString().then((String contents) {
			return loadYaml(contents)['version'];
		});
	}
	return forandarVersion;
}

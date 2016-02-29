import 'dart:async';
import 'dart:io';

import 'package:args/args.dart';
import 'package:yaml/yaml.dart';

import 'package:forandar/exception/forandar_cli.dart';

VirtualMachine forth;

main(List<String> args) async {

	/// Creates the Forth [VirtualMachine].
	forth = new VirtualMachine(input: new InputQueueCli(), args: args, argParser: argParser);

	/// Includes the primitives dependent on the CLI interface.
	includeWordsCli(forth, forth.dict);

	/// Loads the source code.
	//
	// TEMP: Concatenates all the source code strings, files and URLs into a single string.
	//await forth.source.loadSourceCode(); // TODO FIXME

	/// Interprets the code in the input queue.
	//forth.dict.execNt(Nt.INTERPRET); // TODO FIXME

	/// Starts the interactive interpreter if BYE hasn't been called.
	forth.dict.execNt(Nt.BOOTMESSAGE);
	forth.dict.execNt(Nt.QUIT);
}

/// Parses the arguments from the command line.
///
/// Updates the default configuration in [c]. (TODO)
/// Fills the source code input queue in [i].
void argParser(List<String> args, Configuration c, InputQueue i) {

	ArgResults results;
	ArgParser p = new ArgParser(allowTrailingOptions: false);

	p
		..addSeparator('Usage: pub run forandar [options]')
	    ..addSeparator('Options:')

		/// Argument -e, --evaluate
		..addOption('evaluate', abbr: 'e',
			allowMultiple: true,
			splitCommas: false, // Must be false to preserve the commas (,) in string
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
				if (help) displayUsage(p);
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

	try {
		results = p.parse(args);
	} catch (e) {
		print(e);
		displayUsage(p);
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
	print(p.usage);
	exit(0);
}

/// Returns version from pubspec.yaml. Updates global the first time.
// TODO: not in use right now
Future<String> getVersion() async {
	if (forandarVersion == "FORANDAR_VERSION") {
		forandarVersion = await new File('pubspec.yaml').readAsString().then((String contents) {
			return loadYaml(contents)['version'];
		});
	}
	return forandarVersion;
}


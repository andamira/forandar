import 'package:forandar/core.dart';
import 'package:forandar/cli.dart';

main() async {

	// TEMP: List all files in the current directory in UNIX-like operating systems.
	ProcessResult results = await Process.run('ls', ['-l']);
	print(results.stdout);
}


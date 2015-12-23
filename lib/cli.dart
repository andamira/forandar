library cli;

import 'dart:async';
import 'dart:io';

import 'package:forandar/forandar.dart';
export 'package:forandar/forandar.dart';

part 'cli/words.dart';

// TODO:
// - load forandar version from here
// - define CLI class, and common methods

// The input queue for the CLI interface.↩
class InputQueueCli extends InputQueue {

	@override
	Future<String> loadFile(String f) async {

		var contents = await new File(f).readAsString();
		return contents;
	}
}


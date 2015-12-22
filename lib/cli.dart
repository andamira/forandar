library cli;

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
	void loadFile() {
		print("TODO loading file."); // TEMP
	}
}


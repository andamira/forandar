library web;

import 'dart:html';
import 'dart:js';

import 'package:forandar/forandar.dart';
export 'package:forandar/forandar.dart';

part 'web/words.dart';

// TODO:
// - define WEB class, with common methods
// - sublibraries:: canvas, dom, svg, js-interop

// The input queue for the Web interface.↩
class InputQueueWeb extends InputQueue {

	@override
	void loadUrl() {
		print("TODO loading URL."); // TEMP
	}
}


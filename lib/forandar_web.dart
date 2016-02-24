library forandar_web;

import 'forandar.dart';
//import 'src/util.dart' as util;

export 'forandar.dart';

part 'src/web/primitives.dart';

// TODO:
// - define WEB class, with common methods
// - sublibraries:: canvas, dom, svg, js-interop

// The input queue for the Web interface.
class InputQueueWeb extends InputQueue {

	@override
	String loadUrl(String u) {
		// TODO
		return "";
	}
}


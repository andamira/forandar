library forandar_web.exception;

// Core
import 'package:forandar/src/core/input.dart';

// Core Exception
export 'package:forandar/exception/forandar.dart';
export 'package:forandar/src/web/exception/primitives.dart';

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


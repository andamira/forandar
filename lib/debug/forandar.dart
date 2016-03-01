/// Core functionality of the Forth Virtual Machine, with debugging.
library forandar.core.debug;

// Core
export 'package:forandar/src/core/configuration.dart';
export 'package:forandar/src/core/data_space.dart';
export 'package:forandar/src/core/dictionary.dart';
export 'package:forandar/src/core/errors.dart';
export 'package:forandar/src/core/globals.dart';
export 'package:forandar/src/core/input.dart';
export 'package:forandar/src/core/nt_primitives.dart';
export 'package:forandar/src/core/object_space.dart';
export 'package:forandar/src/core/utility.dart';
export 'package:forandar/src/core/word.dart';

// Core Debug
export 'package:forandar/src/core/debug/primitives.dart';
export 'package:forandar/src/core/debug/stack.dart';
export 'package:forandar/src/core/debug/virtual_machine.dart';

/// The version of this library.
///
/// This placeholder must be filled by the implementation.
String forandarVersion = 'FORANDAR_VERSION';

void main() {}

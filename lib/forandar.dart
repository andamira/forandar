/// Core functionality of the Forth Virtual Machine.
library forandar;

import 'dart:collection';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'src/core/configuration.dart';
import 'src/util.dart' as util;

export 'src/core/configuration.dart';

part 'src/core/errors.dart';
part 'src/core/dict/dictionary.dart';
part 'src/core/dict/nt_enum.dart';
part 'src/core/dict/primitives.dart';
part 'src/core/input.dart';
part 'src/core/space/data.dart';
part 'src/core/space/object.dart';
part 'src/core/stack.dart';
part 'src/core/vm.dart';

/// The version of this library.
///
/// This placeholder must be filled by the implementation.
String forandarVersion = 'FORANDAR_VERSION';

void main() {}


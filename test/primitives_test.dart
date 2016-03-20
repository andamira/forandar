library forandar.core.primitives_test;

import "package:test/test.dart";

import "package:forandar/src/core/virtual_machine.dart";
import "package:forandar/src/core/primitives.dart";

void main() {

  VirtualMachine vm = new VirtualMachine(loadPrimitives: false);
  Primitives p;

  /// Tests the [Primitives].
  group("[Primitives]", () {

    test("Constructor", () {
      p = new Primitives(vm);
      expect(p, isNotNull);
    });

    test("load()", () {
      expect(p.load(), isNull);
    });

  });
}

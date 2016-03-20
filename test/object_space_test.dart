library forandar.core.object_space_test;

import "package:test/test.dart";

import "package:forandar/src/core/object_space.dart";

void main() {

  ObjectSpace o;

  /// Tests the [ObjectSpace] class.
  group("[ObjectSpace]", () {

    test("Constructor", () {
      o = new ObjectSpace();
      expect(o, isNotNull);
    });

    test("Constructor (singleton test)", () {
      expect(o.hashCode, equals(new ObjectSpace().hashCode));
    });

    test("length", () {
      expect(o.length, greaterThanOrEqualTo(0));
    });

    test("pointer", () {
      expect(o.pointer, equals(0));
    });

  });
}

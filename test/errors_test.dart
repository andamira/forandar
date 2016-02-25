library forandar.core.errors_test;

import "package:test/test.dart";

import "package:forandar/src/core/errors.dart";

void main() {

	ForthError e; 

	/// Tests the [ForthError] class.
	group("[ForthError]", () {

		test("Constructor", () {
			e = new ForthError(-1, "");
			expect(e, isNotNull);
		});

		test("toString()", () {
			expect(e.toString(), contains("ABORT"));
		});

		test("preMsg & postMsg parameters", () {
			expect(
				new ForthError(-2, "XY", "ZW").toString(),
				equals('Error -2: XY ABORT" ZW'));
		});

		test("throwError()", () {
			// Just verify that the function doesn't fail.
			expect(throwError(-4095), isNull);
		});

	});
}

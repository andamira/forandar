library forandar.core.errors_test;

import "package:test/test.dart";

import "package:forandar/src/core/errors.dart";

void main() {

	ForthError e; 

	/// Tests the [ForthError] class.
	group("[ForthError]", () {

		test("Constructor", () {
			e = new ForthError(-1);
			expect(e, isNotNull);
		});

		test("toString()", () {
			expect(e.toString(), contains("ABORT"));
		});

		test("preMsg & postMsg parameters", () {
			expect(
				new ForthError(-2, preMsg: "XY", postMsg: "ZW").toString(),
				allOf(
					startsWith('Error -2: XY'),
					endsWith('ZW'))
				);
		});

		test("ForthError.unmanaged()", () {
			String s = "XYZ25";
			expect(ForthError.unmanaged(s), allOf(
				startsWith("UNMANAGED ERROR"),
				contains(s),
				contains("package:")
			));
		});

		group("Standard:", () {

			for (int i = -1; i>=-79; i--) {

				test("$i", () {
					expect(new ForthError(i).toString(), startsWith("Error $i: "));	
				});
			}

		});

		group("Custom:", () {

			for (int i = -256; i>=-257; i--) {

				test("$i", () {
					expect(new ForthError(i).toString(), startsWith("Error $i: "));	
				});
			}

		});
	});
}

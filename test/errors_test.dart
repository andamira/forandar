library forandar.core.errors_test;

import "package:test/test.dart";

import "package:forandar/src/core/errors.dart";
import "package:forandar/src/core/stack.dart";

void main() {

	ForthError fe;

	/// Tests the [ForthError] class.
	group("[ForthError]", () {

		test("Constructor", () {
			fe = new ForthError(-1);
			expect(fe, isNotNull);
		});

		group("Constructor", () {
			test("stackOverflow", () {
				try {
					new ForthError.stackOverflow(StackType.dataStack);
				} catch(e) { fe = e; }
				expect(fe.number, equals(-3));
			});

			test("stackUnderflow", () {
				try {
					new ForthError.stackUnderflow(StackType.dataStack);
				} catch(e) { fe = e; }
				expect(fe.number, equals(-4));
			});
		});

		test("toString()", () {
			fe = new ForthError(-1);
			expect(fe.toString(), contains("ABORT"));
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
					expect(new ForthError(i).number, equals(i));
				});
			}

		});

		group("Custom:", () {

			for (int i = -256; i>=-257; i--) {

				test("$i", () {
					expect(new ForthError(i).number, equals(i));
				});
			}

		});
	});
}

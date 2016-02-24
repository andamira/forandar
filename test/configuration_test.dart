library forandar.core.configuration_test;

import "package:test/test.dart";

import "package:forandar/forandar.dart";

void main() {

	Configuration c;

	/// Tests the [Configuration] class.
	group("Configuration", () {

		test("Constructor", () {
			c = new Configuration();
			expect(c, isNotNull);
		});

		test("Constructor (singleton test)", () {
			expect(c.hashCode, equals(new Configuration().hashCode));
		});

		group("Option:", () {
			test("dataStackSize", () {
				expect(c.option['dataStackSize'], greaterThan(31));
			});

			test("floatStackSize", () {
				expect(c.option['dataStackSize'], greaterThan(5));
			});

			test("returnStackSize", () {
				expect(c.option['returnStackSize'], greaterThan(5));
			});

			test("controlStackSize", () {
				expect(c.option['controlStackSize'], greaterThan(5));
			});

			test("dataSpaceSize", () {
				expect(c.option['dataSpaceSize'], greaterThan(minDataSpaceSize));
			});

		});
	});
}

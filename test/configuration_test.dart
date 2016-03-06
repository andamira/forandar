library forandar.core.configuration_test;

import "package:test/test.dart";

import "package:forandar/src/core/configuration.dart";
import "package:forandar/src/core/globals.dart";

void main() {

	Configuration c;

	/// Tests the [Configuration] class.
	group("[Configuration]", () {

		test("Constructor", () {
			c = new Configuration();
			expect(c, isNotNull);
		});

		group("Option:", () {
			test("dataStackSize", () {
				expect(c.getOption('dataStackSize'), greaterThan(31));
			});

			test("floatStackSize", () {
				expect(c.getOption('floatStackSize'), greaterThan(5));
			});

			test("returnStackSize", () {
				expect(c.getOption('returnStackSize'), greaterThan(5));
			});

			test("controlStackSize", () {
				expect(c.getOption('controlStackSize'), greaterThan(5));
			});

			test("dataSpaceSize", () {
				expect(c.getOption('dataSpaceSize'), greaterThan(minDataSpaceSize));
			});

		});
	});
}

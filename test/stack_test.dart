import "package:test/test.dart";

import "package:forandar/forandar.dart";

void main() {

	// TODO

	group("String", () {

		test("String.split() splits the string on the delimiter", () {
			var string = "foo,bar,baz";
			expect(string.split(","), equals(["foo", "bar", "baz"]));
		});

		test("String.trim() removes surrounding whitespace", () {
			var string = "	foo ";
			expect(string.trim(), equals("foo"));
		});

	});
}

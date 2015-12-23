import "package:test/test.dart";

import "package:forandar/forandar.dart";

void main() {

	/// Tests the [Stack] methods
	group("Stack", () {

		LifoStack s;

		test("Constructor Lifostack()", () {
			s = new LifoStack(256);
			expect(s.content(), equals([ ]));
		});

		test("replace()", () {
			s.replace([10, 23, 4]);
			expect(s.content(), equals([10, 23, 4]));
		});

		test("clear()", () {
			s.clear();
			expect(s.content(), equals([ ]));
		});

		test("push()", () {
			s.push(82);
			s.push(25);
			s.push(11);
			s.push(3);
			s.push(60);
			expect(s.content(), equals([82, 25, 11, 3, 60]));
		});

		test("pop()", () {
			expect(s.pop(), equals(60));
		});

		test("dup()", () {
			s.dup();
			expect(s.content(), equals([82,25,11,3,3]));
		});

		test("drop()", () {
			s.drop();
			expect(s.content(), equals([82,25,11,3]));
		});

		test("nip()", () {
			s.nip();
			expect(s.content(), equals([82,25,3]));
		});

		test("over()", () {
			s.over();
			expect(s.content(), equals([82,25,3,25]));
		});

		test("peek() return value", () {
			expect(s.peek(), equals(25));
		});

		test("peek() stack status", () {
			expect(s.content(), equals([82,25,3,25]));
		});

		test("swap()", () {
			s.swap();
			expect(s.content(), equals([82,25,25,3]));
		});

		test("tuck()", () {
			s.tuck();
			expect(s.content(), equals([82,25,3,25,3]));
		});

		// TODO

	/*
		test("rot()", () {
			s.rot();
			expect(s.content(), equals([]));
		});

		test("rotCC()", () {
			s.rotCC();
			expect(s.content(), equals([]));
		});

		test("pick()", () {
			s.pick(3);
			expect(s.content(), equals([]));
		});

		test("()", () {
			expect(s.content(), equals([]));
		});


		test("roll()", () {
			s.roll(4);
			expect(s.content(), equals([]));
		});

	*/

		group("2X", () {

			test("drop2()", () {
				s.replace([1,2,3]);
				s.drop2();
				expect(s.content(), equals([1]));
			});

			test("dup2()", () {
				s.replace([1,2,3]);
				s.dup2();
				expect(s.content(), equals([1,2,3,2,3]));
			});

		});

	});

}

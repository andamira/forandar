library forandar.core.stack_test;

import "package:test/test.dart";

import "package:forandar/src/core/stack.dart";

void main() {

	LifoStack s;

	// TODO: Test the errors.

	/// Tests the [Stack] class.
	group("LifoStackInt", () {

		test("Constructor", () {
			s = new LifoStackInt(32);
			expect(s, isNotNull);
		});

		test("content()", () {
			expect(s.content(), equals([ ]));
		});

		test("replace()", () {
			s.replace([10, -23, 4]);
			expect(s.content(), equals([10, -23, 4]));
		});

		test("size", () {
			expect(s.size, equals(3));
		});

		test("toString()", () {
			expect(s.toString(), equals("<3> [10, -23, 4]"));
		});


		test("clear()", () {
			s.clear();
			expect(s.content(), equals([ ]));
		});

		test("push(n)", () {
			s.clear();
			s.push(82);
			s.push(0);
			s.push(-25);
			expect(s.content(), equals([82, 0, -25]));
		});

		test("pop() return value", () {
			s.replace([1, 2, 3]);
			expect(s.pop(), equals(3));
		});

		test("pop() stack effect", () {
			s.replace([1, 2, 3]);
			s.pop();
			expect(s.content(), equals([1, 2]));
		});

		test("dup()", () {
			s.replace([1]);
			s.dup();
			expect(s.content(), equals([1, 1]));
		});

		test("dup2()", () {
			s.replace([1, 2]);
			s.dup2();
			expect(s.content(), equals([1, 2, 1, 2]));
		});

		test("drop()", () {
			s.replace([1, 2]);
			s.drop();
			expect(s.content(), equals([1]));
		});

		test("drop2()", () {
			s.replace([1, 2, 3]);
			s.drop2();
			expect(s.content(), equals([1]));
		});

		test("nip()", () {
			s.replace([1, 2, 3]);
			s.nip();
			expect(s.content(), equals([1, 3]));
		});

		test("over()", () {
			s.replace([1, 2, 3]);
			s.over();
			expect(s.content(), equals([1, 2, 3, 2]));
		});

		test("over2()", () {
			s.replace([1, 2, 3, 4, 5]);
			s.over2();
			expect(s.content(), equals([1, 2, 3, 4, 5, 2, 3]));
		});

		test("peek() return value", () {
			s.replace([1, 2]);
			expect(s.peek(), equals(2));
		});

		test("peek() stack effect", () {
			s.replace([1, 2]);
			s.peek();
			expect(s.content(), equals([1, 2]));
		});

		test("peekNOS() return value", () {
			s.replace([1, 2, 3]);
			expect(s.peekNOS(), equals(2));
		});

		test("peekNOS() stack effect", () {
			s.replace([1, 2, 3]);
			s.peekNOS();
			expect(s.content(), equals([1, 2, 3]));
		});

		test("pick(n)", () {
			s.replace([1, 2, 3, 4]);
			s.pick(2);
			expect(s.content(), equals([1, 2, 3, 4, 2]));
		});

		test("swap()", () {
			s.replace([1, 2, 3]);
			s.swap();
			expect(s.content(), equals([1, 3, 2]));
		});

		test("swap2()", () {
			s.replace([1, 2, 3, 4, 5]);
			s.swap2();
			expect(s.content(), equals([1, 4, 5, 2, 3]));
		});

		test("tuck()", () {
			s.replace([1, 2, 3]);
			s.tuck();
			expect(s.content(), equals([1, 3, 2, 3]));
		});

		test("rot()", () {
			s.replace([1, 2, 3, 4]);
			s.rot();
			expect(s.content(), equals([1, 3, 4, 2]));
		});

		test("rotCC()", () {
			s.replace([1, 2, 3, 4]);
			s.rotCC();
			expect(s.content(), equals([1, 4, 2, 3]));
		});

		test("roll(n)", () {
			s.replace([1, 2, 3, 4, 5]);
			s.roll(3);
			expect(s.content(), equals([1, 3, 4, 5, 2]));
		});
	});

	group("LifoStackFloat", () {

		test("Constructor", () {
			s = new LifoStackFloat(32);
			expect(s.content(), equals([ ]));
		});

		test("replace()", () {
			s.replace([10.2, -23.0, 4.0]);
			expect(s.content(), equals([10.2, -23.0, 4.0]));
		});

		test("size", () {
			expect(s.size, equals(3));
		});

		test("toString()", () {
			expect(s.toString(), equals("<3> [10.2, -23.0, 4.0]"));
		});

		test("clear()", () {
			s.clear();
			expect(s.content(), equals([ ]));
		});

		test("push()", () {
			s.clear();
			s.push(82.0);
			s.push(0.0);
			s.push(-25.0);
			expect(s.content(), equals([82.0, 0.0, -25.0]));
		});

		test("pop() return value", () {
			s.replace([1.0, 2.0, 3.0]);
			expect(s.pop(), equals(3.0));
		});

		test("pop() stack effect", () {
			s.replace([1.0, 2.0, 3.0]);
			s.pop();
			expect(s.content(), equals([1.0, 2.0]));
		});

		test("dup()", () {
			s.replace([1.0]);
			s.dup();
			expect(s.content(), equals([1.0, 1.0]));
		});

		test("dup2()", () {
			s.replace([1.0, 2.0]);
			s.dup2();
			expect(s.content(), equals([1.0, 2.0, 1.0, 2.0]));
		});

		test("drop()", () {
			s.replace([1.0, 2.0]);
			s.drop();
			expect(s.content(), equals([1.0]));
		});

		test("drop2()", () {
			s.replace([1.0, 2.0, 3.0]);
			s.drop2();
			expect(s.content(), equals([1.0]));
		});

		test("nip()", () {
			s.replace([1.0, 2.0, 3.0]);
			s.nip();
			expect(s.content(), equals([1.0, 3.0]));
		});

		test("over()", () {
			s.replace([1.0, 2.0, 3.0]);
			s.over();
			expect(s.content(), equals([1.0, 2.0, 3.0, 2.0]));
		});

		test("over2()", () {
			s.replace([1.0, 2.0, 3.0, 4.0, 5.0]);
			s.over2();
			expect(s.content(), equals([1.0, 2.0, 3.0, 4.0, 5.0, 2.0, 3.0]));
		});

		test("peek() return value", () {
			s.replace([1.0, 2.0]);
			expect(s.peek(), equals(2.0));
		});

		test("peek() stack effect", () {
			s.replace([1.0, 2.0]);
			s.peek();
			expect(s.content(), equals([1.0, 2.0]));
		});

		test("peekNOS() return value", () {
			s.replace([1.0, 2.0, 3.0]);
			expect(s.peekNOS(), equals(2.0));
		});

		test("peekNOS() stack effect", () {
			s.replace([1.0, 2.0, 3.0]);
			s.peekNOS();
			expect(s.content(), equals([1.0, 2.0, 3.0]));
		});

		test("pick(n)", () {
			s.replace([1.0, 2.0, 3.0, 4.0]);
			s.pick(2);
			expect(s.content(), equals([1.0, 2.0, 3.0, 4.0, 2.0]));
		});

		test("swap()", () {
			s.replace([1.0, 2.0, 3.0]);
			s.swap();
			expect(s.content(), equals([1.0, 3.0, 2.0]));
		});

		test("swap2()", () {
			s.replace([1.0, 2.0, 3.0, 4.0, 5.0]);
			s.swap2();
			expect(s.content(), equals([1.0, 4.0, 5.0, 2.0, 3.0]));
		});

		test("tuck()", () {
			s.replace([1.0, 2.0, 3.0]);
			s.tuck();
			expect(s.content(), equals([1.0, 3.0, 2.0, 3.0]));
		});

		test("rot()", () {
			s.replace([1.0, 2.0, 3.0, 4.0]);
			s.rot();
			expect(s.content(), equals([1.0, 3.0, 4.0, 2.0]));
		});

		test("rotCC()", () {
			s.replace([1.0, 2.0, 3.0, 4.0]);
			s.rotCC();
			expect(s.content(), equals([1.0, 4.0, 2.0, 3.0]));
		});

		test("roll(n)", () {
			s.replace([1.0, 2.0, 3.0, 4.0, 5.0]);
			s.roll(3);
			expect(s.content(), equals([1.0, 3.0, 4.0, 5.0, 2.0]));
		});
	});
}

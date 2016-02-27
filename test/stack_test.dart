library forandar.core.stack_test;

import "package:test/test.dart";

import "package:forandar/src/core/stack.dart";

void main() {

	LifoStack s;  // unknown stack
	LifoStack ds; // dataStack
	LifoStack fs; // floatStack
	const int dsMaxSize = 7;
	const int fsMaxSize = 7;

	// TODO: Test all the overflow & underflow errors.
	// TODO: Test the int and double limits.

	/// Tests the [Stack] class.
	group("[Stack]", () {

		group("int:", () {

			test("Constructor", () {
				s = new LifoStackInt(100);
				expect(s, isNotNull);
			});

			test("Constructor (unknown)", () {
				s = new LifoStackInt(100);
				expect(s.type, equals(StackType.unknown));
			});

			test("Constructor (dataStack)", () {
				ds = new LifoStackInt(dsMaxSize, StackType.dataStack);
				expect(ds.type, equals(StackType.dataStack));
			});

			test("content()", () {
				expect(ds.content(), equals([ ]));
			});

			test("replace()", () {
				ds.replace([10, -23, 4]);
				expect(ds.content(), equals([10, -23, 4]));
			});

			test("size", () {
				expect(ds.size, equals(3));
			});

			test("toString()", () {
				expect(ds.toString(), equals("<3> [10, -23, 4]"));
			});


			test("clear()", () {
				ds.clear();
				expect(ds.content(), equals([ ]));
			});

			test("push(n)", () {
				ds.clear();
				ds.push(82); ds.push(0); ds.push(-25);
				expect(ds.content(), equals([82, 0, -25]));
			});

			test("push(n) overflow", () {
				ds.clear();
				var error;
				try {
					for (int i = 0; i <= dsMaxSize; i++) {
						ds.push(i);
					}
				} catch(e) { error = e; }
				expect(error.number, equals(-3));
			});

			test("pushList(List<n>)", () {
				s.clear();
				s.pushList([83, 0, -24]);
				expect(s.content(), equals([83, 0, -24]));
			});

			test("pushList(List<n>) overflow", () {
				ds.clear();
				var error;
				try { ds.pushList([0, 1, 2, 3, 4, 5, 6, 7]); }
				catch(e) { error = e; }
				expect(error.number, equals(-3));
			});

			test("pop() return value", () {
				ds.replace([1, 2, 3]);
				expect(ds.pop(), equals(3));
			});

			test("pop() stack effect", () {
				ds.replace([1, 2, 3]);
				ds.pop();
				expect(ds.content(), equals([1, 2]));
			});

			test("dup()", () {
				ds.replace([1]);
				ds.dup();
				expect(ds.content(), equals([1, 1]));
			});

			test("dup2()", () {
				ds.replace([1, 2]);
				ds.dup2();
				expect(ds.content(), equals([1, 2, 1, 2]));
			});

			test("drop()", () {
				ds.replace([1, 2]);
				ds.drop();
				expect(ds.content(), equals([1]));
			});

			test("drop2()", () {
				ds.replace([1, 2, 3]);
				ds.drop2();
				expect(ds.content(), equals([1]));
			});

			test("nip()", () {
				ds.replace([1, 2, 3]);
				ds.nip();
				expect(ds.content(), equals([1, 3]));
			});

			test("over()", () {
				ds.replace([1, 2, 3]);
				ds.over();
				expect(ds.content(), equals([1, 2, 3, 2]));
			});

			test("over2()", () {
				ds.replace([1, 2, 3, 4, 5]);
				ds.over2();
				expect(ds.content(), equals([1, 2, 3, 4, 5, 2, 3]));
			});

			test("peek() return value", () {
				ds.replace([1, 2]);
				expect(ds.peek(), equals(2));
			});

			test("peek() stack effect", () {
				ds.replace([1, 2]);
				ds.peek();
				expect(ds.content(), equals([1, 2]));
			});

			test("peekNOS() return value", () {
				ds.replace([1, 2, 3]);
				expect(ds.peekNOS(), equals(2));
			});

			test("peekNOS() stack effect", () {
				ds.replace([1, 2, 3]);
				ds.peekNOS();
				expect(ds.content(), equals([1, 2, 3]));
			});

			test("pick(n)", () {
				ds.replace([1, 2, 3, 4]);
				ds.pick(2);
				expect(ds.content(), equals([1, 2, 3, 4, 2]));
			});

			test("swap()", () {
				ds.replace([1, 2, 3]);
				ds.swap();
				expect(ds.content(), equals([1, 3, 2]));
			});

			test("swap2()", () {
				ds.replace([1, 2, 3, 4, 5]);
				ds.swap2();
				expect(ds.content(), equals([1, 4, 5, 2, 3]));
			});

			test("tuck()", () {
				ds.replace([1, 2, 3]);
				ds.tuck();
				expect(ds.content(), equals([1, 3, 2, 3]));
			});

			test("rot()", () {
				ds.replace([1, 2, 3, 4]);
				ds.rot();
				expect(ds.content(), equals([1, 3, 4, 2]));
			});

			test("rotCC()", () {
				ds.replace([1, 2, 3, 4]);
				ds.rotCC();
				expect(ds.content(), equals([1, 4, 2, 3]));
			});

			test("roll(n)", () {
				ds.replace([1, 2, 3, 4, 5]);
				ds.roll(3);
				expect(ds.content(), equals([1, 3, 4, 5, 2]));
			});

		});

		group("float:", () {

			test("Constructor", () {
				fs = new LifoStackFloat(7, StackType.floatStack);
				expect(fs.content(), equals([ ]));
			});

			test("replace()", () {
				fs.replace([10.2, -23.0, 4.0]);
				expect(fs.content(), equals([10.2, -23.0, 4.0]));
			});

			test("size", () {
				expect(fs.size, equals(3));
			});

			test("toString()", () {
				expect(fs.toString(), equals("<3> [10.2, -23.0, 4.0]"));
			});

			test("clear()", () {
				fs.clear();
				expect(fs.content(), equals([ ]));
			});

			test("push()", () {
				fs.clear();
				fs.push(82.0);
				fs.push(0.0);
				fs.push(-25.0);
				expect(fs.content(), equals([82.0, 0.0, -25.0]));
			});

			test("push(n) overflow", () {
				fs.clear();
				var error;
				try {
					for (int i = 0; i <= fsMaxSize; i++) {
						fs.push(0.0 + i);
					}
				} catch(e) { error = e; }
				expect(error.number, equals(-44));
			});

			test("pushList(List<n>)", () {
				fs.clear();
				fs.pushList([83.0, 0.1, -24.0]);
				expect(fs.content(), equals([83.0, 0.1, -24.0]));
			});

			test("pushList(List<n>) overflow", () {
				fs.clear();
				var error;
				try { fs.pushList([0.0, 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0]); }
				catch(e) { error = e; }
				expect(error.number, equals(-44));
			});


			test("pop() return value", () {
				fs.replace([1.0, 2.0, 3.0]);
				expect(fs.pop(), equals(3.0));
			});

			test("pop() stack effect", () {
				fs.replace([1.0, 2.0, 3.0]);
				fs.pop();
				expect(fs.content(), equals([1.0, 2.0]));
			});

			test("pop() stack underflow", () {
				fs.clear();
				var error;
				try { fs.pop(); } catch(e) { error = e; }
				expect(error.number, equals(-45));
			});

			test("dup()", () {
				fs.replace([1.0]);
				fs.dup();
				expect(fs.content(), equals([1.0, 1.0]));
			});

			test("dup2()", () {
				fs.replace([1.0, 2.0]);
				fs.dup2();
				expect(fs.content(), equals([1.0, 2.0, 1.0, 2.0]));
			});

			test("drop()", () {
				fs.replace([1.0, 2.0]);
				fs.drop();
				expect(fs.content(), equals([1.0]));
			});

			test("drop2()", () {
				fs.replace([1.0, 2.0, 3.0]);
				fs.drop2();
				expect(fs.content(), equals([1.0]));
			});

			test("nip()", () {
				fs.replace([1.0, 2.0, 3.0]);
				fs.nip();
				expect(fs.content(), equals([1.0, 3.0]));
			});

			test("over()", () {
				fs.replace([1.0, 2.0, 3.0]);
				fs.over();
				expect(fs.content(), equals([1.0, 2.0, 3.0, 2.0]));
			});

			test("over2()", () {
				fs.replace([1.0, 2.0, 3.0, 4.0, 5.0]);
				fs.over2();
				expect(fs.content(), equals([1.0, 2.0, 3.0, 4.0, 5.0, 2.0, 3.0]));
			});

			test("peek() return value", () {
				fs.replace([1.0, 2.0]);
				expect(fs.peek(), equals(2.0));
			});

			test("peek() stack effect", () {
				fs.replace([1.0, 2.0]);
				fs.peek();
				expect(fs.content(), equals([1.0, 2.0]));
			});

			test("peekNOS() return value", () {
				fs.replace([1.0, 2.0, 3.0]);
				expect(fs.peekNOS(), equals(2.0));
			});

			test("peekNOS() stack effect", () {
				fs.replace([1.0, 2.0, 3.0]);
				fs.peekNOS();
				expect(fs.content(), equals([1.0, 2.0, 3.0]));
			});

			test("pick(n)", () {
				fs.replace([1.0, 2.0, 3.0, 4.0]);
				fs.pick(2);
				expect(fs.content(), equals([1.0, 2.0, 3.0, 4.0, 2.0]));
			});

			test("swap()", () {
				fs.replace([1.0, 2.0, 3.0]);
				fs.swap();
				expect(fs.content(), equals([1.0, 3.0, 2.0]));
			});

			test("swap2()", () {
				fs.replace([1.0, 2.0, 3.0, 4.0, 5.0]);
				fs.swap2();
				expect(fs.content(), equals([1.0, 4.0, 5.0, 2.0, 3.0]));
			});

			test("tuck()", () {
				fs.replace([1.0, 2.0, 3.0]);
				fs.tuck();
				expect(fs.content(), equals([1.0, 3.0, 2.0, 3.0]));
			});

			test("rot()", () {
				fs.replace([1.0, 2.0, 3.0, 4.0]);
				fs.rot();
				expect(fs.content(), equals([1.0, 3.0, 4.0, 2.0]));
			});

			test("rotCC()", () {
				fs.replace([1.0, 2.0, 3.0, 4.0]);
				fs.rotCC();
				expect(fs.content(), equals([1.0, 4.0, 2.0, 3.0]));
			});

			test("roll(n)", () {
				fs.replace([1.0, 2.0, 3.0, 4.0, 5.0]);
				fs.roll(3);
				expect(fs.content(), equals([1.0, 3.0, 4.0, 5.0, 2.0]));
			});
		});

	});
}

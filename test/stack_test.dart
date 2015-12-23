import "package:test/test.dart";

import "package:forandar/forandar.dart";

void main() {

	/// Tests the [Stack] methods
	group("Stack", () {

		LifoStack s;

		test("Constructor Lifostack()", () {
			s = new LifoStack(256);
			expect(s.Content(), equals([ ]));
		});

		test("Replace()", () {
			s.Replace([10, 23, 4]);
			expect(s.Content(), equals([10, 23, 4]));
		});

		test("Clear()", () {
			s.Clear();
			expect(s.Content(), equals([ ]));
		});

		test("Push()", () {
			s.Push(82);
			s.Push(25);
			s.Push(11);
			s.Push(3);
			s.Push(60);
			expect(s.Content(), equals([82, 25, 11, 3, 60]));
		});

		test("Pop()", () {
			expect(s.Pop(), equals(60));
		});

		test("Dup()", () {
			s.Dup();
			expect(s.Content(), equals([82,25,11,3,3]));
		});

		test("Drop()", () {
			s.Drop();
			expect(s.Content(), equals([82,25,11,3]));
		});

		test("Nip()", () {
			s.Nip();
			expect(s.Content(), equals([82,25,3]));
		});

		test("Over()", () {
			s.Over();
			expect(s.Content(), equals([82,25,3,25]));
		});

		test("Peek() return value", () {
			expect(s.Peek(), equals(25));
		});

		test("Peek() stack status", () {
			expect(s.Content(), equals([82,25,3,25]));
		});

		test("Swap()", () {
			s.Swap();
			expect(s.Content(), equals([82,25,25,3]));
		});

		test("Tuck()", () {
			s.Tuck();
			expect(s.Content(), equals([82,25,3,25,3]));
		});

		// TODO

	/*
		test("Rot()", () {
			s.Rot();
			expect(s.Content(), equals([]));
		});

		test("RotCC()", () {
			s.RotCC();
			expect(s.Content(), equals([]));
		});

		test("Pick()", () {
			s.Pick(3);
			expect(s.Content(), equals([]));
		});

		test("()", () {
			expect(s.Content(), equals([]));
		});


		test("Roll()", () {
			s.Roll(4);
			expect(s.Content(), equals([]));
		});

	*/

		group("2X", () {

			test("Drop2()", () {
				s.Replace([1,2,3]);
				s.Drop2();
				expect(s.Content(), equals([1]));
			});

			test("Dup2()", () {
				s.Replace([1,2,3]);
				s.Dup2();
				expect(s.Content(), equals([1,2,3,2,3]));
			});

		});

	});

}

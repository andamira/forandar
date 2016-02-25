library forandar.core.data_space_test;

import "package:test/test.dart";

import "package:forandar/src/core/data_space.dart";
import "package:forandar/src/core/globals.dart";
import "package:forandar/src/core/utility.dart" as util;

void main() {

	DataSpace d;

	/// Tests the [DataSpace] class.
	group("DataSpace", () {

		test("Constructor", () {
			d = new DataSpace(512);
			expect(d, isNotNull);
		});

		test("Constructor (singleton test)", () {
			expect(d.hashCode, equals(new DataSpace(256).hashCode));
		});

		test("length", () {
			expect(d.length, greaterThanOrEqualTo(minDataSpaceSize));
		});

		test("pointer", () {
			expect(d.pointer, allOf(
					greaterThan(0),
					lessThan(minDataSpaceSize)
				));
		});

		test("storeChar() & fetchChar()", () {
			d.storeChar(100, 127);
			expect(d.fetchChar(100), equals(127));
		});

		test("storeChar() (overflow)", () {
			d.storeChar(100, 128);
			expect(d.fetchChar(100), equals(-128));
		});

		test("storeChar() (negative)", () {
			d.storeChar(100, -128);
			expect(d.fetchChar(100), equals(-128));
		});

		test("storeChar() (negative overflow)", () {
			d.storeChar(100, -129);
			expect(d.fetchChar(100), equals(127));
		});

		test("storeCell() & fetchCell()", () {
			d.storeCell(140, 16000);
			expect(d.fetchCell(140), equals(16000));
		});

		test("storeFloat() & fetchFloat()", () {
			d.storeFloat(100, 1234567890.1234567);
			expect(d.fetchFloat(100), equals(1234567890.1234567));
		});

		test("storeCharHere()", () {
			d.storeCharHere(-10);
			expect(d.fetchChar(d.pointer - 1), equals(-10));
		});

		test("storeCellHere()", () {
			d.storeCellHere(-6000);
			expect(d.fetchCell(d.pointer - cellSize), equals(-6000));
		});

		test("storeFloatHere()", () {
			d.storeFloatHere(-35000.075);
			expect(d.fetchFloat(d.pointer - floatSize), equals(-35000.075));
		});

		test("storeCharInc()", () {
			d.storeCharInc(100, 7);
			expect(d.fetchChar(100), equals(7));
		});

		test("storeCharInc() (inc. pointer)", () {
			int p = d.pointer;
			d.storeCharInc(100, 7);
			expect(d.pointer, equals(p + 1));
		});

		test("storeCellInc()", () {
			d.storeCellInc(100, 7777);
			expect(d.fetchCell(100), equals(7777));
		});

		test("storeCellInc() (inc. pointer)", () {
			int p = d.pointer;
			d.storeCellInc(100, 7777);
			expect(d.pointer, equals(p + cellSize));
		});

		test("storeFloatInc()", () {
			d.storeFloatInc(100, -7654321.98);
			expect(d.fetchFloat(100), equals(-7654321.98));
		});

		test("storeFloatInc() (inc. pointer)", () {
			int p = d.pointer;
			d.storeFloatInc(100, -7654321.98);
			expect(d.pointer, equals(p + floatSize));
		});

		test("storeString() & fetchString() (ASCII)", () {
			String s = "hello world";
			d.storeString(100, s);
			expect(d.fetchString(100, s.length), equals(s));
		});

		test("storeString() & fetchString() (UTF-8)", () {
			String s = "ĦêłŁø Ẁ↑®lð";
			d.storeString(100, s);
			expect(d.fetchString(100, util.UTF8StringSizeInBytes(s)), equals(s));
		});

		test("fillCharRange() & getCharRange()", () {
			d.fillCharRange(100, 10, 3);
			expect(d.getCharRange(100, 10), equals([3, 3, 3, 3, 3, 3, 3, 3, 3, 3]));
		});

		test("setCharRange()", () {
			d.setCharRange(100, [1, 2, 3, 4, 5, 6]);
			expect(d.getCharRange(100, 6), equals([1, 2, 3, 4, 5, 6]));
		});

		group("VARIABLE:", () {

			test("addrBASE", () {
				expect(d.fetchCell(addrBASE), equals(10));
			});

			test("addrSTATE", () {
				expect(d.fetchCell(addrSTATE), equals(flagFALSE));
			});

			test("addrToIN", () {
				expect(d.fetchCell(addrToIN), equals(flagFALSE));
			});
		});

	});
}

library forandar.core.dictionary_test;

import "package:test/test.dart";

import "package:forandar/src/core/dictionary.dart";
import "package:forandar/src/core/nt_primitives.dart";

void main() {

	Dictionary d;

	/// Tests the [Dictionary] class.
	group("[Dictionary]", () {

		test("Constructor", () {
			d = new Dictionary();
			expect(d, isNotNull);
		});

		test("Constructor (singleton test)", () {
			expect(d.hashCode, equals(new Dictionary().hashCode));
		});

		test("length", () {
			expect(d.length, equals(0));
		});

		test("addWordNope()", () {
			d.addWordNope("W1");
			expect(d.length, equals(1));
		});

		String s = "w1_result";

		test("addWord()", () {
			d.addWord("W2", () {
				return s;
			});
			expect(d.length, equals(2));
		});
	
		test("wordByName()", () {
			expect(d.wordByName("W2").name, equals('W2'));
		});
	
		test("words", () {
			expect(d.words, equals([d.wordByName('W2'), d.wordByName('W1')]));
		});

		test("lastWord", () {
			expect(d.lastWord, equals(d.wordByName('W2')));
		});

		test("execWord()", () {
			expect(d.execWord("W2"), equals(s));
		});

		test("addWord() (with optional parameters)", () {
			d.addWord("W3", () { return 33; }, nt: Nt.Store, immediate: true, compileOnly:true);
			expect(d.length, equals(3));
		});
	
		test("wordByNt()", () {
			expect(d.wordByNt(Nt.Store).name, equals('W3'));
		});

		test("addWordOver()", () {
			d.addWordOver("W1", () {});
			expect(d.length, equals(3));
		});

		test("addWordOver() fail", () {
			bool errored = false;
			try {
				// Should fail because the word hasn't been created yet.
				d.addWordOver("W8", () {});
			} catch(e) {
				errored = true;
			}
			expect(errored, isTrue);
		});

		test("addWordOver() & execWord()", () {
			d.addWordOver("W2", () => 22 );
			expect(d.execWord("W2"), equals(22));
		});
	
		test("execNt()", () {
			expect(d.execNt(Nt.Store), equals(33));
		});

		test("execNts()", () {
			d.addWord("W4", () => 44, nt: Nt.Fetch);
			d.addWord("W5", () => 55, nt: Nt.Minus);
			expect(d.execNts([Nt.Store, Nt.Fetch, Nt.Minus]), isNull);
		});

	});
}

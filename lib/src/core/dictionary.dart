library forandar.core.dictionary;

import 'dart:collection';

import 'errors.dart';
import 'nt_primitives.dart';
import 'primitives.dart';
import 'virtual_machine.dart';
import 'word.dart';

/// A searchable collection for all defined [Word]s.
///
/// Defines the primitives and contains both primitives and : words.
class Dictionary {

	/// List of [Word]s retrievable by the word's name.
	Map<String, Word> wordsMap = new SplayTreeMap();

	/// List of [Word]s retrievable by index.
	///
	/// Starting size is the number of reserved nt.
	List<Word> wordsList = new List()..length = Nt.values.length;

	/// Constants for the flags of the [Word].
	static const immediate      = true;
	static const compileOnly    = true;

	// Singleton constructor, allowing only one instance.
	factory Dictionary(VirtualMachine vm) {
		_instance ??= new Dictionary._internal(vm);
		return _instance;
	}
	static Dictionary _instance;

	/// Creates the dictionary and adds the primitives.
	///
	/// The majority of the words are defined in the file: core/words.dart.
	///
	/// The words whose implementation depends on the specific Dart interface
	/// are defined in the files: cli/dictionary.dart and web/dictionary.dart,
	/// and included from the corresponding implementations in: /bin and /web.
	Dictionary._internal(VirtualMachine vm) {

		// Must receive the Virtual Machine as an argument because its constructor
		// has not finished yet, and therefore the global variable forth is null.
		// The same things happens with this dictionary, and the following words:

		// Core.
		includeWordsStandardCore(vm, this);

		includeWordsNotStandardCore(vm, this);
		includeWordsNotStandardExtra(vm, this);

		// Optional Standard Sets.
		// -----------------------

		// Floats.
		includeWordsStandardOptionalFloat(vm, this);

		// Block.
		includeWordsStandardOptionalBlock(vm, this);

		// Tools.
		includeWordsStandardOptionalProgrammingTools(vm, this);
	}

	/// Adds a new word to this dictionary's [wordsMap] and [wordsList].
	addWord(String name, Function f, {Nt nt, bool immediate: false, bool compileOnly: false}) {
		name = name.toUpperCase();
		if (nt == null) {
			wordsList.add(new Word(immediate, compileOnly, f, name, wordsList.length));
			wordsMap[name] = wordsList.last;
		} else {
			wordsList[nt.index] = new Word(immediate, compileOnly, f, name, nt);
			wordsMap[name] = wordsList[nt.index];
		}
	}

	/// Adds a new word that does nothing at all (no operation).
	///
	/// A convenience wrapper for defining words with no behaviour
	/// in the current implementation, like ALIGN and ALIGNED.
	///
	/// Also useful for creating a placeholder that will be overriden
	/// by calling [addWordOver] from the specific interface libraries.
	addWordNope(String name, {Nt nt, bool immediate: false, bool compileOnly: false}) {
		addWord(name, (){}, nt: nt, immediate: immediate, compileOnly: compileOnly);
	}

	/// Adds a new word, overwriting a pre-existing same-name word.
	///
	/// This is inteded to be used only in conjunction with [addWordNope].
	addWordOver(String name, Function f, {bool immediate: false, bool compileOnly: false}) {
		name = name.toUpperCase();
		if (wordsMap.containsKey(name)) {
			int nt = wordsMap[name].nt;
			wordsList[nt] = new Word(immediate, compileOnly, f, name, nt);
			wordsMap[name] = wordsList[nt];
		} else {
			throwError(-2049, msg: name);
		}
	}

	/// Executes a word referenced by its nt.
	execNt(Nt nt) => wordsList[nt.index].exec();

	/// Executes a list of words referenced by their nt.
	execNts(List<Nt> nts) => nts.forEach( (nt) => wordsList[nt.index].exec());

	/// Executes a word referenced by its name.
	execWord(String wordName) => wordsMap[wordName].exec();
}


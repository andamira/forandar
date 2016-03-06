library forandar.core.dictionary;

import 'dart:collection';

// Core
import 'package:forandar/src/core/errors.dart';
import 'package:forandar/src/core/nt_primitives.dart';
import 'package:forandar/src/core/word.dart';

/// A searchable collection for all defined [Word]s.
///
/// Defines the primitives and contains both primitives and : words.
class Dictionary {

	/// Reference to the last defined word.
	Word _lastWord;

	/// List of [Word]s retrievable by the word's name.
	Map<String, Word> _wordsMap = new SplayTreeMap();

	/// List of [Word]s retrievable by index.
	///
	/// Starting size is the number of reserved nt.
	List<Word> _wordsList = new List()..length = Nt.values.length;

	/// Constants for the flags of the [Word].
//	static const immediate      = true;
//	static const compileOnly    = true;

	// Singleton constructor, allowing only one instance.
	factory Dictionary() {
		_instance ??= new Dictionary._internal();
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
	Dictionary._internal();

	/// Returns the number of [Word]s definitions.
	int get length => _wordsMap.length;

	/// Adds a new word to this dictionary's [_wordsMap] and [_wordsList].
	addWord(String name, Function f, {Nt nt, bool immediate: false, bool compileOnly: false}) {
		name = name.toUpperCase();
		if (nt == null) {
			_wordsList.add(new Word(immediate, compileOnly, f, name, _wordsList.length));
			_wordsMap[name] = _wordsList.last;
			_lastWord = _wordsList.last;
		} else {
			_wordsList[nt.index] = new Word(immediate, compileOnly, f, name, nt);
			_wordsMap[name] = _wordsList[nt.index];
			_lastWord = _wordsList[nt.index];
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
		if (_wordsMap.containsKey(name)) {
			int nt = _wordsMap[name].nt;
			_wordsList[nt] = new Word(immediate, compileOnly, f, name, nt);
			_wordsMap[name] = _wordsList[nt];
		} else {
			throw new ForthError(-257, postMsg: name);
		}
	}

	/// Executes a word referenced by its nt (as enum).
	execNt(Nt nt) => _wordsList[nt.index].exec();

	/// Executes a word referenced by its nt (as index).
	execNtIndex(int nt) => _wordsList[nt].exec();

	/// Executes a list of words referenced by their nt.
	execNts(List<Nt> nts) => nts.forEach( (nt) => _wordsList[nt.index].exec());

	/// Executes a word referenced by its name.
	execWord(String wordName) => _wordsMap[wordName].exec();

	/// Returns the last defined [Word].
	Word get lastWord => _lastWord;

	/// Returns a Word searching it by its name.
	Word wordByName(String name) => _wordsMap[name.toUpperCase()];

	/// Returns a Word searching it by its nt.
	Word wordByNt(Nt nt) => _wordsList[nt.index];

	/// Returns a list of all the words in the dictionary.
	List<Word> get words {
		List<Word> L = [];
		for (Word w in _wordsList.reversed) {
			// Makes sure the word isn't an empty reserved nt slot
			if (w != null) L.add(w);
		}
		return L;
	}
}

/// This version of the LifoStack class supports forth exception catching.
///
/// It turns out that the functions that  contain a try/catch block are not
/// optimized in the browsers javascript virtual machines.
///
/// Sources:
///
/// * [Optimization killers](https://github.com/petkaantonov/bluebird/wiki/Optimization-killers)
/// * [The V8 performance issue with try/catch](https://news.ycombinator.com/item?id=3797822)
///
/// I made some benchmarks in two different computers (A & B), calling 500 million times to
/// the push() function, with and without try/catch blocks. These are the results:
///
/// With try / catch:
/// ```
/// Dartium:  A:  5048 ms  B:  7980 ms
/// Firefox:  A:  6732 ms  B:  7500 ms
/// Chromium: A: 10837 ms  B: 25476 ms
/// ```
///
/// Without:
/// ```
/// Dartium:  A:  3196 ms  B: 15469 ms  => between  58% and  94% faster
/// Firefox:  A:  2867 ms  B:  3500 ms  => between 135% and 114% faster
/// Chromium: A:  5627 ms  B:  9052 ms  => between  93% and 181% faster
/// ```
///
library forandar.core.stack;

import 'dart:typed_data';

// Core
import 'package:forandar/src/core/errors.dart';
import 'package:forandar/src/core/globals.dart';

// Common
part 'package:forandar/src/core/common/stack.dart';

/// Last In First Out Stack Implementation.
abstract class LifoStack<T extends num> extends StackBase<T> implements LifoStackIface {

	LifoStack(maxSize, data, type) : super(maxSize, data, type);

	/// Removes the top stack item and discards it.
	///
	/// ( a b -- a )
	void drop() {
		try {
			_size--;
		} catch(e) {
			throw new ForthError.stackUnderflow(_type, e, 'drop');
		}
	}

	/// Removes the top 2 stack items and discards them.
	///
	/// ( a b c -- a )
	void drop2() {
		try {
			_size -= 2;
		} catch(e) {
			throw new ForthError.stackUnderflow(_type, e, 'drop2');
		}
	}

	/// Duplicates the top stack item.
	///
	/// ( a -- a a )
	void dup() {
		try {
			_data[_size] = _data[_size - 1]; _size++;
		} catch(e) {
			if (_size < 1) {
				throw new ForthError.stackUnderflow(_type, e, 'dup');
			} else {
				throw new ForthError.stackOverflow(_type, e, 'dup');
			}
		}
	}

	/// Duplicates the top stack pair of items
	///
	/// ( a b -- a b a b )
	void dup2() {
		try {
			_data[_size] = _data[_size - 2]; _size++;
			_data[_size] = _data[_size - 2]; _size++;
		} catch(e) {
			if (_size < 2) {
				throw new ForthError.stackUnderflow(_type, e, 'dup2');
			} else {
				throw new ForthError.stackOverflow(_type, e, 'dup2');
			}
		}
	}

	/// Drops the first item below the top of stack.
	///
	/// ( a b -- b )
	void nip() {
		try {
			_data[_size - 2] = _data[--_size];
		} catch(e) {
			throw new ForthError.stackUnderflow(_type, e, 'nip');
		}
	}

	/// Places a copy of a on top of the stack.
	///
	/// ( a b -- a b a )
	void over() {
		try {
			_data[_size] = _data[_size - 2]; _size++;
		} catch(e) {
			if (_size < 2) {
				throw new ForthError.stackUnderflow(_type, e, 'over');
			} else {
				throw new ForthError.stackOverflow(_type, e, 'over');
			}
		}
	}

	/// Places a copy of a b par on top of the stack.
	///
	/// ( a b c d -- c d a b )
	void over2() {
		try {
			_data[_size] = _data[_size - 4]; _size++;
			_data[_size] = _data[_size - 4]; _size++;
		} catch(e) {
			if (_size < 4) {
				throw new ForthError.stackUnderflow(_type, e, 'over2');
			} else {
				throw new ForthError.stackOverflow(_type, e, 'over2');
			}
		}
	}

	/// Returns the last stack item WITHOUT removing it.
	///
	/// ( a -- )
	T get peek {
		try {
			return _data[_size - 1];
		} catch(e) {
			throw new ForthError.stackUnderflow(_type, e, 'peek');
		}
	}

	/// Returns the Next Of Stack item WITHOUT removing it.
	///
	/// ( a -- )
	T get peekNOS {
		try {
			return _data[_size - 2];
		} catch(e) {
			throw new ForthError.stackUnderflow(_type, e, 'peekNOS');
		}
	}

	/// Copies i to the top of the stack.
	///
	/// Pick(0) is equivalent to Dup() and Pick(1) is equivalent to Over().
	/// ( a b c ... i -- i a b c ... i )
	void pick(int i) {
		try {
			_data[_size] = _data[_size - i - 1]; _size++;
		} catch(e) {
			if (_size < i + 1) {
				throw new ForthError.stackUnderflow(_type, e, 'pick($i)');
			} else {
				throw new ForthError.stackOverflow(_type, e, 'pick($i)');
			}
		}
	}

	/// Returns the last stack item.
	///
	/// ( a -- )
	T get pop {
		try {
			return _data[--_size];
		} catch(e) {
			throw new ForthError.stackUnderflow(_type, e, 'pop');
		}
	}

	/// Returns a list of i items from the top of the stack.
	///
	/// ( a b c ... i -- )
	List<T> popList(int i) {
		List<T> L = [];
		for (i; i > 0; i--) {
			L.insert(0, _data[--_size]);
		}
		return L;
	}

	/// Adds an additional stack item.
	///
	/// ( -- a )
	void push(T i) {
		try {
			_data[_size++] = i;
		} catch(e) {
			throw new ForthError.stackOverflow(_type, e, 'push($i)');
		}
	}

	/// Adds all the items from a List to the top of the stack.
	///
	/// ( -- a ... i )
	void pushList(List L) {
		try {
			L.forEach( (T i) {
				_data[_size] = i; _size++;
			});
		} catch(e) {
			throw new ForthError.stackOverflow(_type, e, 'pushList($L)');
		}
	}

	/// Rotates i+1 items on the top of the stack.
	///
	/// Roll(2) is equivalent to Rot() and Roll(1) is equivalent to Swap().
	/// ( a b c ... i --  )
	void roll(int i) {
		try {
			var t = _data.sublist(_size - i - 1, _size);
			for (int c = 1; c <= i; c++) {
				_data[_size - 2 - i + c] = t[c];
			}
			_data[_size - 1] = t[0];
		} catch(e) {
			throw new ForthError.stackUnderflow(_type, e, 'roll($i)');
		}
	}

	/// Rotates the top three stack entries.
	///
	/// ( a b c -- b c a )
	void rot() {
		try {
			var t = _data.sublist(_size - 3, _size);
			_data[_size - 1] = t[0];
			_data[_size - 2] = t[2];
			_data[_size - 3] = t[1];
		} catch(e) {
			throw new ForthError.stackUnderflow(_type, e, 'rot()');
		}
	}

	/// Rotates counter-clockwise the top three stack entries.
	///
	/// ( a b c -- c a b )
	void rotCC() {
		try {
			var t = _data.sublist(_size - 3, _size);
			_data[_size - 1] = t[1];
			_data[_size - 2] = t[0];
			_data[_size - 3] = t[2];
		} catch(e) {
			throw new ForthError.stackUnderflow(_type, e, 'rotcc()');
		}
	}

	/// Exchanges the top two stack items.
	///
	/// ( a b -- b a )
	void swap() {
		try {
			T t = _data[_size - 1];
			_data[_size - 1] = _data[_size - 2];
			_data[_size - 2] = t;
		} catch(e) {
			throw new ForthError.stackUnderflow(_type, e, 'swap()');
		}
	}

	/// Exchanges the top two stack number pairs.
	///
	/// ( a b c d -- c d a b )
	void swap2() {
		try {
			var t = _data.sublist(_size - 4, _size);
			_data[_size - 1] = t[1];
			_data[_size - 2] = t[0];
			_data[_size - 3] = t[3];
			_data[_size - 4] = t[2];
		} catch(e) {
			throw new ForthError.stackUnderflow(_type, e, 'swap2()');
		}
	}

	/// Copies the first (top) stack item below the second stack item.
	///
	/// ( a b -- b a b )
	void tuck() {
		try {
			_data[_size]     = _data[_size - 1];
			_data[_size - 1] = _data[_size - 2];
			_data[_size - 2] = _data[_size]; _size++;
		} catch(e) {
			if (_size < 2) {
				throw new ForthError.stackUnderflow(_type, e, 'tuck()');
			} else {
				throw new ForthError.stackOverflow(_type, e, 'tuck()');
			}
		}
	}
}

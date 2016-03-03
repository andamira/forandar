library forandar.core.stack;

import 'dart:typed_data';

// Core
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
		_size--;
	}

	/// Removes the top 2 stack items and discards them.
	///
	/// ( a b c -- a )
	void drop2() {
		_size -= 2;
	}

	/// Duplicates the top stack item.
	///
	/// ( a -- a a )
	void dup() {
		_data[_size] = _data[_size - 1]; _size++;
	}

	/// Duplicates the top stack pair of items
	///
	/// ( a b -- a b a b )
	void dup2() {
		_data[_size] = _data[_size - 2]; _size++;
		_data[_size] = _data[_size - 2]; _size++;
	}

	/// Drops the first item below the top of stack.
	///
	/// ( a b -- b )
	void nip() {
		_data[_size - 2] = _data[--_size];
	}

	/// Places a copy of a on top of the stack.
	///
	/// ( a b -- a b a )
	void over() {
		_data[_size] = _data[_size - 2]; _size++;
	}

	/// Places a copy of a b par on top of the stack.
	///
	/// ( a b c d -- c d a b )
	void over2() {
		_data[_size] = _data[_size - 4]; _size++;
		_data[_size] = _data[_size - 4]; _size++;
	}

	/// Returns the last stack item WITHOUT removing it.
	///
	/// ( a -- )
	T peek() {
		return _data[_size - 1];
	}

	/// Returns the Next Of Stack item WITHOUT removing it.
	///
	/// ( a -- )
	T peekNOS() {
		return _data[_size - 2];
	}

	/// Copies i to the top of the stack.
	///
	/// Pick(0) is equivalent to Dup() and Pick(1) is equivalent to Over().
	/// ( a b c ... i -- i a b c ... i )
	void pick(int i) {
		_data[_size] = _data[_size - i - 1]; _size++;
	}

	/// Returns the last stack item.
	///
	/// ( a -- )
	T pop() {
		return _data[--_size];
	}

	/// Returns a list of i items from the top of the stack.
	///
	/// ( a b c ... i -- )
	List<T> popList(int i) {
		// CHECK: performance vs pop()
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
		_data[_size++] = i;
	}

	/// Adds all the items from a List to the top of the stack.
	///
	/// ( -- a ... i )
	void pushList(List L) {
		L.forEach( (T i) {
			_data[_size] = i; _size++;
		});
	}

	/// Rotates i+1 items on the top of the stack.
	///
	/// Roll(2) is equivalent to Rot() and Roll(1) is equivalent to Swap().
	/// ( a b c ... i --  )
	void roll(int i) {
		var t = _data.sublist(_size - i - 1, _size);
		for (int c = 1; c <= i; c++) {
			_data[_size - 2 - i + c] = t[c];
		}
		_data[_size - 1] = t[0];
	}

	/// Rotates the top three stack entries.
	///
	/// ( a b c -- b c a )
	void rot() {
		var t = _data.sublist(_size - 3, _size);
		_data[_size - 1] = t[0];
		_data[_size - 2] = t[2];
		_data[_size - 3] = t[1];
	}

	/// Rotates counter-clockwise the top three stack entries.
	///
	/// ( a b c -- c a b )
	void rotCC() {
		var t = _data.sublist(_size - 3, _size);
		_data[_size - 1] = t[1];
		_data[_size - 2] = t[0];
		_data[_size - 3] = t[2];
	}

	/// Exchanges the top two stack items.
	///
	/// ( a b -- b a )
	void swap() {
		T t = _data[_size - 1];
		_data[_size - 1] = _data[_size - 2];
		_data[_size - 2] = t;
	}

	/// Exchanges the top two stack number pairs.
	///
	/// ( a b c d -- c d a b )
	void swap2() {
		var t = _data.sublist(_size - 4, _size);
		_data[_size - 1] = t[1];
		_data[_size - 2] = t[0];
		_data[_size - 3] = t[3];
		_data[_size - 4] = t[2];
	}

	/// Copies the first (top) stack item below the second stack item.
	///
	/// ( a b -- b a b )
	void tuck() {
		_data[_size]     = _data[_size - 1];
		_data[_size - 1] = _data[_size - 2];
		_data[_size - 2] = _data[_size]; _size++;
	}
}

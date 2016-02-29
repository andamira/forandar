library forandar.stack;

import 'dart:typed_data';

// Core
import 'package:forandar/src/core/globals.dart';

abstract class Stack<T extends num> {
	final List _data;
	final int _maxSize;
	int _size = 0;
	final StackType _type;

	Stack(this._maxSize, this._data, this._type);

	/// Returns the type of the stack.
	StackType get type => _type;

	/// Returns the size of the stack.
	int get size => _size;

	/// Returns the maximum size of the stack.
	int get maxSize => _maxSize;

	/// Clears the contents of the stack.
	void clear() { _size = 0; }

	/// Returns the representation of the stack.
	List<T> content() => _data.sublist(0, _size);

	/// Replaces the content of the [Stack] with the elements of the list.
	void replace(List<T> l) {
		_size = 0;
		l.forEach( (v){
			_data[_size++] = v;
		});
	}   

	@override
	String toString() => "<${_size}> ${content()}";
}

/// Last In First Out Stack Implementation (for  Interface).
abstract class LifoStack<T extends num> extends Stack<T> {

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

class LifoStackInt<int> extends LifoStack {
	LifoStackInt(maxSize, [StackType type = StackType.unknown]) :
		super(maxSize, new Int32List(maxSize), type);
}

class LifoStackFloat<double> extends LifoStack {
	LifoStackFloat(maxSize, [StackType type = StackType.unknown]) :
		super(maxSize, new Float64List(maxSize), type);
}

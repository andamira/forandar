part of forandar;

abstract class Stack<T extends num> {
	final List _data;
	final int _maxSize;
	int _size = 0;

	Stack(this._maxSize, this._data);

	/// Returns the size of the stack.
	int get size => _size;

	/// Clears the contents of the stack.
	void clear() {
		_size = 0;
	}

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

/// Last In First Out Stack Implementation.
abstract class LifoStack<T extends num> extends Stack<T> {

	LifoStack(maxSize, data) : super(maxSize, data);

	/// Removes the top stack item and discards it.
	///
	/// ( a b -- a )
	void drop() {
		if (_size > 0) {
			_size--;
		}
	}

	/// Removes the top 2 stack items and discards them.
	///
	/// ( a b c -- a )
	void drop2() {
		if (_size > 1) {
			_size -= 2;
		}
	}

	/// Duplicates the top stack item.
	///
	/// ( a -- a a )
	void dup() {
		if (_size > 0 && _size < _maxSize) {
			_data[_size] = _data[_size++ - 1];
		}
	}

	/// Duplicates the top stack pair of items
	///
	/// ( a b -- a b a b )
	void dup2() {
		try {
			_data[_size] = _data[_size++ - 2];
			_data[_size] = _data[_size++ - 2];
		} catch(e) {
			print(e);
		}
	}

	/// Drops the first item below the top of stack.
	///
	/// ( a b -- b )
	void nip() {
		if (_size > 1) {
			_data[_size - 2] = _data[--_size];
		}
	}

	/// Places a copy of a on top of the stack.
	///
	/// ( a b -- a b a )
	void over() {
		if (_size > 1 && _size < _maxSize) {
			_data[_size] = _data[_size++ - 2];
		}
	}

	/// Places a copy of a b par on top of the stack.
	///
	/// ( a b c d -- c d a b )
	void over2() {
		if (_size > 3 && _size < (_maxSize - 1)) {
			_data[_size] = _data[_size++ - 4];
			_data[_size] = _data[_size++ - 4];
		}
	}

	/// Returns the last stack item WITHOUT removing it.
	///
	/// ( a -- )
	T peek() {
		if (_size > 0) {
			return _data[_size - 1];
		} else {
			return null;
		}
	}

	/// Returns the Next Of Stack item WITHOUT removing it.
	///
	/// ( a -- )
	T peekNOS() {
		if (_size > 1) {
			return _data[_size - 2];
		} else {
			return null;
		}
	}

	/// Copies i to the top of the stack.
	///
	/// Pick(0) is equivalent to Dup() and Pick(1) is equivalent to Over().
	/// ( a b c ... i -- i a b c ... i )
	void pick(int i) {
		if (_size > i) {
			_data[_size] = _data[_size++ - 1 - i];
		}
	}

	/// Returns the last stack item.
	///
	/// ( a -- )
	T pop() {
		if (_size > 0) {
			return _data[--_size];
		} else {
			return null;
		}
	}

	/// Adds an additional stack item.
	///
	/// ( -- a )
	void push(T i) {
		if (_size < _maxSize) {
			_data[_size++] = i;
		}
	}

	/// Rotates i+1 items on the top of the stack.
	///
	/// Roll(2) is equivalent to Rot() and Roll(1) is equivalent to Swap().
	/// ( a b c ... i --  )
	void roll(int i) {
		if (_size > 0 && _size > i) {

			var t = _data.sublist(_size - i - 1, _size);

			for (int c = 1; c <= i; c++) {
				_data[_size - 2 - i + c] = t[c];
			}

			_data[_size - 1] = t[0];
		}
	}

	/// Rotates the top three stack entries.
	///
	/// ( a b c -- b c a )
	void rot() {
		if (_size > 2) {
			var t = _data.sublist(_size - 3, _size);
			_data[_size - 1] = t[0];
			_data[_size - 2] = t[2];
			_data[_size - 3] = t[1];
		}
	}

	/// Rotates counter-clockwise the top three stack entries.
	///
	/// ( a b c -- c a b )
	void rotCC() {
		if (_size > 2) {
			var t = _data.sublist(_size - 3, _size);
			_data[_size - 1] = t[1];
			_data[_size - 2] = t[0];
			_data[_size - 3] = t[2];
		}
	}

	/// Exchanges the top two stack items.
	///
	/// ( a b -- b a )
	void swap() {
		if (_size > 1) {
			T t = _data[_size - 1];
			_data[_size - 1] = _data[_size - 2];
			_data[_size - 2] = t;
		}
	}

	/// Exchanges the top two stack number pairs.
	///
	/// ( a b c d -- c d a b )
	void swap2() {
		if (_size > 3) {
			var t = _data.sublist(_size - 4, _size);
			_data[_size - 1] = t[1];
			_data[_size - 2] = t[0];
			_data[_size - 3] = t[3];
			_data[_size - 4] = t[2];
		}
	}

	/// Copies the first (top) stack item below the second stack item.
	///
	/// ( a b -- b a b )
	void tuck() {
		if (_size > 1) {
			_data[_size]     = _data[_size - 1];
			_data[_size - 1] = _data[_size - 2];
			_data[_size - 2] = _data[_size++];
		}
	}
}

class LifoStackInt<int> extends LifoStack {
	LifoStackInt(maxSize) : super(maxSize, new Int32List(maxSize));
}

class LifoStackFloat<double> extends LifoStack {
	LifoStackFloat(maxSize) : super(maxSize, new Float64List(maxSize));
}


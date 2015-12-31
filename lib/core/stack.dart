part of forandar;

abstract class Stack {
	TypedData data;
	final int maxSize;
	int size = 0;

	Stack(this.maxSize);

	/// Clears all the contents of the stack.
	void clear() {
		size = 0;
	}

	/// Returns the representation of the stack.
	List<num> content() {
		return data.sublist(0, size);
	}

	/// Replaces the content of the [Stack] with the elements of the list
	void replace(List<num> l) {
		size = 0;
		l.forEach( (v){
			data[size++] = v;
		});
	}

	@override
	String toString() {
		return "stack(${size}) ${content()}";
	}
}

/// Last In First Out Stack Implementation.
abstract class LifoStack extends Stack {

	LifoStack(maxSize) : super(maxSize);

	/// Removes the top stack item and discards it.
	///
	/// ( a b -- a )
	void drop() {
		if (size > 0) {
			size--;
		}
	}

	/// Removes the top 2 stack items and discards them.
	///
	/// ( a b c -- a )
	void drop2() {
		if (size > 1) {
			size -= 2;
		}
	}

	/// Duplicates the top stack item.
	///
	/// ( a -- a a )
	void dup() {
		if (size > 0 && size < maxSize) {
			data[size] = data[size++ - 1];
		}
	}

	/// Duplicates the top stack pair of items
	///
	/// ( a b -- a b a b )
	void dup2() {
		try {
			data[size] = data[size++ - 2];
			data[size] = data[size++ - 2];
		} catch(e) {
			print(e);
		}
	}

	/// Drops the first item below the top of stack.
	///
	/// ( a b -- b )
	void nip() {
		if (size > 1) {
			data[size - 2] = data[--size];
		}
	}

	/// Places a copy of a on top of the stack.
	///
	/// ( a b -- a b a )
	void over() {
		if (size > 1 && size < maxSize) {
			data[size] = data[size++ - 2];
		}
	}

	/// Returns the last stack item WITHOUT removing it.
	///
	/// ( a -- )
	num peek() {
		if (size > 0) {
			return data[size - 1];
		} else {
			return null;
		}
	}

	/// Copies i to the top of the stack.
	///
	/// Pick(0) is equivalent to Dup() and Pick(1) is equivalent to Over().
	/// ( a b c ... i -- i a b c ... i )
	void pick(num i) {
		if (size > i) {
			data[size] = data[size++ - 1 - i];
		}
	}

	/// Returns the last stack item.
	///
	/// ( a -- )
	num pop() {
		if (size > 0) {
			return data[--size];
		} else {
			return null;
		}
	}

	/// Adds an additional stack item.
	///
	/// ( -- a )
	void push(num i) {
		if (size < maxSize) {
			data[size++] = i;
		}
	}

	/// TODO: Rotates i+1 items on the top of the stack.
	///
	/// Roll(2) is equivalent to Rot() and Roll(1) is equivalent to Swap().
	/// ( a b c ... i --  )
	void roll(num i) {
		if (size > 0 && i > 0) {
			// var t = data.sublist(size - 1 - i, size);

			/*
			// convert to loop
			data[size - 1] = t[0];
			data[size - 2] = t[2];

			data[size - 3] = t[1]; Last
			*/

			// Do the last one first
			// data[size -1 -i] = t[1];
		}
	}

	/// Rotates the top three stack entries.
	///
	/// ( a b c -- b c a )
	void rot() {
		if (size > 2) {
			var t = data.sublist(size - 3, size);
			data[size - 1] = t[0];
			data[size - 2] = t[2];
			data[size - 3] = t[1];
		}
	}

	/// Rotates counter-clockwise the top three stack entries.
	///
	/// ( a b c -- c a b )
	void rotCC() {
		if (size > 2) {
			var t = data.sublist(size - 3, size);
			data[size - 1] = t[1];
			data[size - 2] = t[0];
			data[size - 3] = t[2];
		}
	}

	/// Exchanges the top two stack items.
	///
	/// ( a b -- b a )
	void swap() {
		if (size > 1) {
			num t = data[size - 1];
			data[size - 1] = data[size - 2];
			data[size - 2] = t;
		}
	}

	/// Copies the first (top) stack item below the second stack item.
	///
	/// ( a b -- b a b )
	void tuck() {
		if (size > 1) {
			data[size]     = data[size - 1];
			data[size - 1] = data[size - 2];
			data[size - 2] = data[size++];
		}
	}
}

class LifoStackInt extends LifoStack {

	LifoStackInt(int maxSize) : super(maxSize) {
		data = new Int32List(maxSize);
	}
}

class LifoStackFloat extends LifoStack {

	LifoStackFloat(int maxSize) : super(maxSize) {
		data = new Float64List(maxSize);
	}
}


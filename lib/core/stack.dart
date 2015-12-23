part of forandar;

abstract class Stack {
	Uint32List data;
	final int maxSize;
	int size = 0;

	/// Constructs the [Stack]
	Stack(this.maxSize) {
		this.data = new Uint32List(this.maxSize);
	}

	/// Clears all the contents of the stack.
	void clear() {
		this.size = 0;
	}

	/// Returns the representation of the stack.
	List<int> content() {
		return this.data.sublist(0, this.size);
	}

	/// Replaces the content of the [Stack] with the elements of the list
	void replace(List<int> l) {
		this.size = 0;
		l.forEach( (v){
			this.data[this.size++] = v;
		});
	}

	@override
	String toString() {
		return "stack(${this.size}) ${this.content()}";
	}
}

/// Last In First Out Stack Implementation.
class LifoStack extends Stack {

	LifoStack(maxSize) : super(maxSize);

	/// Removes the top stack item and discards it.
	///
	/// ( a b -- a )
	void drop() {
		if (this.size > 0) {
			this.size--;
		}
	}

	/// Removes the top 2 stack items and discards them.
	///
	/// ( a b c -- a )
	void drop2() {
		if (this.size > 1) {
			this.size -= 2;
		}
	}

	/// Duplicates the top stack item.
	///
	/// ( a -- a a )
	void dup() {
		if (this.size > 0 && this.size < this.maxSize) {
			this.data[this.size] = this.data[this.size++ - 1];
		}
	}

	/// Duplicates the top stack pair of items
	///
	/// ( a b -- a b a b )
	void dup2() {
		try {
			this.data[this.size] = this.data[this.size++ - 2];
			this.data[this.size] = this.data[this.size++ - 2];
		} catch(e) {
			print(e);
		}
	}

	/// Drops the first item below the top of stack.
	///
	/// ( a b -- b )
	void nip() {
		if (this.size > 1) {
			this.data[this.size - 2] = this.data[--this.size];
		}
	}

	/// Places a copy of a on top of the stack.
	///
	/// ( a b -- a b a )
	void over() {
		if (this.size > 1 && this.size < this.maxSize) {
			this.data[this.size] = this.data[this.size++ - 2];
		}
	}

	/// Returns the last stack item WITHOUT removing it.
	///
	/// ( a -- )
	int peek() {
		if (this.size > 0) {
			return this.data[size - 1];
		} else {
			return null;
		}
	}

	/// Copies i to the top of the stack.
	///
	/// Pick(0) is equivalent to Dup() and Pick(1) is equivalent to Over().
	/// ( a b c ... i -- i a b c ... i )
	void pick(int i) {
		if (this.size > i) {
			this.data[size] = this.data[size++ - 1 - i];
		}
	}

	/// Returns the last stack item.
	///
	/// ( a -- )
	int pop() {
		if (this.size > 0) {
			return this.data[--size];
		} else {
			return null;
		}
	}

	/// Adds an additional stack item.
	///
	/// ( -- a )
	void push(int i) {
		if (this.size < this.maxSize) {
			this.data[size++] = i;
		}
	}

	/// TODO: Rotates i+1 items on the top of the stack.
	///
	/// Roll(2) is equivalent to Rot() and Roll(1) is equivalent to Swap().
	/// ( a b c ... i --  )
	void roll(int i) {
		if (this.size > 0 && i > 0) {
			// var t = this.data.sublist(this.size - 1 - i, this.size);

			/*
			// convert to loop
			this.data[this.size - 1] = t[0];
			this.data[this.size - 2] = t[2];

			this.data[this.size - 3] = t[1]; Last
			*/

			// Do the last one first
			// this.data[this.size -1 -i] = t[1];
		}
	}

	/// Rotates the top three stack entries.
	///
	/// ( a b c -- b c a )
	void rot() {
		if (this.size > 2) {
			var t = this.data.sublist(this.size - 3, this.size);
			this.data[this.size - 1] = t[0];
			this.data[this.size - 2] = t[2];
			this.data[this.size - 3] = t[1];
		}
	}

	/// Rotates counter-clockwise the top three stack entries.
	///
	/// ( a b c -- c a b )
	void rotCC() {
		if (this.size > 2) {
			var t = this.data.sublist(this.size - 3, this.size);
			this.data[this.size - 1] = t[1];
			this.data[this.size - 2] = t[0];
			this.data[this.size - 3] = t[2];
		}
	}

	/// Exchanges the top two stack items.
	///
	/// ( a b -- b a )
	void swap() {
		if (this.size > 1) {
			int t = this.data[this.size - 1];
			this.data[this.size - 1] = this.data[this.size - 2];
			this.data[this.size - 2] = t;
		}
	}

	/// Copies the first (top) stack item below the second stack item.
	///
	/// ( a b -- b a b )
	void tuck() {
		if (this.size > 1) {
			this.data[this.size] = this.data[this.size - 1];
			this.data[this.size - 1] = this.data[this.size - 2];
			this.data[this.size - 2] = this.data[this.size++];
		}
	}
}


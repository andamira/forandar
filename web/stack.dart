part of daranfor;

abstract class Stack {
	Uint32List data;
	final int maxSize;
	int size = 0;

	Stack(this.maxSize) {
		this.data = new Uint32List(this.maxSize);
	}
}

/// Last In First Out Stack Implementation.
///
class LifoStack extends Stack {

	LifoStack(maxSize) : super(maxSize);

	/// Removes the top stack item and discard it.
	/// ( a -- )
	void Drop() {
		if (this.size > 0) {
			this.size--;
		}
	}

	/// Duplicates the top stack item.
	/// ( a -- a a )
	void Dup() {
		if (this.size > 0 && this.size < this.maxSize) {
			this.data[this.size] = this.data[this.size++ - 1];
		}
	}

	/// Drops the first item below the top of stack.
	/// ( a b -- b )
	void Nip() {
		if (this.size > 1) {
			this.data[this.size - 2] = this.data[--this.size];
		}
	}

	// Places a copy of a on top of the stack.
	// ( a b -- a b a )
	void Over() {
		if (this.size > 1 && this.size < this.maxSize) {
			this.data[this.size] = this.data[this.size++ - 2];
		}
	}

	// Returns the last stack item WITHOUT removing it.
	// ( a -- )
	int Peek() {
		if (this.size > 0) {
			return this.data[size - 1];
		}
	}

	/// Copies i to the top of the stack.
	///
	/// Pick(0) is equivalent to Dup() and Pick(1) is equivalent to Over().
	/// ( a b c ... i -- i a b c ... i )
	void Pick(int i) {
		if (this.size > i) {
			this.data[size] = this.data[size++ - 1 - i];
		}
	}

	/// Returns the last stack item.
	/// ( a -- )
	int Pop() {
		if (this.size > 0) {
			return this.data[--size];
		}
	}

	/// Adds an additional stack item.
	/// ( -- a )
	void Push(int i) {
		if (this.size < this.maxSize) {
			this.data[size++] = i;
		}
	}

	/*
	void PushList(List<int>) {
	}
	*/

	/// TODO: Rotates i+1 items on the top of the stack.
	/// Roll(2) is equivalent to Rot() and Roll(1) is equivalent to Swap().
	/// ( a b c ... i --  )
	void Roll(int i) {
		if (this.size > 0 && i > 0) {
			var t = this.data.sublist(this.size - 1 - i, this.size);

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
	/// ( a b c -- b c a )
	void Rot() {
		if (this.size > 2) {
			var t = this.data.sublist(this.size - 3, this.size);
			this.data[this.size - 1] = t[0];
			this.data[this.size - 2] = t[2];
			this.data[this.size - 3] = t[1];
		}
	}

	/// Rotates the top three stack entries Counter-Clockwise.
	/// ( a b c -- c a b )
	void RotCC() {
		if (this.size > 2) {
			var t = this.data.sublist(this.size - 3, this.size);
			this.data[this.size - 1] = t[1];
			this.data[this.size - 2] = t[0];
			this.data[this.size - 3] = t[2];
		}
	}

	/// Exchanges the top two stack items.
	/// ( a b -- b a )
	void Swap() {
		if (this.size > 1) {
			int t = this.data[this.size - 1];
			this.data[this.size - 1] = this.data[this.size - 2];
			this.data[this.size - 2] = t;
		}
	}

	/// Copies the first (top) stack item below the second stack item.
	/// ( a b -- b a b )
	void Tuck() {
		if (this.size > 1) {
			this.data[this.size] = this.data[this.size - 1];
			this.data[this.size - 1] = this.data[this.size - 2];
			this.data[this.size - 2] = this.data[this.size++];
		}
	}

	/// Returns the representation of the stack.
	Print() {
		return this.data.sublist(0, this.size);
	}
}


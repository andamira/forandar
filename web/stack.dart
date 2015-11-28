part of daranfor;

abstract class Stack {
	Uint32List data;
	final int maxSize;
	int size = 0;

	Stack(this.maxSize) {
		this.data = new Uint32List(this.maxSize);
	}
}

class LifoStack extends Stack {

	LifoStack(maxSize) : super(maxSize);

	// Remove the top stack item and discard it
	// ( a -- ) 
	void Drop() {
		if (this.size > 0) {
			this.size--;
		}
	}

	// Duplicate the top stack item
	// ( a -- a a )
	void Dup() {
		if (this.size > 0 && this.size < this.maxSize) {
			this.data[this.size]=this.data[this.size - 1];
			this.size++;
		}
	}

	// Place a copy of a on top of the stack
	// ( a b -- a b a )
	void Over() {
		if (this.size > 1 && this.size < this.maxSize) {
			this.data[this.size] = this.data[this.size - 2];
			this.size++;
		}
	}

	// Return the last stack item WITHOUT removing it
	// ( a -- )
	int Peek() {
		if (this.size > 0) {
			return this.data[size - 1];
		}
	}

	// Return the last stack item
	// ( a -- )
	int Pop() {
		if (this.size > 0) {
			this.size--;
			return this.data[size];
		}
	}

	// Add an additional stack item
	// ( -- a )
	void Push(int i) {
		if (this.size < this.maxSize) {
			this.data[size] = i;
			this.size++;
		}
	}

	/*
	void PushList(List<int>) {
	}
	*/

	/*
	void Roll(n) {
	}
	*/

	// Rotate the top three stack entries.
	// ( a b c -- b c a )
	void Rot() {
		if (this.size > 2) {
			var t = this.data.sublist(this.size - 3, this.size);
			this.data[this.size - 1] = t[0];
			this.data[this.size - 2] = t[2];
			this.data[this.size - 3] = t[1];
		}
	}

	// Rotate the top three stack entries Counter-Clockwise.
	// ( a b c -- c a b )
	void RotCC() {
		if (this.size > 2) {
			var t = this.data.sublist(this.size - 3, this.size);
			this.data[this.size - 1] = t[1];
			this.data[this.size - 2] = t[0];
			this.data[this.size - 3] = t[2];
		}
	}

	// Exchange the top two stack items
	// ( a b -- b a )
	void Swap() {
		if (this.size > 1) {
			int t = this.data[this.size - 1];
			this.data[this.size - 1] = this.data[this.size - 2];
			this.data[this.size - 2] = t;
		}
	}

	// Returns the representation of the stack
	List() {
		return this.data.sublist(0, this.size);
	}
}


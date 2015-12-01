part of forandar;

class VM {
	// Dictionary
	Dictionary dict;

	// Stacks
	LifoStack dataStack;
	LifoStack returnStack;
	LifoStack controlStack;

	// Data Space
	DataSpace dataSpace;
	DataSpace codeSpace;


	/// Constructs the [VM] Virtual Machine
	VM () {

		/// Creates the Stacks
		this.dataStack    = new LifoStack(256);
		this.returnStack  = new LifoStack(32);
		this.controlStack = new LifoStack(32);

		/// Creates the main data space
		this.dataSpace = new DataSpace(1024, 1);
		/// Creates the code data space for storing the instructions for non-primitive words
		this.codeSpace = new DataSpace(1024, 4);

		/// Creates the [Dictionary] containing the [Word]s
		this.dict = new Dictionary(this);
	}
}


// [TODO]
class DataSpace {

	DataSpace(size, type) {

	}
}


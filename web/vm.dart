part of forandar;

class VirtualMachine {
	// Dictionary
	Dictionary dict;

	// Stacks
	LifoStack dataStack;
	LifoStack returnStack;
	LifoStack controlStack;

	// Data Space
	DataSpace dataSpace;
	DataSpace codeSpace;


	/// Constructs the [VirtualMachine]
	VirtualMachine (Configuration config) {

		/// Creates the Stacks
		this.dataStack    = new LifoStack(256);
		this.dataStack    = new LifoStack(config.option['dataStackSize']);
		this.returnStack  = new LifoStack(config.option['returnStackSize']);
		this.controlStack = new LifoStack(config.option['controlStackSize']);

		/// Creates the main data space
		this.dataSpace = new DataSpace(config.option['dataSpaceSize'], 1);
		/// Creates the code data space for storing the instructions for non-primitive words
		this.codeSpace = new DataSpace(config.option['codeSpaceSize'], 4);

		/// Creates the [Dictionary] containing the [Word]s
		this.dict = new Dictionary(this);
	}
}


// [TODO]
class DataSpace {

	DataSpace(size, type) {

	}
}


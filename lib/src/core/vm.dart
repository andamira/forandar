part of forandar;

// Forth boolean flags
const int flagTRUE = -1;
const int flagFALSE = 0;

/// The size of a cell in bytes.
const int cellSize = 4;
const int floatSize = cellSize * 2;

/// The Forth Virtual Machine.
///
/// Contains the dictionary, stacks, data and object spaces, source queue...
class VirtualMachine {

	// Dictionary.
	Dictionary dict;

	// Stacks.
	LifoStackInt dataStack;
	LifoStackInt returnStack;
	LifoStackInt controlStack;
	LifoStackFloat floatStack;

	// Data Spaces.
	DataSpace dataSpace;
	ObjectSpace objectSpace;

	InputQueue source;
	Configuration config;

	// Singleton constructor, allowing only one instance.
	factory VirtualMachine(config, source) {
		_instance ??= new VirtualMachine._internal(config, source);
		return _instance;
	}
	static VirtualMachine _instance;

	/// Constructs the [VirtualMachine].
	VirtualMachine._internal(this.config, this.source) {

		/// Creates the Stacks.
		dataStack    = new LifoStackInt(config.option['dataStackSize']);
		returnStack  = new LifoStackInt(config.option['returnStackSize']);
		controlStack = new LifoStackInt(config.option['controlStackSize']);
		floatStack   = new LifoStackFloat(config.option['floatStackSize']);

		/// Creates and initializes the main data space.
		dataSpace = new DataSpace(config.option['dataSpaceSize']);

		/// Creates the object space.
		objectSpace = new ObjectSpace();

		/// Stores a reference to itself in [InputQueue].
		source.vm = this;

		/// Creates and initializes the dictionary.
		dict = new Dictionary(this);
	}

	/// Returns true when in compilation-state, false otherwise.
	bool get compilationState {
		return dataSpace.fetchCell(addrSTATE) == flagTRUE ? true : false;
	}
	/// Enters compilation-state when set to true, otherwise if false.
	void set compilationState(bool flag) {
		dataSpace.storeCell(addrSTATE, flag ? flagTRUE : flagFALSE );
	}

	/// Returns true when in interpretation-state, false otherwise.
	bool get interpretationState {
		return dataSpace.fetchCell(addrSTATE) == flagTRUE ? false : true;
	}

	/// Enters interpretation-state when set to true, otherwise if false.
	void set interpretationState(bool flag) {
		dataSpace.storeCell(addrSTATE, flag ? flagFALSE : flagTRUE );
	}
}


part of forandar;

// Library Constants.

// Forth boolean flags
const int flagTRUE = -1;
const int flagFALSE = 0;

/// The size of a cell in bytes.
const int cellSize = 4;

// Addresses.
//
// Reserved space at the beginning of [DataSpace] for:
//   BASE STATE >IN

// The minimum length [DataSpace] must have.
const int reservedDataSpace = cellSize * 3;

/// Address for the base conversion radix in the data space.
const int addrBASE = 0;

/// Address for the compilation-state flag.
///
/// It is true (meaning != flagFALSE) when in compilation state.
const int addrSTATE = addrBASE + cellSize;

/// Address for the offset from the start of the input buffer to the start of the parse area.
const int addrToIN = addrSTATE + cellSize;

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

	/// Constructs the [VirtualMachine].
	VirtualMachine (this.config, this.source) {

		/// Creates the Stacks.
		dataStack    = new LifoStackInt(config.option['dataStackSize']);
		returnStack  = new LifoStackInt(config.option['returnStackSize']);
		controlStack = new LifoStackInt(config.option['controlStackSize']);
		floatStack   = new LifoStackFloat(config.option['floatStackSize']);

		/// Creates the main data space.
		dataSpace = new DataSpace(config.option['dataSpaceSize']);
		/// Creates the code data space for storing the instructions for non-primitive words.
		objectSpace = new ObjectSpace();

		/// Creates the [Dictionary] containing the [Word]s.
		dict = new Dictionary(this);

		initDataSpace();
	}

	/// Initializes the default data in [dataSpace].
	void initDataSpace() {

		/// Reserves the needed space;
		dataSpace.pointer = reservedDataSpace;

		/// Sets a default decimal BASE (radix).
		dataSpace.storeCell(addrBASE, 10);

		/// Sets current STATE to interpretation-mode.
		dataSpace.storeCell(addrSTATE, flagFALSE);

		/// Sets the input buffer offset to 0.
		dataSpace.storeCell(addrToIN, flagFALSE);
	}

	/// Returns [true] when in compilation-mode.
	///
	/// And [false] in interpretation-mode.
	/// The true value in STATE is non-zero.
	/// http://forth-standard.org/standard/core/STATE
	bool get inCompileMode {
		if (dataSpace.fetchCell(addrSTATE) == flagFALSE ) {
			return false;
		} else {
			return true;
		}
	}
}


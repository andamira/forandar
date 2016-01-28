part of forandar;

// Library Constants.

/// The size of a cell in bytes.
const int cellSize = 4;

// Addresses.

/// Address for storing the base conversion radix in the data space.
const int addrBASE = 0;

/// Address for storing the compilation-state flag.
///
/// It is true (!=flagFALSE) when in compilation state.
const int addrSTATE = addrBASE + cellSize;

// Flags.

const int flagTRUE = -1;
const int flagFALSE = 0;


/// The Forth Virtual Machine.
///
/// Contains the dictionary, stacks, data and object spaces, input queued...
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

	// Input Queue.
	InputQueue input;

	/// Constructs the [VirtualMachine].
	VirtualMachine (Configuration config, InputQueue input) {

		/// Creates the Stacks.
		dataStack    = new LifoStackInt(config.option['dataStackSize']);
		returnStack  = new LifoStackInt(config.option['returnStackSize']);
		controlStack = new LifoStackInt(config.option['controlStackSize']);
		floatStack   = new LifoStackFloat(config.option['floatStackSize']);

		/// Creates the main data space.
		dataSpace = new DataSpace(config.option['dataSpaceSize']);
		/// Creates the code data space for storing the instructions for non-primitive words.
		objectSpace = new ObjectSpace();

		/// Creates the source code input queue.
		this.input = input;

		/// Creates the [Dictionary] containing the [Word]s.
		dict = new Dictionary(this);

		initDataSpace();
	}

	/// Initializes the default data in [dataSpace].
	void initDataSpace() {

		/// Reserves space: 2 cells.
		dataSpace.pointer += cellSize * 2;

		/// Sets a default decimal BASE (radix).
		dataSpace.storeCell(addrBASE, 10);

		/// Sets the default STATE to interpretation-mode.
		dataSpace.storeCell(addrSTATE, flagFALSE);
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

/// Supported types of input.
enum InputType { String, File, Url }

class InputQueueElement {
	InputType type;
	String str;

	InputQueueElement(InputType t, String s) {
		type = t;
		str = s;

		// print("InputQueueElement($t, «$s»)"); // TEMP
	}
}


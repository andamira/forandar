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
	ObjectSpace objectSpace;

	// Input Queue
	InputQueue input;

	/// Constructs the [VirtualMachine]
	VirtualMachine (Configuration config, InputQueue input) {

		/// Creates the Stacks
		this.dataStack    = new LifoStack(256);
		this.dataStack    = new LifoStack(config.option['dataStackSize']);
		this.returnStack  = new LifoStack(config.option['returnStackSize']);
		this.controlStack = new LifoStack(config.option['controlStackSize']);

		/// Creates the main data space
		this.dataSpace = new DataSpace(config.option['dataSpaceSize']);
		/// Creates the code data space for storing the instructions for non-primitive words
		this.objectSpace = new ObjectSpace();

		/// Creates the source code input queue.
		this.input = input;

		/// Creates the [Dictionary] containing the [Word]s
		this.dict = new Dictionary(this);
	}
}


/// 
///
/// TODO http://stackoverflow.com/questions/28026648/how-to-improve-dart-performance-of-data-conversion-to-from-binary
class DataSpace {
	ByteBuffer buffer;
	ByteData data;
	final int maxSize;
	int size = 0;

	DataSpace(this.maxSize) {
		//this.data = new ByteData(this.maxSize);

		this.buffer = new Uint8List(this.maxSize).buffer;
		this.data = new ByteData.view(buffer);
	}


}

/// 
class ObjectSpace {
	List<Object> data = [];
}

/// Supported types of input
enum InputType { String, File, Url }

class InputQueueElement {
	InputType type;
	String str;

	InputQueueElement(InputType t, String s) {
		this.type = t;
		this.str = s;
	}
}

/// The global source code inputs queue.
///
/// Stores in order the series of source codes for interpreting,
/// either as a string, or as a file / URL to be loaded.
class InputQueue {

	/// Storage for the source code inputs, in order.
	List<InputQueueElement> queue = [ ];

	/// Adds a new input to the [queue].
	void add(InputType t, String s) {
		this.queue.add(new InputQueueElement(t, s));
	}

	/// This function is replaced in the Web library.
	Future<String> loadUrl();

	/// This function is replaced in the CLI library.
	Future<String> loadFile();
}



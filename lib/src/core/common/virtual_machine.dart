part of forandar.core.virtual_machine;

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

	InputQueueBase source;
	Configuration config;

	// Singleton constructor, allowing only one instance.
	factory VirtualMachine({
			List<String> args,
			Function argParser,
			Configuration config,
			InputQueueBase input,
			bool loadPrimitives: true}) {

		if (_instance == null) {
			config ??= new Configuration();
			input ??= new InputQueueBase();

			_instance = new VirtualMachine._internal(args, argParser, config, input, loadPrimitives);
		}
		return _instance;
	}
	static VirtualMachine _instance;

	/// Constructs the [VirtualMachine].
	VirtualMachine._internal(
			List<String> args,
			Function argParser,
			this.config,
			this.source,
			bool loadPrimitives) {

		/// Parses the arguments.
		///
		/// Updates the [config]uration and fills the [source]code input queue.
		if (args != null && argParser != null) {
			argParser(args, config, source);
		}

		// Updates the global configuration.
		globalConfig = config;

		/// Creates the Stacks.
		dataStack    = new LifoStackInt(config.getOption('dataStackSize'), StackType.dataStack);
		returnStack  = new LifoStackInt(config.getOption('returnStackSize'), StackType.returnStack);
		controlStack = new LifoStackInt(config.getOption('controlStackSize'), StackType.controlStack);
		floatStack   = new LifoStackFloat(config.getOption('floatStackSize'), StackType.floatStack);

		/// Creates and initializes the main data space.
		dataSpace = new DataSpace(config.getOption('dataSpaceSize'));

		/// Creates the object space.
		objectSpace = new ObjectSpace();

		/// Creates the dictionary.
		dict = new Dictionary();

		/// Loads the primitives in the dictionary.
		if (loadPrimitives) new Primitives(this).load();
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

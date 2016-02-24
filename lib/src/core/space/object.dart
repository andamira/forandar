part of forandar;

class ObjectSpace {

	List<Object> data = [];
	int pointer = 0;

	// Singleton constructor, allowing only one instance.
	factory ObjectSpace() {
		_instance ??= new ObjectSpace._internal();
		return _instance;
	}
	static ObjectSpace _instance;

	ObjectSpace._internal();

	int get length => data.length;
}


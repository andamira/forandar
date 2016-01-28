part of forandar;

// http://stackoverflow.com/questions/28026648/how-to-improve-dart-performance-of-data-conversion-to-from-binary

class DataSpace {
	ByteData data;
	final int maxSize;
	int pointer = 0;

	DataSpace(this.maxSize) {
		data = new ByteData(maxSize);
	}

	int fetchChar(int address) => data.getInt8(address);

	int fetchCell(int address) => data.getInt32(address);

	double fetchFloat(int address) => data.getFloat64(address);

	/// Stores an integer using 1 byte at the specified address.
	void storeChar(int address, int value) => data.setInt8(address, value);

	/// Stores an integer using 1 byte at the current pointer position, and increments it.
	void storeCharHere(int value) => data.setInt8(pointer++, value);

	/// Stores an integer using 4 bytes at the specified address.
	void storeCell(int address, int value) => data.setInt32(address, value);

	/// Stores an integer using 4 bytes at the current pointer position, and increments it.
	void storeCellHere(int value) => data.setInt32(pointer += cellSize, value);

	/// Stores a float using 8 bytes at the specified address.
	void storeFloat(int address, double value) => data.setFloat64(address, value);

	/// Stores a float using 8 bytes at the current pointer position, and increments it.
	void storeFloatHere(double value) => data.setFloat64(pointer += cellSize * 2, value);
}

/// TODO
class ObjectSpace {
	List<Object> data = [];
	int pointer = 0;
}


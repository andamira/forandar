part of forandar;

// http://stackoverflow.com/questions/28026648/how-to-improve-dart-performance-of-data-conversion-to-from-binary

class DataSpace {

	ByteData _data;

	int pointer = 0;

	DataSpace(length) {
		if (length < reservedDataSpace) length = reservedDataSpace;
		_data = new ByteData(length);
	}

	Uint8List getCharList(int offset, int length) => _data.buffer.asUint8List(offset, length);

	int get length => _data.lengthInBytes;

	int fetchChar(int address) => _data.getInt8(address);

	int fetchCell(int address) => _data.getInt32(address);

	double fetchFloat(int address) => _data.getFloat64(address);

	/// Stores an integer using 1 byte at the specified address.
	void storeChar(int address, int value) => _data.setInt8(address, value);

	/// Stores an integer using 1 byte at the current pointer position, and increments it.
	void storeCharHere(int value) => _data.setInt8(pointer++, value);

	/// Stores an integer using 4 bytes at the specified address.
	void storeCell(int address, int value) => _data.setInt32(address, value);

	/// Stores an integer using 4 bytes at the current pointer position, and increments it.
	void storeCellHere(int value) => _data.setInt32(pointer += cellSize, value);

	/// Stores a float using 8 bytes at the specified address.
	void storeFloat(int address, double value) => _data.setFloat64(address, value);

	/// Stores a float using 8 bytes at the current pointer position, and increments it.
	void storeFloatHere(double value) => _data.setFloat64(pointer += cellSize * 2, value);
}

/// TODO
class ObjectSpace {
	List<Object> data = [];
	int pointer = 0;
}


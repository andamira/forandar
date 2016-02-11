part of forandar;

/// The minimum reserved length for the data space.
///
/// Reserve some space at the beginning for variables
/// and some minimum free space after that.
const int minDataSpaceSize =
	// Cells.
	cellSize * 3        // BASE STATE >IN

	// Buffers.
	+ inputBufferSize   // SOURCE
	+ padSize           // PAD

	// Minimum free space.
	+ 1024;

/// Address returned by BASE .
///
/// For the current number-conversion radix.
const int addrBASE = 0;

/// Address returned by STATE .
///
/// When in compilation state this flag is set to true (meaning != flagFALSE).
const int addrSTATE = addrBASE + cellSize;

/// Address returned by >IN .
///
/// The offset from the start of the input buffer to the start of the parse area.
const int addrToIN = addrSTATE + cellSize;

/// Address returned by SOURCE .
///
/// SOURCE returns this address AND the length of the input buffer.
const int addrInputBuffer = addrToIN + cellSize;

/// Address returned by PAD .
///
/// A transient region for the programmer's convenience.
const int addrPAD = addrInputBuffer + inputBufferSize;

// const int ... = addrPAD + padSize; 

/// The forth main data space.
class DataSpace {

	ByteData _data;

	int pointer = 0;

	/// Initializes the data space.
	///
	/// After each store operation, also updates the pointer (HERE)
	/// to the first available space.
	DataSpace(length) {
		if (length < minDataSpaceSize) length = minDataSpaceSize;
		_data = new ByteData(length);

		/// Sets a default decimal BASE (radix).
		storeCellInc(addrBASE, 10);

		/// Sets current STATE to interpretation-state.
		storeCellInc(addrSTATE, flagFALSE);

		/// Sets the input buffer offset to 0.
		storeCellInc(addrToIN, flagFALSE);

		/// Reserves the space for the input buffer and PAD regions.
		pointer += inputBufferSize + padSize;
	}

	Uint8List getCharList(int offset, int length) => _data.buffer.asUint8List(offset, length);

	int get length => _data.lengthInBytes;

	/// Fetches a char integer from the specified address.
	int fetchChar(int address) => _data.getInt8(address);

	/// Fetches a cell integer from the specified address.
	int fetchCell(int address) => _data.getInt32(address);

	/// Fetches a float from the specified address.
	double fetchFloat(int address) => _data.getFloat64(address);

	/// Stores a char integer at the specified address.
	void storeChar(int address, int value) => _data.setInt8(address, value);

	/// Stores a char integer at the current pointer position, and increments it.
	void storeCharHere(int value) => _data.setInt8(pointer++, value);

	/// Stores a char integer at the specified address, and increments the current pointer position.
	void storeCharInc(int address, int value) {
		_data.setInt8(address, value);
		pointer++;
	}

	/// Stores a char integer at the specified address.
	void storeCell(int address, int value) => _data.setInt32(address, value);

	/// Stores a cell integer at the current pointer position, and increments it.
	void storeCellHere(int value) => _data.setInt32(pointer += cellSize, value);

	/// Stores a cell integer at the specified address, and increments the current pointer position.
	///
	/// This is mainly useful for the initilization of the data space.
	void storeCellInc(int address, int value) {
		_data.setInt32(address, value);
		pointer += cellSize;
	}

	/// Stores a float at the specified address.
	void storeFloat(int address, double value) => _data.setFloat64(address, value);

	/// Stores a float at the current pointer position, and increments it.
	void storeFloatHere(double value) => _data.setFloat64(pointer += floatSize, value);

	/// Stores a float at the specified address, and increments the current pointer position.
	void storeFloatInc(int address, double value) {
		_data.setFloat64(address, value);
		pointer += floatSize;
	}

	/// Stores a string at the specified address as UTF-8.
	void storeString(int address, String str) {
		var strUTF8 = UTF8.encode(str);

		if (strUTF8.length > inputBufferSize) {
			throwError(-2050);
		}

		// TODO
		//getCharList(addrInputBuffer, inputBufferSize);
	}
}

/// TODO
class ObjectSpace {
	List<Object> data = [];
	int pointer = 0;
}


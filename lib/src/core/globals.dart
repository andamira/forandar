library forandar.core.globals;

// Forth boolean flags
const int flagTRUE = -1; 
const int flagFALSE = 0;

/// The size of a cell in bytes.
const int cellSize = 4;
const int floatSize = cellSize * 2;

/// The size for the input buffer.
///
/// Enough for one line.
const int inputBufferSize = 512;

/// The size for the PAD region.
const int padSize = inputBufferSize;

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

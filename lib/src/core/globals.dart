library forandar.core.globals;

// Global Types
// ------------

/// All the different stack types.
enum StackType {
    unknown,
    dataStack,
    floatStack,
    returnStack,
    controlStack,
    exceptionStack
}

/// Supported types of input.
enum InputType { String, File, Url }

/// All the interface types.
enum InterfaceType { undefined, cli, web }

/// All the terminal types.
enum TerminalType { auto, simple, xterm }


// Global Variables
// ----------------

var globalConfig; // CHECK


// Global Constants
// ----------------

// Forth boolean flags.
const int flagTRUE = -1;
const int flagFALSE = 0;

/// The size of a cell in bytes.
const int sizeCHAR =  1;
const int sizeCELL =  4;
const int sizeFLOAT = 8;

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
	sizeCELL * 3        // BASE STATE >IN

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
const int addrSTATE = addrBASE + sizeCELL;

/// Address returned by >IN .
///
/// The offset from the start of the input buffer to the start of the parse area.
const int addrToIN = addrSTATE + sizeCELL;

/// Address returned by SOURCE .
///
/// SOURCE returns this address AND the length of the input buffer.
const int addrInputBuffer = addrToIN + sizeCELL;

/// Address returned by PAD .
///
/// A transient region for the programmer's convenience.
const int addrPAD = addrInputBuffer + inputBufferSize;

// const int ... = addrPAD + padSize;

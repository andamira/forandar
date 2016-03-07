/// The `ANSI` class defines methods of interacting with a terminal aware of ANSI escape codes.
///
/// Links:
///
/// - [ANSI escape code](https://en.wikipedia.org/wiki/ANSI_escape_code) page in Wikipedia.
/// - []().
///
library forandar.cli.ansi;

import 'dart:io';

// ANSI compatible terminal manipulation.
class ANSI {

	/// Escape character.
	static const String ESC = "\x1b";

	/// Control Sequence Initiator character.
	static const String CSI = "$ESC[";

	static void write(String content) {
		// IDEA: use to an interface independent proxy.
		stdout.write(content);
	}

	// Outputs CSI (Control Sequence Initiator) codes.
	static void writeCSI(String after) => write("${CSI}${after}");

	/// Sets SGR (Select Graphic Rendition) parameters, including text color.
	///
	/// After CSI can be zero or more parameters separated with ;. With no parameters, CSI m is treated as CSI 0 m (reset / normal), which is typical of most of the ANSI escape sequences. 
	static void writeSGR(String after) => write("${CSI}${n}m");

	// CSI CODES
	// ---------

	/// Moves the cursor [n] lines up, if it's not already on the last line..
	///
	/// CUU - Cursor Up.
	static void cursorUp([int n = 1]) => writeCSI("${n}A");

	/// Moves the cursor [n] lines down, if it's not already on the first line.
	///
	/// CUD - Cursor Down.
	static void cursorDown([int n = 1]) => writeCSI("${n}B");

	/// Moves the cursor [n] columns forward, if it's not already on the last column.
	///
	/// CUF - Cursor Forward.
	static void cursorForward([int n = 1]) => writeCSI("${n}C");

	/// Moves the cursor [n] columns back, if it's not already on the first column.
	///
	/// CUB - Cursor Back.
	static void cursorBack([int n = 1]) => writeCSI("${n}D");

	/// Moves the Cursor to the beginning of the line [n] lines down.
	///
	/// CNL - Cursor Next Line. (Not ANSI.SYS)
	static void cursorNextLine([int n = 1]) => writeCSI("${n}D");

	/// Moves the Cursor to the beginning of the line [n] lines up.
	///
	/// CPL - Cursor Previous Line. (Not ANSI.SYS)
	static void cursorPreviousLine([int n = 1]) => writeCSI("${n}D");

	/// Moves to the column specified in [number].
	static void moveToColumn(int number) => writeCSI("${number}G");

	/// Erases the Display
	static void eraseDisplay([int type = 0]) => writeCSI("${type}J");

	/// Erases the Line.
	///
	/// If type is zero (or missing), clear from cursor to the end of the line.
	/// If type is one, clear from cursor to beginning of the line.
	/// If type is two, clear entire line.
	static void eraseLine([int type = 0]) => writeCSI("${type}K");

	/// Overwrites the current line with [line].
	static void overwriteLine(String line) {
		write("\r");
		eraseLine(2);
		write(line);
	}
}


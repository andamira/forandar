/// Methods for emmiting ANSI compatible & XTerm control codes.
///
/// Links:
///
/// - [ANSI escape code](https://en.wikipedia.org/wiki/ANSI_escape_code) page in Wikipedia.
/// - []().
///
library forandar.cli.xterm_control;

import 'dart:io';

// ANSI compatible terminal manipulation.
class XTerm {

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

	/// Erases the Display.
	///
	/// If type is 0 (or missing), clears Below.
	/// If type is 1, clears Above.
	/// If type is 2, clears All.
	static void eraseDisplay([int n = 0]) => writeCSI("${n}J");

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


	// XTerm Specific Codes
	// --------------------

	/// DEC Private Mode Set & RESET (DECSET & DECRST)
	///
	/// For resetting, set to `true` the [reset] argument.
	///
	/// mode 1 (DECCKM) : Application Cursor Keys
	///            reset: Normal Cursor Keys
	///
	/// mode 2 (DECANM) : set: Designate USASCII for  character
	///            reset: -
	///
	/// mode 3 (DECCOLM): 132 Column Mode
	///            reset: 80 Column Mode
	///
	/// mode 4 (DECSCLM): Smooth (Slow) Scroll
	///            reset: Jump (Fast) Scroll
	///
	/// mode 5 (DECSCNM): Reverse Video CHECK
	///            reset: Normal Video
	///
	/// mode 6 (DECOM)  :   Origin Mode CHECK
	///            reset: Normal Cursor Mode
	///
	/// mode 7 (DECAWM) :  Wraparound Mode CHECK
	///            reset: No Wraparound Mode
	///
	/// mode 8 (DECARM) : Auto-repeat Keys
	///            reset: No Auto-repeat Keys
	///
	/// mode 9: Send Mouse X & Y on button press. CHECK
	///  reset: Don't Send Mouse X & Y on button press.
	///
	/// mode 38 (DECTEK): Enter Tektronix Mode
	///            reset: -
	///
	/// mode 40: Allow 80 <--> 132 Mode
	///   reset: Disallow 80 <--> 132 Mode
	///
	/// mode 41: curses(5) fix
	///   reset: No curses(5) fix
	///
	/// mode 44: Turn On Margin Bell
	///   reset: Turn Off Margin Bell
	///
	/// mode 45: Reverse-wraparound Mode
	///   reset: N  Reverse-wraparound Mode
	///
	/// mode 46: Start Logging
	///   reset: Stop Logging
	///
	/// mode 47: Use Alternate Screen
	///   reset: Use Normal Screen Buffer
	///
	/// mode 1000: Send Mouse X & Y on button press and release.
	///     reset: Don't Send Mouse X & Y on button press and release.
	///
	/// mode 1001: Use Hilite Mouse Tracking
	///     reset: Don't Use Hilite Mouse Tracking
	///
	/// mode 1002: CHECK
	///               reset: ?
	///
	/// mode 1003: CHECK
	///               reset: ?
	///
	/// mode 1004: CHECK
	///               reset: ?
	///
	/// mode 1005: CHECK
	///               reset: ?
	static void writeXterm(int mode, {bool reset: false}) {
		writeCSI("?${mode}${reset ? "l" : "h"}");
	}

	/// Enables sending Mouse X & Y on button press and release.
	static void mouseOn({hilite: false})  => writeXterm(1000 + (hilite ? 1 : 0));

	/// Disables sending Mouse X & Y on button press and release.
	static void mouseOff({hilite: false}) => writeXterm(1000 + (hilite ? 1 : 0), reset: true);

	/* TODO
	ESC [ _Ps ; _Ps ; _Ps ; _Ps ; _Ps T
		Initiate hilite mouse  tracking.   Parameters  are
		[func;startx;starty;firstrow;lastrow].    See  the
		section Mouse Tracking.
	*/

	// Normal tracking mode sends an  escape  sequence  on  both  button
	// press  and  release.   Modifier  information is also sent.  It is
	// enabled by specifying parameter 1000 to DECSET.  On button  press
	// or release, xterm sends ESC [ M CbCxCy.  The low two
	// bits of  Cb  encode  button  information:  0=MB1  pressed,  1=MB2
	// pressed,  2=MB3  pressed,  3=release.  The upper bits encode what
	// modifiers were down when the button was  pressed  and  are  added
	// together.   4=Shift, 8=Meta, 16=Control.  Cx and Cy are the x and
	// y coordinates of the mouse  event.   The  upper  left  corner  is
	// (1,1).
}

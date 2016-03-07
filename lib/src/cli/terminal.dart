/// The [Terminal] class provides the methods to ue
library forandar.cli.terminal;

import 'dart:convert';
import 'dart:io';

// Core
import 'package:forandar/src/core/errors.dart';

// Cli
import 'package:forandar/src/cli/ansi.dart';

class Terminal {

	// A representation of the terminal line in UTF code points (runes).
	static List<int> _lineCodePoints = [];

	// The current cursor position in the line.
	static int _lineCursorIndex = 0;

	/// The number of characters in the current line.
	static int get lineLength => _lineCodePoints.length;

	/// The number of columns of the current terminal.
	static int get columns => stdout.terminalColumns;

	/// The number of rows of the current terminal.
	static int get rows => stdout.terminalLines;

	// Signals
	static Stream get onSIGINT => ProcessSignal.SIGINT.watch();
	static Stream get onResize => ProcessSignal.SIGWINCH.watch();

	static void cursorHome() {
		_lineCursorIndex = 0;
		ANSI.moveToColumn(0);
	}

	/// Moves the cursor to the end of the line.
	static void cursorEnd() {
		_lineCursorIndex = lineLength;
		ANSI.moveToColumn(lineLength);
	}

	/// Moves the cursor to the left.
	static void cursorLeft() {
		if (_lineCursorIndex > 0 && lineLength > 0) {
			ANSI.cursorBack();
			_lineCursorIndex--;
		}
	}

	/// Moves the cursor to the right.
	static void cursorRight() {
		if (_lineCursorIndex < lineLength) {
			ANSI.cursorForward();
			_lineCursorIndex++;
		}
	}

	/// Deletes the character where the cursor is positioned.
	static void deleteForward() {
		if (_lineCursorIndex < lineLength) {
			_lineCodePoints.removeAt(_lineCursorIndex);
		}
	}

	// Deletes the character to the left of the cursor.
	static void deleteBackwards() {
		if (_lineCursorIndex > 0 && lineLength > 0) {
			_lineCursorIndex--;
			_lineCodePoints.removeAt(_lineCursorIndex);
		}
	}

	// Shows the previous line stored in the history.
	static void historyPrevious() {
		// TODO
	}

	// Retrieves the next line stored in the history.
	static void historyNext() {
		// TODO
	}


	/// Reads a line synchronously from stdin.
	///
	/// This call will block until a full line is available.
	///
	/// NOTE: If end-of-file is reached after any bytes have been
	/// read from stdin, that data is returned.
	static String readLineSync() {
		try {
			return _readLineSync();
		} catch(e) {
			stdin.echoMode = true;
			stdin.lineMode = true;
			print(ForthError.unmanaged(e));
			return "";
		}
	}

	static String _readLineSync({encoding: UTF8}) {

		// Flags for multiple bytes that represent a key code.
		final List<int> _keyCode = [];

		// A temporary list of bytes for UTF-8 multi-byte conversion.
		final List<int> _codeUnits = [];

		// A representation of the terminal line as a [String].
		String _lineString = "";

		// A counter to keep track of remaining UTF-8 code points.
		int _UTF8RemainingChars = 0;

		// A flag for sending the line.
		bool sendLine = false;

		stdin.echoMode = false;
		stdin.lineMode = false;

		// Byte reading loop.
		do {
			int byte = stdin.readByteSync();

			// print(byte); // DEBUG


			// A single char (or the first of a sequence)
			// ------------------------------------------
			if (_keyCode.isEmpty) {

				// ASCII control characters.
				//
				// ^Key means Ctrl+Key (Pressing the Control and the key)
				//
				// https://en.wikipedia.org/wiki/ASCII#ASCII_control_characters
				if (byte < 32 || byte == 127) {

					switch (byte) {

						// Common control characters
						// -------------------------

						case 27: // ESC \e ^[
							// Start an ESCAPE sequence.
							_keyCode.add(byte);
							continue;

						case 8:  // BS - Backspace \b ^H
						case 127:// DEL - Delete ^?
							deleteBackwards();
							break;

						case 10: // LF  - Line Feed \n ^J
						case 13: // CR  - Carriage Return \r ^M
							sendLine = true;
							break;

						// The rest of the control characters
						// ----------------------------------

						case 0:  // NUL - null \0 ^@
						case 3:  // ETX - End of text ^C
						case 4:  // EOT - End of transmission ^D
							// IDEA: bye
						case 5:  // ENQ - Enquiry ^E
						case 6:  // ACK - Acknowledgement ^F
						case 7:  // BEL - Bell \a ^G
						case 9:  // HT - Horizontal Tab \t ^I
							// IDEA: autocompletion
						case 11: // VT  - Vertical Tab \ ^v
						case 12: // FF  - Form Feed \f ^L
						case 14: // SO  - Shift Out ^N
						case 15: // SI  - Shift In ^O
						case 16: // DLE - Data Link Escape ^P
						case 17: // DC1 - Device Control 1 (XON) ^Q
						case 18: // DC2 - Device Control 2 ^R
						case 19: // DC3 - Device Control 3 (XOFF) ^S
						case 20: // DC4 - Device Control 4 ^T
						case 21: // NAK - Negative Acknowledgement ^U
						case 22: // SYN - Synchronous Idle ^V
						case 23: // ETB - End of Transmission Block ^W
						case 24: // CAN - Cancel ^X
						case 25: // EM  - End of Medium ^Y
						case 26: // SUB - Substitute ^Z
						case 28: // FS  - File Separator ^\
						case 29: // GS  - Group Separator ^]
						case 30: // RS  - Record Separator ^^
						case 31: // US  - Unit Separator ^_
							continue;
					}
				}

				// Returns `null` if no bytes preceeded the end of input.
				else if (byte < 0) {
					throw "CHECK: (byte < 0)"; //TEMP DEBUG if this is necessary.
					if (_lineCodePoints.isEmpty) return null;
					break;
				}

				// The rest of the characters.
				else {

					// Add the byte to the temporary code points list,
					// which will be parsed depending on the encoding.
					_codeUnits.add(byte);
				}

				// If we are supporting UTF8.
				if (encoding.name == UTF8.name) {

					// Detect if the byte is part of a multi-byte UTF-8 sequence.
					if (byte & 128 == 128) { // 10000000
						// a 2+ byte sequence.
						if (byte & 64 == 64) { // 01000000
							_UTF8RemainingChars++;
							// a 3+ byte sequence.
							if (byte & 32 == 32) { // 00100000
								_UTF8RemainingChars++;
								// a 4 byte sequence.
								if (byte & 16 == 16) { // 00010000
									_UTF8RemainingChars++;
								}
							}
						} else {
							_UTF8RemainingChars--;
						}

						// Make sure to update the line only after receiving
						// the last character of the unicode sequence in progress.
						if (_UTF8RemainingChars > 0) continue;
					}
				}
			}


			// The continuation of a key-code sequence
			// ---------------------------------------
			else {

				// Determining the 2nd byte...
				if (_keyCode.length == 1) {

					// Of a ESCAPE sequence.
					if(_keyCode.single == 27 ) {

						// Support these sequences paths:
						switch (byte) {
							case 79:
							case 91:
								_keyCode.add(byte);
								continue;
						}
					}
				}

				// Determining the 3+ bytes...
				else {

					// Of a ESCAPE sequence.
					if (_keyCode[0] == 27) {

						// home, end ...
						//
						// 27 79
						if (_keyCode[1] == 79) {

							switch (byte) {

								// End (27 79 70)
								case 70:
									cursorEnd();
									break;

								// Home (27 79 72)
								case 72:
									cursorHome();
									break;
							}

							_keyCode.clear();

						}

						// arrow keys, delete, numeric: home, end...
						// F5-F12, control + arrow keys (FIXME <F9>)
						//
						// 27 91
						else if (_keyCode[1] == 91) {

							// NOTE: add nesting level here: lenght > 2
							// 27 91 49 59 53 68 0 ctl-left
							// 27 91 49 59 53 67 0 ctl-right
							// if (_keyCode.length > 2)  TODO FIXME TEMP

							switch (byte) {

								// 27 91 65
								case 65: // Up arrow (27 91 65)
									historyPrevious();
									_keyCode.clear();
									continue;

								// 27 91 66
								case 66: // Down arrow (27 91 66)
									historyNext();
									_keyCode.clear();
									continue;

								//
								case 67: // Right arrow (27 91 67)
									cursorRight();
									_keyCode.clear();
									continue;

								case 68: // Left arrow (27 91 68)
									cursorLeft();
									_keyCode.clear();
									continue;

								// Preludes for byte 126.
								case 49: // home(>126) ctrl+left(>59 53 68)
								case 50: // F9-F12, insert
								case 51: // delete
								case 52: // end
								case 53: // pgup
								case 54: // pgdown
									_keyCode.add(byte);
									continue;

								case 126:
									// Delete (27 91 51 126)
									if(_keyCode[2] == 51) {
										deleteForward();

									// Home (27 91 49 126)
									} else if (_keyCode[2] == 49) {
										cursorHome();

									// End (27 91 52 126)
									} else if (_keyCode[2] == 52) {
										cursorEnd();

									// PgUp (27 91 53 126)
									} else if (_keyCode[2] == 53) {

									// PgDown (27 91 64 126)
									} else if (_keyCode[2] == 54) {

									// TODO: add: F5-F12
									// http://www.murga-linux.com/puppy/viewtopic.php?t=63539&sid=6bfc5ec76447c71821cfee88c2d48fc6
									}

									_keyCode.clear();
									break;
									
								// Case...


							} // switch byte

						} // [1] == 91 

					} // [0] == 27

				} // _keyCode.length > 1

			} // _keyCode.isEmpty | isNotEmpty


			// Insert Code point
			// -----------------

			if (_codeUnits.isNotEmpty) {

				// Insert a new UTF code point.
				_lineCodePoints.insert(_lineCursorIndex, encoding.decode(_codeUnits, allowMalformed: true).runes.single);
				// Update the cursor position.
				_lineCursorIndex++;

				// Clear the temporary list of UTF-8 code units.
				_codeUnits.clear();
			}

			// Update line
			// -----------

			// Converts the list of code points into a string.
			_lineString = new String.fromCharCodes(_lineCodePoints);

			// Updates the terminal.
			if (_lineCodePoints.length > columns) {
				// TODO: make it work with multi-line input
			}
			ANSI.overwriteLine(_lineString);

			// Updates the cursor.
			ANSI.moveToColumn(_lineCursorIndex + 1);


		// End the byte reading loop
		} while (!sendLine);


		// Send line
		// ---------

		stdin.echoMode = true;
		stdin.lineMode = true;

		// Clear the line
		_lineCodePoints.clear();
		_lineCursorIndex = 0;

		return _lineString;

	} // _readLineSync()

}

library forandar.cli.terminal;

import 'dart:convert';
import 'dart:io';

// Core
import 'package:forandar/src/core/errors.dart';

// Cli
import 'package:forandar/src/cli/xterm_control.dart';
import 'package:forandar/src/cli/xterm_keycodes.dart';

class Terminal {

  // A representation of the terminal line in UTF code points (runes).
  static List<int> _lineCodePoints = [];

  // The current cursor position in the line.
  static int _lineCursorIndex = 0;

  /// The number of characters in the current line.
  static int get lineLength => _lineCodePoints.length;

  /// The number of columns of the current terminal.
  static int get columns {
    try {
      return stdout.terminalColumns;
    } catch (e) {
      // BUG INFO issue #1
      throw "Please run forandar with `dart bin/forandar.dart` to use the xterm terminal type.\nSee https://github.com/andamira/forandar/issues/1/ for more info.\n\n$e";
    }
  }

  /// The number of rows of the current terminal.
  static int get lines {
    try {
      return stdout.terminalLines;
    } catch (e) {
      // BUG INFO issue #1
      throw "Please run forandar with `dart bin/forandar.dart` to use the xterm terminal type.\nSee https://github.com/andamira/forandar/issues/1/ for more info.\n\n$e";
    }
  }

  // Signals CHECK
  static Stream get onSIGINT => ProcessSignal.SIGINT.watch();
  static Stream get onResize => ProcessSignal.SIGWINCH.watch();


  // Inner properties for interpretation REFACTOR


  // A flag for sending the line.
  static bool lineIsComplete = false;

  // Store a list of bytes that represents a key code.
  static final List<int> keyCode = [];

  // A counter to keep track of remaining UTF-8 code points.
  static int _UTF8RemainingChars = 0;



  static void cursorHome() {
    _lineCursorIndex = 0;
    XTerm.moveToColumn(0);
  }

  /// Moves the cursor to the end of the line.
  static void cursorEnd() {
    _lineCursorIndex = lineLength;
    XTerm.moveToColumn(lineLength);
  }

  /// Moves the cursor to the left.
  static void cursorLeft() {
    if (_lineCursorIndex > 0 && lineLength > 0) {
      XTerm.cursorBack();
      _lineCursorIndex--;
    }
  }

  /// Moves the cursor to the right.
  static void cursorRight() {
    if (_lineCursorIndex < lineLength) {
      XTerm.cursorForward();
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
    } catch(e, st) {
      stdin.echoMode = true;
      stdin.lineMode = true;
      print(ForthError.unmanaged("$e\n$st"));
      return "";
    }
  }

  static String _readLineSync({encoding: UTF8}) {

    // A temporary list of bytes for UTF-8 multi-byte conversion.
    final List<int> _codeUnits = [];

    // A representation of the terminal line as a [String].
    String _lineString = "";

    // XTerm.mouseOn(); // TEMP

    stdin.echoMode = false;
    stdin.lineMode = false;

    // Byte reading loop.
    do {
      int byte = stdin.readByteSync();

      // print(byte); // DEBUG

      // A single char (or the first of a sequence)
      if (keyCode.isEmpty) {

        // Returns `null` if no bytes preceeded the end of input.
        if (byte < 0) {
          throw "Warning: (byte < 0)"; // CHECK if this is necessary.
          if (_lineCodePoints.isEmpty) return null;
          break;
        }

        // ASCII control characters.
        else if (byte < 32 || byte == 127) {
          if (KeyCodes.asciiControl(byte)) continue;
        }

        // In any other case, add the byte to the temporary code points list,
        else { _codeUnits.add(byte); }

        // UTF8 decoding.
        if (encoding.name == UTF8.name) {
          if (_detectUTF8Byte(byte)) continue;
        }
      }

      // The continuation of a key-code sequence
      else {

        // Determine the 2nd byte
        if (keyCode.length == 1) {

          if(keyCode.single == 27 ) { // Of a ESCAPE sequence
            if (KeyCodes.sequence27(byte)) continue;
          }

        // Determine the 3rd byte or more
        } else {

          if (keyCode[1] == 79) { // 27 79
            if (KeyCodes.sequence27_79(byte)) continue;
          }

          else if (keyCode[1] == 91) { // 27 91
            if (KeyCodes.sequence27_91(byte)) continue;
          }
        }
      }


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
      XTerm.overwriteLine(_lineString);

      // Updates the cursor.
      XTerm.moveToColumn(_lineCursorIndex + 1);


    // End the byte reading loop
    } while (!lineIsComplete);


    // Sends a completed line
    // ----------------------
    lineIsComplete = false;

    stdin.echoMode = true;
    stdin.lineMode = true;

    // Clear the line
    _lineCodePoints.clear();
    _lineCursorIndex = 0;

    // XTerm.mouseOff(); // TEMP

    return _lineString;

  } // _readLineSync()


  /// Returns true if the byte is part of a multi-byte UTF-8 sequence.
  static bool _detectUTF8Byte(int byte) {

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
      if (_UTF8RemainingChars > 0) return true;
    }
    return false;
  }
}

library forandar.cli.xterm_keycodes;

import 'package:forandar/src/cli/terminal.dart';

class KeyCodes {

  // Return this value to read the next byte  without updating the line.
  static const bool readNextByte = false;

  // Return this value to update line line after reading the next byte.
  static const bool updateLine = false;


  // Parse ASCII control characters.
  //
  // ^Key means Ctrl+Key (Pressing the Control and the key)
  //
  // https://en.wikipedia.org/wiki/ASCII#ASCII_control_characters
  // http://bjh21.me.uk/all-escapes/all-escapes.txt
  static bool asciiControl(int byte) {

    switch (byte) {

      // Common control characters
      // -------------------------

      case 27: // ESC \e ^[
        // Start an ESCAPE sequence.
        Terminal.keyCode.add(byte);
        return(readNextByte);

      case 8:  // BS - Backspace \b ^H
      case 127:// DEL - Delete ^?
        Terminal.deleteBackwards();
        return(updateLine);

      case 10: // LF  - Line Feed \n ^J
      case 13: // CR  - Carriage Return \r ^M
        Terminal.lineIsComplete = true;
        return(updateLine);

      // The rest of the control characters
      // ----------------------------------
      case 0:  // NUL - null \0 ^@
      case 1:  // SOH - Start of heading ^A
      case 2:  // STX - Start of text  ^B
      //case 3:  // ETX - End of text ^C SIGINT !!!
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
      //case 26: // SUB - Substitute ^Z  SIG??? !!!
      case 28: // FS  - File Separator ^\
      case 29: // GS  - Group Separator ^]
      case 30: // RS  - Record Separator ^^
      case 31: // US  - Unit Separator ^_
        return(readNextByte);
    }
  }

  /// Parse a key-code sequence: 27 79 KEY 
  static sequence27(byte) {

    switch (byte) {

      // Part of a 3+ byte sequence
      // --------------------------
      case 79:  // 27 79
      case 91:  // 27 91
      case 195: // 27 195 (e.g. ctrl-alt-ñ)
        Terminal.keyCode.add(byte); // XXX CHECK
        return(readNextByte);

      // Control + Alt + Key
      // -------------------

      case 0:  // 27  0 : ???
      case 1:  // 27  1 : ctrl-alt-a
      case 2:  // 27  2 : ctrl-alt-b
    //  case 3:  // 27  3 : ctrl-alt-c SIGINT !!!
      case 4:  // 27  4 : ctrl-alt-d
      case 5:  // 27  5 : ctrl-alt-e
      case 6:  // 27  6 : ctrl-alt-f
      case 7:  // 27  7 : ctrl-alt-g
      case 8:  // 27  8 : ctrl-alt-h
      case 9:  // 27  9 : ctrl-alt-i
      case 10: // 27 10 : ctrl-alt-j ctrl-alt-Enter
      case 11: // 27 11 : ctrl-alt-k
      case 12: // 27 12 : ctrl-alt-l
      case 13: // 27 13 : ctrl-alt-m
      case 14: // 27 14 : ctrl-alt-n
      case 15: // 27 15 : ctrl-alt-o
      case 16: // 27 16 : ctrl-alt-p
      case 17: // 27 17 : ctrl-alt-q
      case 18: // 27 18 : ctrl-alt-r
      case 19: // 27 19 : ctrl-alt-s
      case 20: // 27 20 : ctrl-alt-t
      case 21: // 27 21 : ctrl-alt-u
      case 22: // 27 22 : ctrl-alt-v
      case 23: // 27 23 : ctrl-alt-w
      case 24: // 27 24 : ctrl-alt-x
      case 25: // 27 25 : ctrl-alt-y
    //  case 26: // 27 26 : ctrl-alt-z SIG??? !!!
      case 27: // 27 27 : ctrl-alt-Escape
      case 28: // 27 28 : ctrl-alt- TODO
      case 29: // 27 29 : ctrl-alt- TODO
      case 30: // 27 30 : ctrl-alt- TODO
      case 31: // 27 31 : ctrl-alt-_
      case 32: // 27 32 : ctrl-alt-Space
      case 33: // 27 33 : ctrl-alt-!
      case 34: // 27 34 : ctrl-alt-"
      case 35: // 27 35 : ctrl-alt-#
      case 36: // 27 36 : ctrl-alt-$
      case 37: // 27 37 : ctrl-alt-%
      case 38: // 27 38 : ctrl-alt-&

      case 40: // 27 40 : ctrl-alt-(
      case 41: // 27 41 : ctrl-alt-)
      case 42: // 27 42 : ctrl-alt-*
      case 43: // 27 43 : ctrl-alt-+
      case 44: // 27 44 : ctrl-alt-,

      case 46: // 27 46 : ctrl-alt-.
      case 47: // 27 47 : ctrl-alt-/
        Terminal.keyCode.clear();
        return(readNextByte);

      // Shift + Alt + Key
      // -----------------

      case 58: // 27 58 : shift-alt-:
      case 59: // 27 59 : shift-alt-;

      case 61: // 27 61 : shift-alt-=
      case 63: // 27 63 : shift-alt-?

      case 65: // 27 65 : shift-alt-A
      case 66: // 27 66 : shift-alt-B
      case 67: // 27 67 : shift-alt-C
      case 68: // 27 68 : shift-alt-D
      case 69: // 27 69 : shift-alt-E
      case 70: // 27 70 : shift-alt-F
      case 71: // 27 71 : shift-alt-G
      case 72: // 27 72 : shift-alt-H
      case 73: // 27 73 : shift-alt-I
      case 74: // 27 74 : shift-alt-J
      case 75: // 27 75 : shift-alt-K
      case 76: // 27 76 : shift-alt-L
      case 77: // 27 77 : shift-alt-M
      case 78: // 27 78 : shift-alt-N
      case 79: // 27 79 : shift-alt-O
      case 80: // 27 80 : shift-alt-P
      case 81: // 27 81 : shift-alt-Q
      case 82: // 27 82 : shift-alt-R
      case 83: // 27 83 : shift-alt-S
      case 84: // 27 84 : shift-alt-T
      case 85: // 27 85 : shift-alt-U
      case 86: // 27 86 : shift-alt-V
      case 87: // 27 87 : shift-alt-W
      case 88: // 27 88 : shift-alt-X
      case 89: // 27 89 : shift-alt-Y
      case 90: // 27 90 : shift-alt-Z

      case 127: // 27 127 : shift-alt-Backspace
        Terminal.keyCode.clear();
        return(readNextByte);
    }
  }

  /// Parse a key-code sequence: 27 79 KEY {KEYS}
  static sequence27_79(byte) {

    if (Terminal.keyCode.length == 2) {

      switch (byte) {

        case 70: // End (27 79 70)
          Terminal.cursorEnd();
          Terminal.keyCode.clear();
          return(readNextByte);

        case 72: // Home (27 79 72)
          Terminal.cursorHome();
          Terminal.keyCode.clear();
          return(readNextByte);

        case 80: // F1 (27 79 80)
        case 81: // F2 (27 79 81)
        case 82: // F3 (27 79 82)
        case 83: // F4 (27 79 83)
          Terminal.keyCode.clear();
          return(readNextByte);

        // Save code for a 6 byte sequence 
        case 49: // (27 79 49 59 BYTE BYTE)
          Terminal.keyCode.add(byte);
          return(updateLine);
      }

    } // 27 79 KEY

    // We already have 3 bytes
    else {

      if (Terminal.keyCode.length == 3) {
      }

    }
  } // _sequence27_79()

  /// Parse a key-code sequence: 27 91 KEY {KEYS}
  static sequence27_91(byte) {

    if (Terminal.keyCode.length == 2) {

      switch (byte) {

        case 65: // Up arrow (27 91 65)
          Terminal.historyPrevious();
          Terminal.keyCode.clear();
          return(readNextByte);

        case 66: // Down arrow (27 91 66)
          Terminal.historyNext();
          Terminal.keyCode.clear();
          return(readNextByte);

        case 67: // Right arrow (27 91 67)
          Terminal.cursorRight();
          Terminal.keyCode.clear();
          return(readNextByte);

        case 68: // Left arrow (27 91 68)
          Terminal.cursorLeft();
          Terminal.keyCode.clear();
          return(readNextByte);

        // Preludes for byte 126.
        case 49: // home(>126) ctrl+left(>59 53 68)
        case 50: // F9-F12, insert
        case 51: // delete
        case 52: // end
        case 53: // pgup
        case 54: // pgdown
          Terminal.keyCode.add(byte);
          return(readNextByte);

        // Preludes for Mouse code!
        case 77:
          Terminal.keyCode.add(byte);
          return(readNextByte);

      }

    } // 27 91 KEY

    // We have more than 2 bytes
    else {
      // TODO add support for:
      // 27 91 49 59 53 68 ctl-left
      // 27 91 49 59 53 67 ctl-right
      // F5-F12: http://www.murga-linux.com/puppy/viewtopic.php?t=63539&sid=6bfc5ec76447c71821cfee88c2d48fc6

      // We have 3 bytes
      if (Terminal.keyCode.length == 3) {

        switch (byte) {

          case 126: // NOTE this byte can only be at the end
            switch (Terminal.keyCode[2]) {
              case 49: // Home (27 91 49 126)   CHECK 49 as control char
                Terminal.cursorHome();
                break;
              case 50: // Insert (27 91 50 126) CHECK 50 as control char
                break;
              case 51: // Delete (27 91 51 126)
                Terminal.deleteForward();
                break;
              case 52: // End (27 91 52 126)
                Terminal.cursorEnd();
                break;
              case 53: // PgUp (27 91 53 126)
                break;
              case 54: // PgDown (27 91 64 126)
                break;
            }
            Terminal.keyCode.clear();
            return(updateLine);

          case 32: // Mouse press. Next 2 bytes will be X & Y
          case 35: // Mouse release. Next 2 bytes will be X & Y
            Terminal.keyCode.add(byte);
            return(readNextByte);

          default:
            print(" OTHER len3 byte: $byte"); //TEMP
            Terminal.keyCode.add(byte);
            return(readNextByte);

        }

      } // 3 bytes

      // We have more than 3 bytes (27 91 ...)
      else {

        // Check for mouse coordinates
        if (Terminal.keyCode[2] == 77) {

          // X coordinate
          if (Terminal.keyCode.length == 4) {
            if (Terminal.keyCode[3] == 32) {
              print("mouse press x: ${byte-32}"); //TEMP
            } else {
              print("mouse release x: ${byte-32}"); //TEMP
            }
            Terminal.keyCode.add(byte);
            return(readNextByte);

          // Y coordinate
          } else {
            if (Terminal.keyCode[3] == 32) {
              print("mouse press y: ${byte-32}"); //TEMP
            } else {
              print("mouse release y: ${byte-32}"); //TEMP
            }
            Terminal.keyCode.clear();
            return(readNextByte);
          }
        }

        print("more than 3: $byte"); //TEMP

        // TODO: check if == 4
          // case 126 ...

        // TEMP
        Terminal.keyCode.add(byte);
        return(readNextByte);
      }

    } // > 2 bytes

  } // sequence27_91()

}

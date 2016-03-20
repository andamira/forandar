library forandar.core.errors;

import 'package:stack_trace/stack_trace.dart';

// Core
import 'package:forandar/src/core/globals.dart';

/// An instance of a specific Forth Error.
class ForthError implements Error {

  StackTrace stackTrace;

  int number;
  String errStr;
  String preMsg;
  String postMsg;

  /// Returns the error message and a terse stack trace.
  ///
  /// This is a beautifier for errors not managed by this class.
  /// Ideally all errors that pop up should be instances of ForthError.
  static String unmanaged(String error, {String preMsg, String postMsg}) {
    preMsg == null ? preMsg = 'Forth Unmanaged Error: ' : preMsg =  "$preMsg ";
    postMsg == null ? postMsg = '' : postMsg = " $postMsg";

    return "\n${preMsg}${error}${postMsg}\n${new Trace.current().terse}";
  }

  ForthError(this.number, {this.preMsg, this.postMsg}) {

    this.stackTrace = new Trace.current().terse;

    switch (number) {

      // Forth Standard Errors

      case -1:
        errStr = 'ABORT'; // Aborted
        break;
      case -2:
        errStr = 'ABORT"';
        break;
      case -3:   // used
        errStr = 'stack overflow';
        break;
      case -4:   // used
        errStr = 'stack underflow';
        break;
      case -5:   // used
        errStr = 'return stack overflow';
        break;
      case -6:   // used
        errStr = 'return stack underflow';
        break;
      case -7:
        errStr = 'do-loops nested too deeply during execution';
        break;
      case -8:
        errStr = 'dictionary overflow';
        break;
      case -9:
        errStr = 'invalid memory address';
        break;
      case -10:
        errStr = 'division by zero';
        break;
      case -11:
        errStr = 'result out of range';
        break;
      case -12:
        errStr = 'argument type mismatch';
        break;
      case -13:  // used
        errStr = 'undefined word';
        break;
      case -14:  // used
        errStr = 'interpreting a compile-only word';
        break;
      case -15:
        errStr = 'invalid FORGET';
        break;
      case -16:
        errStr = 'attempt to use zero-length string as a name';
        break;
      case -17:
        errStr = 'pictured numeric output string overflow';
        break;
      case -18:
        errStr = 'parsed string overflow';
        break;
      case -19:
        errStr = 'definition name too long';
        break;
      case -20:
        errStr = 'write to a read-only location';
        break;
      case -21:
        errStr = 'unsupported operation'; // (e.g., AT-XY on a too-dumb terminal)';
        break;
      case -22:
        errStr = 'control structure mismatch';
        break;
      case -23:
        errStr = 'address alignment exception';
        break;
      case -24:
        errStr = 'invalid numeric argument';
        break;
      case -25:
        errStr = 'return stack imbalance';
        break;
      case -26:
        errStr = 'loop parameters unavailable';
        break;
      case -27:
        errStr = 'invalid recursion';
        break;
      case -28:
        errStr = 'user interrupt';
        break;
      case -29:
        errStr = 'compiler nesting';
        break;
      case -30:
        errStr = 'obsolescent feature';
        break;
      case -31:
        errStr = '>BODY used on non-CREATEd definition';
        break;
      case -32:
        errStr = 'invalid name argument'; // (e.g., TO name)
        break;
      case -33:
        errStr = 'block read exception';
        break;
      case -34:
        errStr = 'block write exception';
        break;
      case -35:
        errStr = 'invalid block number';
        break;
      case -36:
        errStr = 'invalid file position';
        break;
      case -37:
        errStr = 'file I/O exception';
        break;
      case -38:
        errStr = 'non-existent file';
        break;
      case -39:
        errStr = 'unexpected end of file';
        break;
      case -40:
        errStr = 'invalid BASE for floating point conversion';
        break;
      case -41:
        errStr = 'loss of precision';
        break;
      case -42:
        errStr = 'floating-point divide by zero';
        break;
      case -43:
        errStr = 'floating-point result out of range';
        break;
      case -44:  // used
        errStr = 'floating-point stack overflow';
        break;
      case -45:  // used
        errStr = 'floating-point stack underflow';
        break;
      case -46:
        errStr = 'floating-point invalid argument';
        break;
      case -47:
        errStr = 'compilation word list deleted';
        break;
      case -48:
        errStr = 'invalid POSTPONE';
        break;
      case -49:
        errStr = 'search-order overflow';
        break;
      case -50:
        errStr = 'search-order underflow';
        break;
      case -51:
        errStr = 'compilation word list changed';
        break;
      case -52:  // used
        errStr = 'control-flow stack overflow';
        break;
      case -53:  // used
        errStr = 'exception stack overflow';
        break;
      case -54:
        errStr = 'floating-point underflow';
        break;
      case -55:
        errStr = 'floating-point unidentified fault';
        break;
      case -56:
        errStr = 'QUIT';
        break;
      case -57:
        errStr = 'exception in sending or receiving a character'; // gforth says error
        break;
      case -58:
        errStr = '[IF], [ELSE], or [THEN] exception';
        break;
      case -59:
        errStr = 'ALLOCATE';
        break;
      case -60:
        errStr = 'FREE';
        break;
      case -61:
        errStr = 'RESIZE';
        break;
      case -62:
        errStr = 'CLOSE-FILE';
        break;
      case -63:
        errStr = 'CREATE-FILE';
        break;
      case -64:
        errStr = 'DELETE-FILE';
        break;
      case -65:
        errStr = 'FILE-POSITION';
        break;
      case -66:
        errStr = 'FILE-SIZE';
        break;
      case -67:
        errStr = 'FILE-STATUS';
        break;
      case -68:
        errStr = 'FLUSH-FILE';
        break;
      case -69:
        errStr = 'OPEN-FILE';
        break;
      case -70:
        errStr = 'READ-FILE';
        break;
      case -71:
        errStr = 'READ-LINE';
        break;
      case -72:
        errStr = 'RENAME-FILE';
        break;
      case -73:
        errStr = 'REPOSITION-FILE';
        break;
      case -74:
        errStr = 'RESIZE-FILE';
        break;
      case -75:
        errStr = 'WRITE-FILE';
        break;
      case -76:
        errStr = 'WRITE-LINE';
        break;
      case -77:
        errStr = 'Malformed xchar';
        break;
      case -78:
        errStr = 'SUBSTITUTE';
        break;
      case -79:
        errStr = 'REPLACES';
        break;

      // Custom forandar Errors
      case -256:
        errStr = 'terminal input line is too long (>$inputBufferSize)';
        break;
      case -257:
        errStr = "word doesn't exist so it can't be overwritten";
        break;
    }
  }


  /// Constructor wrapper for stack overflow errors.
  ForthError.stackOverflow(StackType t, [dynamic error, String postMsg]) {

    // postMsg = "→ $postMsg"; // DEBUG
    postMsg = null;

    switch(t) {
      case StackType.dataStack:
        throw new ForthError(-3, postMsg: postMsg);

      case StackType.floatStack:
        throw new ForthError(-44, postMsg: postMsg);

      case StackType.returnStack:
        throw new ForthError(-5, postMsg: postMsg);

      case StackType.controlStack:
        throw new ForthError(-52, postMsg: postMsg);

      case StackType.exceptionStack:
        throw new ForthError(-53, postMsg: postMsg);

      case StackType.unknown:
        throw new ForthError(-3, preMsg: "unknown", postMsg: postMsg);

      default:
        print(ForthError.unmanaged(error));
    }
  }

  /// Constructor wrapper for stack underflow errors.
  ForthError.stackUnderflow(StackType t, [dynamic error, String postMsg]) {

    // postMsg = "→ $postMsg"; // DEBUG
    postMsg = null;

    switch(t) {
      case StackType.dataStack:
        throw new ForthError(-4, postMsg: postMsg);

      case StackType.floatStack:
        throw new ForthError(-45, postMsg: postMsg);

      case StackType.returnStack:
        throw new ForthError(-6, postMsg: postMsg);

      // NOTE: no standard errors for control & exception stacks underflow

      case StackType.unknown:
        throw new ForthError(-4, preMsg: "unknown", postMsg: postMsg);

      default:
        print(ForthError.unmanaged(error));
    }
  }


  @override
  String toString() {
    preMsg == null ? preMsg = '' : preMsg =  "$preMsg ";
    postMsg == null ? postMsg = '' : postMsg = " $postMsg";

    return "Error $number: ${preMsg}${errStr}${postMsg}";
  }
}


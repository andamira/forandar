library forandar.core.errors;

import 'globals.dart';

/// Manages errors.
throwError(int forthErrorNum, {String preMsg, String postMsg, var dartError}) {

	var forthError = new ForthError(forthErrorNum, preMsg, postMsg);

	if (forthError.toString() != '') {
		print("\n$forthError\n");

		// TODO improve debugging, stack trace
		if (dartError != null) print("$dartError");
	}
}

/// List of Forth Errors.
class ForthError implements Error {

	num err;
	String errStr;
	String preMsg;
	String postMsg;

	StackTrace get stackTrace => null; //TEMP FIXME

	ForthError(this.err, [this.preMsg, this.postMsg]) {
		switch (err) {

			// Forth Standard Errors

			case -1:
				errStr = 'ABORT'; // Aborted
				break;
			case -2:
				errStr = 'ABORT"';
				break;
			case -3:
				errStr = 'stack overflow';
				break;
			case -4:
				errStr = 'stack underflow';
				break;
			case -5:
				errStr = 'return stack overflow';
				break;
			case -6:
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
			case -13:
				errStr = 'undefined word';
				break;
			case -14:
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
			case -44:
				errStr = 'floating-point stack overflow';
				break;
			case -45:
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
			case -52:
				errStr = 'control-flow stack overflow';
				break;
			case -53:
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

			case -2048:
				errStr = 'not a word, not a number (not understood)';
				break;
			case -2049:
				errStr = "word doesn't exist so it can't be overwritten";
				break;
			case -2050:
				errStr = 'terminal input line is too long (>$inputBufferSize)';
				break;

			// For testing.
			case -4095:
				errStr = '';
				break;
		}
	}

	@override
	String toString() {
		preMsg == null ? preMsg = '' : preMsg =  "$preMsg ";
		postMsg == null ? postMsg = '' : postMsg = " $postMsg";

		if (errStr == '' && preMsg == '' && postMsg == '') return '';

		return "Error ${err}: ${preMsg}${errStr}${postMsg}";
	}
}


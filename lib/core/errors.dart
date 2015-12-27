part of forandar;


/// Manages errors.
throwError(FormatException dartError, ForthError forthError) {
	// TEMP
	print("$forthError » $dartError");
}

/// List of Forth Errors
class ForthError implements Error {

	num err;
	String errStr;

	ForthError(this.err) {
		switch (this.err) {

			// Forth Standard Errors

			case -1:
				this.errStr = 'ABORT'; // Aborted
				break;
			case -2:
				this.errStr = 'ABORT"';
				break;
			case -3:
				this.errStr = 'stack overflow';
				break;
			case -4:
				this.errStr = 'stack underflow';
				break;
			case -5:
				this.errStr = 'return stack overflow';
				break;
			case -6:
				this.errStr = 'return stack underflow';
				break;
			case -7:
				this.errStr = 'do-loops nested too deeply during execution';
				break;
			case -8:
				this.errStr = 'dictionary overflow';
				break;
			case -9:
				this.errStr = 'invalid memory address';
				break;
			case -10:
				this.errStr = 'division by zero';
				break;
			case -11:
				this.errStr = 'result out of range';
				break;
			case -12:
				this.errStr = 'argument type mismatch';
				break;
			case -13:
				this.errStr = 'undefined word';
				break;
			case -14:
				this.errStr = 'interpreting a compile-only word';
				break;
			case -15:
				this.errStr = 'invalid FORGET';
				break;
			case -16:
				this.errStr = 'attempt to use zero-length string as a name';
				break;
			case -17:
				this.errStr = 'pictured numeric output string overflow';
				break;
			case -18:
				this.errStr = 'parsed string overflow';
				break;
			case -19:
				this.errStr = 'definition name too long';
				break;
			case -20:
				this.errStr = 'write to a read-only location';
				break;
			case -21:
				this.errStr = 'unsupported operation'; // (e.g., AT-XY on a too-dumb terminal)';
				break;
			case -22:
				this.errStr = 'control structure mismatch';
				break;
			case -23:
				this.errStr = 'address alignment exception';
				break;
			case -24:
				this.errStr = 'invalid numeric argument';
				break;
			case -25:
				this.errStr = 'return stack imbalance';
				break;
			case -26:
				this.errStr = 'loop parameters unavailable';
				break;
			case -27:
				this.errStr = 'invalid recursion';
				break;
			case -28:
				this.errStr = 'user interrupt';
				break;
			case -29:
				this.errStr = 'compiler nesting';
				break;
			case -30:
				this.errStr = 'obsolescent feature';
				break;
			case -31:
				this.errStr = '>BODY used on non-CREATEd definition';
				break;
			case -32:
				this.errStr = 'invalid name argument'; // (e.g., TO name)
				break;
			case -33:
				this.errStr = 'block read exception';
				break;
			case -34:
				this.errStr = 'block write exception';
				break;
			case -35:
				this.errStr = 'invalid block number';
				break;
			case -36:
				this.errStr = 'invalid file position';
				break;
			case -37:
				this.errStr = 'file I/O exception';
				break;
			case -38:
				this.errStr = 'non-existent file';
				break;
			case -39:
				this.errStr = 'unexpected end of file';
				break;
			case -40:
				this.errStr = 'invalid BASE for floating point conversion';
				break;
			case -41:
				this.errStr = 'loss of precision';
				break;
			case -42:
				this.errStr = 'floating-point divide by zero';
				break;
			case -43:
				this.errStr = 'floating-point result out of range';
				break;
			case -44:
				this.errStr = 'floating-point stack overflow';
				break;
			case -45:
				this.errStr = 'floating-point stack underflow';
				break;
			case -46:
				this.errStr = 'floating-point invalid argument';
				break;
			case -47:
				this.errStr = 'compilation word list deleted';
				break;
			case -48:
				this.errStr = 'invalid POSTPONE';
				break;
			case -49:
				this.errStr = 'search-order overflow';
				break;
			case -50:
				this.errStr = 'search-order underflow';
				break;
			case -51:
				this.errStr = 'compilation word list changed';
				break;
			case -52:
				this.errStr = 'control-flow stack overflow';
				break;
			case -53:
				this.errStr = 'exception stack overflow';
				break;
			case -54:
				this.errStr = 'floating-point underflow';
				break;
			case -55:
				this.errStr = 'floating-point unidentified fault';
				break;
			case -56:
				this.errStr = 'QUIT';
				break;
			case -57:
				this.errStr = 'exception in sending or receiving a character'; // gforth says error
				break;
			case -58:
				this.errStr = '[IF], [ELSE], or [THEN] exception';
				break;
			case -59:
				this.errStr = 'ALLOCATE';
				break;
			case -60:
				this.errStr = 'FREE';
				break;
			case -61:
				this.errStr = 'RESIZE';
				break;
			case -62:
				this.errStr = 'CLOSE-FILE';
				break;
			case -63:
				this.errStr = 'CREATE-FILE';
				break;
			case -64:
				this.errStr = 'DELETE-FILE';
				break;
			case -65:
				this.errStr = 'FILE-POSITION';
				break;
			case -66:
				this.errStr = 'FILE-SIZE';
				break;
			case -67:
				this.errStr = 'FILE-STATUS';
				break;
			case -68:
				this.errStr = 'FLUSH-FILE';
				break;
			case -69:
				this.errStr = 'OPEN-FILE';
				break;
			case -70:
				this.errStr = 'READ-FILE';
				break;
			case -71:
				this.errStr = 'READ-LINE';
				break;
			case -72:
				this.errStr = 'RENAME-FILE';
				break;
			case -73:
				this.errStr = 'REPOSITION-FILE';
				break;
			case -74:
				this.errStr = 'RESIZE-FILE';
				break;
			case -75:
				this.errStr = 'WRITE-FILE';
				break;
			case -76:
				this.errStr = 'WRITE-LINE';
				break;
			case -77:
				this.errStr = 'Malformed xchar';
				break;
			case -78:
				this.errStr = 'SUBSTITUTE';
				break;
			case -79:
				this.errStr = 'REPLACES';
				break;
				

			// forandar Errors


		}
	}

	@override
	String toString() {
		return "Error ${this.err} ${this.errStr}";
	}
}


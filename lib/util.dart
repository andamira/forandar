library util;

import "dart:math";

// Various utility functions.


/// Converts a 32bit integer to its binary representation.
String int32tobin(int number) {

	var str = new StringBuffer();

	for (var i = 32; i >= 0; i--) {
		var bit = 0; 
		if (number & pow(2,i) != 0) bit = 1;
		str.write(bit);
	}
	return str.toString();
}


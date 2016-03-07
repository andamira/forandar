/// Various utility functions.
library forandar.core.utility;

import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

/// Prefixes a string with leading zeros until a maximum [length].
///
/// If [forceLength] is true and the length of [origStrng] is longer
/// than [maxLength], the excess chars will be removed from the left.
String leadingZeros(String origStr, int maxLength, [forceLength=false]) {

	if (origStr.length < maxLength) {
		var zeroStr = new StringBuffer();
		for (int z = 0; z < maxLength - origStr.length; z++) {
			zeroStr.write("0");
		}
		zeroStr.write(origStr);
		return zeroStr.toString();

	} else if (origStr.length > maxLength && forceLength) {
		return origStr.substring(origStr.length - maxLength);
	}
	return origStr;
}

/// Converts a 32bit integer to its binary representation.
String int32ToBin(int number) {
	var str = new StringBuffer();
	for (var i = 32; i >= 0; i--) {
		var bit = 0; 
		if (number & pow(2,i) != 0) bit = 1;
		str.write(bit);
	}
	return str.toString();
}

//// Formats a list of Bytes as gforth DUMP does.
///
/// 7F8EA7AC02E0: 80 C0 19 99  99 8C 63 33 - 18 C6 63 31  98 CC 66 33  ......c3..c1..f3
/// 7F8EA7AC02F0: 33 33 33 33  33 33 33 33 - 19 99 99 99  99 99 99 99  33333333........
//
// TODO: redo it in Forth.
// use the current base to display the memory address.
String dumpBytes(Uint8List segment, int memOffset) {

	var str = new StringBuffer();
	var latin = new Latin1Decoder();

	int fullLines = segment.length ~/ 16;
	int restBytes = segment.length % 16;
	int totalLines = fullLines + (restBytes > 0 ? 1 : 0);

	for (var l = 0; l < totalLines; l++) {
		str.write("\n${leadingZeros((memOffset + l * 16).toString(), 12)}:");

		var lineOffset = l * 16;

		var lineLength = segment.length - lineOffset;
		if (lineLength > 16) lineLength = 16;

		Uint8List lineSegment= segment.sublist(lineOffset, lineOffset + lineLength);

		//
		// 80 C0 19 99  99 8C 63 33 - 18 C6 63 31  98 CC 66 33
		//
		// 2 groups of 8 bytes
		for (var a = 0; a < 2; a++ ) {
			if (a > 0) str.write("-");

			// 2 groups of 4 bytes, inside
			for (var b = 0; b < 2; b++ ) {
				str.write(" ");

				// 4 groups of 1 byte, inside
				for (var c = 0; c < 4; c++) {
					int lineIndex = a * 8 + b * 4 + c;

					if (lineIndex < lineLength) {
						str.write("${leadingZeros(lineSegment[lineIndex].toRadixString(16).toUpperCase(), 2)} ");
					} else {
						str.write("   ");
					}
				}
			}
		}
		str.write(" ");

		//
		// ......c3..c1..f3
		// 
		for (int x in lineSegment) {
			if (x < 32) {
				str.write(".");
			} else {
				str.write(latin.convert([x]));
			}
		}
	}
	return str.toString();
}

/// Returns the number of codeUnits necessary to encode a [codePoint] in UTF-8.
///
/// https://en.wikipedia.org/wiki/Comparison_of_Unicode_encodings#Eight-bit_environments
int UTF8CodeUnitsPerCodePoint(int codePoint) {
	if (codePoint <= 0x00007F) return 1;
	if (codePoint <= 0x0007FF) return 2;
	if (codePoint <= 0x00FFFF) return 3;
	return 4; // <= 0x10FFFF
}

/// Returns the number of codeUnits necessary to encode a list of code points in UTF-8.
int UTF8CodeUnitsPerCodePointsList(List<int> codePointsList) {
	int codeUnits = 0;
	for (int cp in codePointsList) {
		codeUnits += UTF8CodeUnitsPerCodePoint(cp);
	}
	return codeUnits;
}

/// Returns the number of bytes necessary to store a string in UTF-8. 
int UTF8StringSizeInBytes(String s) => UTF8.encode(s).length;


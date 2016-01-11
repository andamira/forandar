part of forandar;

/// Defines the [Forth standard CORE primitives][link].
///
/// [link]: http://forth-standard.org/standard/core/
void includeWordsStandardCore(VirtualMachine vm, Dictionary d) {

	// Total: 182 (133 main + 49 extended)
	//
	// Implemented:
	//
	// ! . - + 2DROP 2DUP ?DUP >R BASE DECIMAL DROP DUP IMMEDIATE OVER SWAP ROT
	//
	// NIP PICK TUCK
	//
	//
	// Not implemented:
	//
	// # #> #S ' ( * */ */MOD + +! +LOOP , - ." / /MOD 0< 0= 1+ 1- 2! 2* 2/
	// 2@ 2OVER 2SWAP : ; < <# = > >BODY >IN >NUMBER @ ABORT
	// ABORT" ABS ACCEPT ALIGN ALIGNED ALLOT AND BEGIN BL C! C, C@ CELL+
	// CELLS CHAR CHAR+ CHARS CONSTANT COUNT CR CREATE DEPTH DO DOES>
	// ELSE EMIT ENVIRONMENT? EVALUATE EXECUTE EXIT FILL FIND FM/MOD
	// HERE HOLD I IF INVERT J KEY LEAVE LITERAL LOOP LSHIFT M* MAX
	// MIN MOD MOVE NEGATE OR POSTPONE QUIT R> R@ RECURSE REPEAT RSHIFT
	// S" S>D SIGN SM/REM SOURCE SPACE SPACES STATE THEN TYPE U. U< UM*
	// UM/MOD UNLOOP UNTIL VARIABLE WHILE WORD XOR [ ['] [CHAR] ]
	//
	// .( .R 0<> 0> 2>R 2R> 2R@ :NONAME <> ?DO ACTION-OF AGAIN BUFFER: C"
	// CASE COMPILE, DEFER DEFER! DEFER@ ENDCASE ENDOF ERASE FALSE HEX HOLDS
	// IS MARKER OF PAD PARSE PARSE-NAME REFILL RESTORE-INPUT ROLL
	// S\" SAVE-INPUT SOURCE-ID TO TRUE U.R U> UNUSED VALUE WITHIN
	// [COMPILE] \

	/// Store x at a-addr.
	///
	/// [Store][link] ( x a-addr -- )
	/// [link]: http://forth-standard.org/standard/core/Store
	//
	// Stores an integer number using four bytes at the specified address.
	//
	// https://api.dartlang.org/stable/dart-typed_data/ByteData/setInt32.html
	// https://en.wikipedia.org/wiki/Two%27s_complement
	d.addWord("!", false, false, (){
		vm.dataSpace.data.setInt32(vm.dataStack.pop(), vm.dataStack.pop());
	});

	
	///
	d.addWord(".", false, false, (){
		print(vm.dataStack.pop());
	});

	///
	d.addWord("-", false, false, (){
		vm.dataStack.swap();
		vm.dataStack.push(vm.dataStack.pop() - vm.dataStack.pop());

		// TODO:BENCHMARKS
		// 1) swap:
		// 2) read without modifying and
	});

	///
	d.addWord("+", false, false, (){
		vm.dataStack.push(vm.dataStack.pop() + vm.dataStack.pop());
	});

	///
	d.addWord("DUP", false, false, vm.dataStack.dup);

	/// Duplicate cell pair x1 x2.
	///
	/// : [2DUP][link] ( x1 x2 -- x1 x2 x1 x2 )
	///   over over ;
	/// [link]: http://forth-standard.org/standard/core/TwoDUP
	d.addWord("2DUP", false, false, vm.dataStack.dup2);

	///
	d.addWord("?DUP", false, false, () {
		if (vm.dataStack.size > 0) vm.dataStack.dup();
	});

	/// Puts in the stack the address of a cell containing the current number-conversion radix {{2...36}}.
	///
	/// [BASE][link] ( -- a-addr )
	/// [link]: http://forth-standard.org/standard/core/BASE
	d.addWord("BASE", false, false, () {
		vm.dataStack.push(addrBASE);
	});

	/// Set the numeric conversion radix to ten (decimal).
	///
	/// [DECIMAL][link] ( -- a-addr )
	/// [link]: http://forth-standard.org/standard/core/BASE
	d.addWord("DECIMAL", false, false, () {
		vm.dataSpace.data.setInt32(addrBASE, 10);
	});

	/// Remove x from the stack.
	///
	/// [DROP][link] ( x -- )
	/// [link]: http://forth-standard.org/standard/core/DROP
	d.addWord("DROP", false, false, vm.dataStack.drop);

	/// Drop cell pair x1 x2 from the stack.
	///
	/// [2DROP][link] ( x1 x2 -- )
	/// [link]: http://forth-standard.org/standard/core/TwoDROP
	d.addWord("2DROP", false, false, vm.dataStack.drop2);

	/// Drop the first item below the top of stack.
	///
	/// ( x1 x2 -- x2 )
	d.addWord("NIP", false, false, vm.dataStack.nip);

	/// Place a copy of x1 on top of the stack.
	///
	/// [OVER][link] ( x1 x2 -- x1 x2 x1 )
	/// [link]: http://forth-standard.org/standard/core/OVER
	d.addWord("OVER", false, false, vm.dataStack.over);

	/// Remove u. Copy the xu to the top of the stack.
	///
	/// [PICK][link] ( xu...x1 x0 u -- xu...x1 x0 xu )
	/// [link]: http://forth-standard.org/standard/core/PICK
	d.addWord("PICK", false, false, () {
		vm.dataStack.pick(vm.dataStack.pop());
	});

	/// Exchange the top two stack items.
	///
	/// [SWAP][link] ( x1 x2 -- x2 x1 )
	/// [link]: http://forth-standard.org/standard/core/SWAP
	d.addWord("SWAP", false, false, vm.dataStack.swap);

	/// Copy the first (top) stack item below the second stack item.
	///
	/// [TUCK][link] ( x1 x2 -- x2 x1 x2 )
	/// [link]: http://forth-standard.org/standard/core/TUCK
	d.addWord("TUCK", false, false, vm.dataStack.tuck);

	/// Rotate the top three stack entries.
	///
	/// [ROT][link] ( x1 x2 x3 -- x2 x3 x1 )
	/// [link]: http://forth-standard.org/standard/core/ROT
	d.addWord("ROT", false, false, vm.dataStack.rot);

	/// Moves data FROM [dataStack] TO [returnStack].
	///
	/// [toR][link] ( x -- ) ( R: -- x )
	/// [link]: http://forth-standard.org/standard/core/toR
	d.addWord(">R", false, false, () {
		vm.returnStack.push(vm.dataStack.pop());
	});

	// Other Words

	/// Make the most recent definition an immediate word.
	///
	/// [IMMEDIATE][link] ( -- )
	/// [link]: http://forth-standard.org/standard/core/IMMEDIATE
	d.addWord("IMMEDIATE", false, false, () {
		d.wordsList.last.isImmediate = true;
	});
}

/// Core words that are not part of the standard.
///
void includeWordsNotStandardCore(VirtualMachine vm, Dictionary d) {

	///
	d.addWord("INTERPRET", false, false, () async {

		/// Creates a list with all the lines from the source code strings, files and URLs.
		await vm.input.fillSourceCodeLines();

		while (true) {

			/// Reads the next word.
			String wordStr = vm.input.nextWord();

			if (wordStr == null) {
				break;
			}

			/// Search for this word in the current dictionary.
			Word word = d.wordsMap[wordStr.toUpperCase()];

			if( word != null) {

				/// If this word is compile only and we are not in compile mode, throw err -14.
				if (word.isCompileOnly && !vm.inCompileMode) {

					throwError(e, new ForthError(-13));

				/// If this word != [isImmediate] and we are in compile mode, compile it.
				} else if (!word.isImmediate && vm.inCompileMode) {
					//print("TODO: compile: $wordStr"); // TEMP
					// ...

				/// Executes the word In any other case.
				} else {
					//print("execute: $wordStr"); // TEMP
					word.exec();
				}


			/// If the word is not found in the dictionary.
			} else {

				/// Tries to convert the word to a number.
				try {

					num number;
					bool isInt = true;
					int base = vm.dataSpace.data.getInt32(addrBASE);

					// First tries parsing the word to an integer in the current base.
					//
					// The interpreter shall recognize integer numbers in the form <anynum>.
					//
					//   <anynum> := { <BASEnum> | <decnum> | <hexnum> | <binnum> | <cnum> }
					//  <BASEnum> := [-]<bdigit><bdigit>*
					//   <decnum> := #[-]<decdigit><decdigit>*
					//   <hexnum> := $[-]<hexdigit><hexdigit>*
					//   <binnum> := %[-]<bindigit><bindigit>*
					//     <cnum> := '<char>'
					// <bindigit> := { 0 | 1 }
					// <decdigit> := { 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 }
					// <hexdigit> := { <decdigit> | a | b | c | d | e | f | A | B | C | D | E | F }
					//
					// <bdigit> represents a digit according to the value of BASE
					//
					// https://api.dartlang.org/stable/dart-core/int/parse.html
					number = int.parse(wordStr,
						radix: base == 10 ? null : base,
						onError: (wordStr) => null
					);

					// Then tries to parse it as any of the specific forms.
					if (number == null) {

						// The prefix of the string.
						String f = wordStr.substring(0,1);

						// Sets the base as decimal,
						if (f == '#' ) {
							base = 10;
						// or as hexadecimal
						} else if (f == r'$') {
							base = 16;
						// or as binary.
						} else if (f == '%') {
							base = 2;
						}

						// Tries to parse the rest of the string.
						number = int.parse(wordStr.substring(1), radix: base, onError: (wordStr) => null);

						// If it fails, then tries to parse it as a character.
						if (number == null && wordStr.length == 3 && f == "'" && wordStr.endsWith("'")) {
							number = wordStr.codeUnitAt(1);
						}

						// print("NUMBER $number; BASE $base; PREFIX $f"); // TEMP
					}


					// If it's not an integer, tries parsing it as a double cell.
					// TODO


					// If it's not an integer, or a double, tries parsing it as floating point.
					//
					// TODO
					// Must recognize floating-point numbers in this form:
					// Convertible string := <significand><exponent>
					// <significand> := [<sign>]<digits>[.<digits0>]
					// <exponent> := E[<sign>]<digits0>
					// <sign> := { + | - }
					// <digits> := <digit><digits0>
					// <digits0> := <digit>*
					// <digit> := { 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 }
					//
					// These are examples of valid representations of floating-point numbers in program source:
					// 1E    1.E    1.E0    +1.23E-1    -1.23E+1
					//
					// https://api.dartlang.org/stable/dart-core/double/parse.html
					if (number == null && base == 10) {
						number = double.parse(wordStr, (wordStr) => null);

						// If it's not a double either, throw an error.
						if (number == null) {
							throwError(e, new ForthError(-2048));
						} else {
							isInt = false;
						}
					}

					/// If we are compiling, compile the number in the data space.
					if (vm.inCompileMode) {
						// TODO

					/// If we are interpreting leave it on the stack.
					} else {

						// Integers go to the dataStack.
						if (isInt) {
							vm.dataStack.push(number.toInt());

						// Floats go to the floatStack.
						} else {
							vm.floatStack.push(number);
						}
					}


				/// If can't be converted, throw not-standard sys err "not a word not a number" (not understood).
				} catch(e) {
					throwError(e, new ForthError(-2048));
					print("WORD: $wordStr"); // TEMP
					break;
				}

			}
		}

		/// Loop ends when there are no more words.

	});

}

/// Useful words that are not part of the standard.
///
/// [Gforth Word Index][http://www.complang.tuwien.ac.at/forth/gforth/Docs-html/Word-Index.html#Word-Index]
void includeWordsNotStandardExtra(VirtualMachine vm, Dictionary d) {


	///
	d.addWord("-ROT", false, false, vm.dataStack.rotCC);

	/// Tries to find the name token nt of the word represented by xt.
	///
	/// Returns 0 if it fails.
	/// Note that in the current implementation xt and nt are exactly the same.
	/// [toName][link] ( xt -- nt|0 )
	/// [link]: http://www.complang.tuwien.ac.at/forth/gforth/Docs-html/Name-token.html
	//d.addWord(">NAME", false, false, () {}); // TODO

	/// Tries to find the name of the [Word] represented by nt.
	///
	/// Note that in the current implementation xt and nt are exactly the same.
	/// [nameToString][link] ( nt -- addr count )
	/// [link]: http://www.complang.tuwien.ac.at/forth/gforth/Docs-html/Name-token.html
	//d.addWord("NAME>STRING", false, false, () {}); // TODO

	/// ...
	///
	/// [id.][link] ( nt -- )  name>string type ;
	/// [link]: TODO
	//d.addWord("ID.", false, false, () {}); // TODO

	/// ...
	///
	/// [id.][link] ( nt -- )  name>string type ;
	/// [link]: TODO
	//d.addWord("ID.", false, false, () {}); // TODO

	/// Copy and display the values currently on the floating point stack.
	d.addWord(".FS", false, false, () {
		print("floatStack: ${vm.floatStack}");
	});

	// https://www.complang.tuwien.ac.at/forth/gforth/Docs-html/Floating-Point-Tutorial.html
	// fnip ftuck fpick
	// f~abs f~rel
}

/// The optional Floating-Point word set
///
/// http://forth-standard.org/standard/float
includeWordsStandardOptionalFloat(VirtualMachine vm, Dictionary d) {

	// Total: 79 (31 main + 48 extended)
	//
	// Implemented:
	//
	// D>F F! F* F+ F- F/ F>D FSWAP
	//
	// F** F. F>S
	//
	// Not Implemented:
	//
	// >FLOAT F0< F0= F< F@ FALIGN FALIGNED
	// FCONSTANT FDEPTH FDROP FDUP FLITERAL FLOAT+ FLOATS FLOOR
	// FMAX FMIN FNEGATE FOVER FROT FROUND FVARIABLE REPRESENT
	//
	// DF! DF@ DFALIGN DFALIGNED DFFIELD: DFLOAT+ DFLOATS
	// FABS FACOS FACOSH FALOG FASIN FASINH FATAN FATAN2 FATANH FCOS
	// FCOSH FE. FEXP FEXPM1 FFIELD: FLN FLNP1 FLOG FS. FSIN FSINCOS
	// FSINH FSQRT FTAN FTANH FTRUNC FVALUE F~ PRECISION S>F
	// SET-PRECISION SF! SF@ SFALIGN SFALIGNED SFFIELD: SFLOAT+ SFLOATS
	//

	/// r is the floating-point equivalent of d.
	///
	/// [DToF][link] ( d -- ) ( F: -- r ) 
	/// [link]: http://forth-standard.org/standard/float/DToF
	d.addWord("D>F", false, false, (){
		vm.floatStack.push(vm.dataStack.pop().toDouble());
	});

	/// Store r at f-addr.
	///
	/// [FStore][link] ( f-addr -- ) ( F: r -- )
	/// [link]: http://forth-standard.org/standard/float/FStore
	//
	// Stores a floating point number using eight bytes at the specified address.
	//
	// https://api.dartlang.org/stable/dart-typed_data/ByteData/setFloat64.html
	// https://en.wikipedia.org/wiki/Double-precision_floating-point_format
	d.addWord("F!", false, false, (){
		vm.dataSpace.data.setFloat64(vm.dataStack.pop(), vm.floatStack.pop());
	});

	/// Multiply r1 by r2 giving r3.
	///
	/// [FTimes][link] ( F: r1 r2 -- r3 )
	/// [link]: http://forth-standard.org/standard/float/FTimes
	d.addWord("F*", false, false, (){
		vm.floatStack.push(vm.floatStack.pop() * vm.floatStack.pop());
	});

	/// Add r1 to r2 giving the sum r3.
	///
	/// [FPlus][link] ( F: r1 r2 -- r3 )
	/// [link]: http://forth-standard.org/standard/float/FPlus 
	d.addWord("F+", false, false, (){
		vm.floatStack.push(vm.floatStack.pop() + vm.floatStack.pop());
	});

	/// Subtract r2 from r1, giving r3.
	///
	/// [FMinus][link] ( F: r1 r2 -- r3 )
	/// [link]: http://forth-standard.org/standard/float/FMinus
	d.addWord("F-", false, false, (){
		vm.floatStack.swap();
		vm.floatStack.push(vm.floatStack.pop() - vm.floatStack.pop());
	});

	/// Divide r1 by r2, giving the quotient r3.
	///
	/// [FDiv][link] ( F: r1 r2 -- r3 )
	/// [link]: http://forth-standard.org/standard/float/FDiv
	d.addWord("F/", false, false, (){
		vm.floatStack.swap();
		vm.floatStack.push(vm.floatStack.pop() / vm.floatStack.pop());
	});

	/// Raise r1 to the power r2, giving the product r3.
	///
	/// [FTimesTimes][link]
	/// [link]: http://forth-standard.org/standard/float/FTimesTimes
	d.addWord("F**", false, false, (){
		vm.floatStack.swap();
		vm.floatStack.push(pow(vm.floatStack.pop(), vm.floatStack.pop()));
	});

	/// Display, with a trailing space, the top number on the floating-point stack using fixed-point notation.
	///
	/// [Fd][link]
	/// [link]: http://forth-standard.org/standard/float/Fd
	d.addWord("F.", false, false, (){
		print(vm.floatStack.pop());
	});

	/// d is the double-cell signed-integer equivalent of the integer portion of r.
	///
	/// [FToD][link] ( -- d ) ( F: r -- )
	/// [link]: http://forth-standard.org/standard/float/FToD
	d.addWord("F>D", false, false, (){
		vm.dataStack.push(vm.floatStack.pop().toInt()); // FIXME TODO make it double
	});

	/// d is the single-cell signed-integer equivalent of the integer portion of r.
	///
	/// [FToS][link] ( -- d ) ( F: r -- )
	/// [link]: http://forth-standard.org/standard/float/FToS
	d.addWord("F>S", false, false, (){
		vm.dataStack.push(vm.floatStack.pop().toInt());
	});

	/// r3 is the greater of r1 and r2.
	///
	/// [FMAX][link]
	/// [link]: http://forth-standard.org/standard/float/FMAX
	d.addWord("FMAX", false, false, (){
		vm.floatStack.push(max(vm.floatStack.pop(), vm.floatStack.pop()));
	});

	/// r3 is the lesser of r1 and r2.
	///
	/// [FMIN][link]
	/// [link]: http://forth-standard.org/standard/float/FMIN
	d.addWord("FMIN", false, false, (){
		vm.floatStack.push(min(vm.floatStack.pop(), vm.floatStack.pop()));
	});

	/// Exchange the top two floating-point stack items.
	///
	/// [FSWAP][link] a ( F: x1 x2 -- x2 x1 )
	/// [link]: http://forth-standard.org/standard/float/FSWAP
	d.addWord("FSWAP", false, false, vm.floatStack.swap);

	/// ...
	///
	/// [][link]
	/// [link]: TODO
	//d.addWord("", false, false, (){}); // TODO

	/// ...
	///
	/// [][link]
	/// [link]: TODO
	//d.addWord("", false, false, (){}); // TODO

}

/// The optional Block word set.
///
/// http://forth-standard.org/standard/block
includeWordsStandardOptionalBlock(VirtualMachine vm, Dictionary d) {

	// Total: 14 (8 main + 6 extended)
	//
	// Implemented:
	//
	//
	//
	// Not implemented:
	//
	//   BLK BLOCK BUFFER EVALUATE FLUSH LOAD SAVE-BUFFERS UPDATE
	//
	//   EMPTY-BUFFERS LIST REFILL SCR THRU \

	/// ...
	///
	/// [][link]
	/// [link]: TODO
	//d.addWord("EVALUATE", false, false, (){}); // TODO
}

/// The optional Programming-Tools word set.
///
/// Contains words most often used during the development of applications.
/// http://forth-standard.org/standard/tools
void includeWordsStandardOptionalProgrammingTools(VirtualMachine vm, Dictionary d) {

	// Total: 27 (5 main + 22 extended)
	//
	// Implemented:
	//
	// .S WORDS
	//
	// BYE 
	//
	// Not implemented:
	//
	//   ? DUMP SEE 
	//
	//   AHEAD ASSEMBLER [DEFINED] [ELSE] [IF] [THEN] [UNDEFINED] CODE
	//   CS-PICK CS-ROLL EDITOR FORGET NAME>COMPILE NAME>INTERPRET
	//   NAME>STRING NR> N>R STATE SYNONYM ;CODE TRAVERSE-WORDLIST

	/// Copy and display the values currently on the data stack.
	///
	/// [DotS][link] ( -- )
	/// [link]: http://forth-standard.org/standard/tools/DotS
	d.addWord(".S", false, false, (){
		print("dataStack: ${vm.dataStack}");
	});

	/// List the definition names in the first word list of the search order.
	///
	/// [DotS][link] ( -- )
	/// [link]: http://forth-standard.org/standard/tools/DotS
	d.addWord("WORDS", false, false, (){
		var str = new StringBuffer();
		for (Word w in d.wordsList.reversed) {
			str.write("${w.name} ");
		}
		print(str);
	});

	/// Return control to the host operating system, if any.
	///
	/// It's re-implemented in CLI.
	///
	/// [BYE][link] ( -- )
	/// [link]: http://forth-standard.org/standard/tools/BYE
	d.addWord("BYE", false, false, (){});

}


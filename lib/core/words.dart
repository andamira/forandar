part of forandar;

/// Defines the [Forth standard CORE primitives][link].
///
/// [link]: http://forth-standard.org/standard/core/
void includeWordsStandardCore(VirtualMachine vm, Dictionary d) {

	// Total: 182 (133 main + 49 extended)
	//
	// Implemented:
	//
	// ! * + - , . / /MOD 0< 0= 1+ 1- 2! 2@ 2DROP 2DUP 2OVER 2SWAP ?DUP < = > >R @ ABS AND ALIGN ALIGNED BASE BL C! C, C@ CELL+ CELLS CHAR+ CHARS CR DEPTH DECIMAL DROP DUP HERE IMMEDIATE INVERT LSHIFT MAX MIN MOD NEGATE OR OVER QUIT ROT RSHIFT STATE SWAP U. U< XOR
	//
	// 0<> 0> 2>R 2R> 2R@ <> FALSE HEX NIP PICK TRUE TUCK U>
	//
	//
	// Not implemented:
	//
	// # #> #S ' ( */ */MOD +! +LOOP ." 2* 2/
	// : ; <# >BODY >IN >NUMBER ABORT
	// ABORT" ACCEPT ALLOT BEGIN
	// CHAR CONSTANT COUNT CREATE DO DOES>
	// ELSE EMIT ENVIRONMENT? EVALUATE EXECUTE EXIT FILL FIND FM/MOD
	// HOLD I IF J KEY LEAVE LITERAL LOOP M*
	// MOVE POSTPONE R> R@ RECURSE REPEAT
	// S" S>D SIGN SM/REM SOURCE SPACE SPACES THEN TYPE UM*
	// UM/MOD UNLOOP UNTIL VARIABLE WHILE WORD [ ['] [CHAR] ]
	//
	// .( .R :NONAME ?DO ACTION-OF AGAIN BUFFER: C"
	// CASE COMPILE, DEFER DEFER! DEFER@ ENDCASE ENDOF ERASE HOLDS
	// IS MARKER OF PAD PARSE PARSE-NAME REFILL RESTORE-INPUT ROLL
	// S\" SAVE-INPUT SOURCE-ID TO U.R UNUSED VALUE WITHIN
	// [COMPILE] \

	/// Store x at a-addr.
	///
	/// [!][link] ( x a-addr -- )
	/// [link]: http://forth-standard.org/standard/core/Store
	//
	// Stores an integer number using four bytes at the specified address.
	//
	// https://api.dartlang.org/stable/dart-typed_data/ByteData/setInt32.html
	// https://en.wikipedia.org/wiki/Two%27s_complement
	d.addWord("!", false, false, (){
		vm.dataSpace.storeCell(vm.dataStack.pop(), vm.dataStack.pop());
	});

	/// Multiply n1 | u1 by n2 | u2 giving the product n3 | u3.
	///
	/// [*][link] ( n1 | u1 n2 | u2 -- n3 | u3 )
	/// [link]: http://forth-standard.org/standard/core/Times
	d.addWord("*", false, false, (){
		vm.dataStack.push((vm.dataStack.pop() * vm.dataStack.pop()));
	});

	/// Add n2 | u2 to n1 | u1, giving the sum n3 | u3.
	///
	/// [+][link] ( n1 | u1 n2 | u2 -- n3 | u3 )
	/// [link]: http://forth-standard.org/standard/core/Plus
	d.addWord("+", false, false, (){
		vm.dataStack.push(vm.dataStack.pop() + vm.dataStack.pop());
	});

	/// Reserve one cell of data space and store x in the cell.
	///
	/// [,][link] ( x -- )
	/// [link]: http://forth-standard.org/standard/core/Comma
	d.addWord(",", false, false, (){
		vm.dataSpace.storeCellHere(vm.dataStack.pop());
	});

	/// Subtract n2 | u2 from n1 | u1, giving the difference n3 | u3.
	///
	/// [-][link] ( n1 | u1 n2 | u2 -- n3 | u3 )
	/// [link]: http://forth-standard.org/standard/core/Minus
	d.addWord("-", false, false, (){
		vm.dataStack.swap();
		vm.dataStack.push(vm.dataStack.pop() - vm.dataStack.pop());
	});

	/// Display n in free field format.
	///
	/// [.][link] ( n -- )
	/// [link]: http://forth-standard.org/standard/core/d
	d.addWord(".", false, false, (){
		print(vm.dataStack.pop());
	});

	/// Divide n1 by n2, , giving the single-cell quotient n3.
	///
	/// [/][link] ( n1 n2 -- n3 )
	/// [link]: http://forth-standard.org/standard/core/Div
	d.addWord("/", false, false, (){
		vm.dataStack.swap();
		vm.dataStack.push(vm.dataStack.pop() ~/ vm.dataStack.pop());
		// TODO: An ambiguous condition exists if n2 is zero.
		// If n1 and n2 differ in sign, the implementation-defined result
		// returned will be the same as that returned by either the phrase
		// >R S>D R> FM/MOD SWAP DROP or the phrase >R S>D R> SM/REM SWAP DROP.
	});

	/// Divide n1 by n2, giving the single-cell remainder n3 and the single-cell quotient n4.
	///
	/// : [/MOD][link] ( n1 n2 -- n3 n4 )
	/// 2DUP MOD -ROT / ;
	/// [link]: http://forth-standard.org/standard/core/DivMOD
	d.addWord("/MOD", false, false, (){
		int x = vm.dataStack.pop();
		int y = vm.dataStack.pop();
		vm.dataStack.push( y % x);
		vm.dataStack.push( y ~/ x);
		// TODO: An ambiguous condition exists if n2 is zero.
		// If n1 and n2 differ in sign, the implementation-defined result
		// returned will be the same as that returned by either the phrase
		// >R S>D R> FM/MOD or the phrase >R S>D R> SM/REM.
	});

	/// flag is true if and only if n is less than zero.
	///
	/// [0<][link] ( x -- flag )
	/// [link]: http://forth-standard.org/standard/core/Zeroless
	d.addWord("0<", false, false, (){
		vm.dataStack.pop() < 0 ? vm.dataStack.push(flagTRUE) : vm.dataStack.push(flagFALSE);
	});

	/// flag is true if and only if x is not equal to zero.
	///
	/// [0<>][link] ( x -- flag )
	/// [link]: http://forth-standard.org/standard/core/Zerone
	d.addWord("0<>", false, false, (){
		vm.dataStack.pop() != 0 ? vm.dataStack.push(flagTRUE) : vm.dataStack.push(flagFALSE);
	});

	/// flag is true if and only if x is equal to zero.
	///
	/// [0=][link] ( x -- flag )
	/// [link]: http://forth-standard.org/standard/core/ZeroEqual
	d.addWord("0=", false, false, (){
		vm.dataStack.pop() == 0 ? vm.dataStack.push(flagTRUE) : vm.dataStack.push(flagFALSE);
	});

	/// flag is true if and only if n is greater than zero.
	///
	/// [0>][link] ( x -- flag )
	/// [link]: http://forth-standard.org/standard/core/Zeromore
	d.addWord("0>", false, false, (){
		vm.dataStack.pop() > 0 ? vm.dataStack.push(flagTRUE) : vm.dataStack.push(flagFALSE);
	});

	/// Add one (1) to n1 | u1 giving the sum n2 | u2.
	///
	/// [1+][link] ( n1 | u1 -- n2 | u2 )
	/// [link]: http://forth-standard.org/standard/core/OnePlus
	d.addWord("1+", false, false, (){
		vm.dataStack.push(vm.dataStack.pop() + 1);
	});

	/// Subtract one (1) from n1 | u1 giving the difference n2 | u2.
	///
	/// [1-][link] ( n1 | u1 -- n2 | u2 )
	/// [link]: http://forth-standard.org/standard/core/OneMinus
	d.addWord("1-", false, false, (){
		vm.dataStack.push(vm.dataStack.pop() - 1);
	});

	/// Store the cell pair x1 x2 at a-addr, with x2 at a-addr and x1 at the next consecutive cell.
	///
	/// : [2!][link] ( x1 x2 a-addr -- )
	/// SWAP OVER ! CELL+ ! ;
	/// [link]: http://forth-standard.org/standard/core/TwoStore
	d.addWord("2!", false, false, (){
		int addr = vm.dataStack.pop();
		vm.dataSpace.storeCell(addr + cellSize, vm.dataStack.pop() );
		vm.dataSpace.storeCell(addr, vm.dataStack.pop() );
	});

	/// Fetch the cell pair x1 x2 stored at a-addr. x2 is stored at a-addr and x1 at the next consecutive cell.
	///
	/// : [2@][link] ( a-addr -- x1 x2 )
	/// DUP CELL+ @ SWAP @ ;
	/// [link]: http://forth-standard.org/standard/core/TwoFetch
	d.addWord("2@", false, false, (){
		int addr = vm.dataStack.pop();
		vm.dataStack.push(vm.dataSpace.fetchCell(addr+cellSize));
		vm.dataStack.push(vm.dataSpace.fetchCell(addr));
	});

	/// Execution: Transfer cell pair x1 x2 to the return stack.
	///
	/// : [2>R][link] ( x1 x2 -- ) ( R: -- x1 x2 )
	/// SWAP >R >R ; IMMEDIATE
	/// [link]: http://forth-standard.org/standard/core/TwotoR
	d.addWord("2>R", true, false, () {
		vm.dataStack.swap();
		vm.returnStack.push(vm.dataStack.pop());
		vm.returnStack.push(vm.dataStack.pop());
	});

	/// Drop cell pair x1 x2 from the stack.
	///
	/// [2DROP][link] ( x1 x2 -- )
	/// [link]: http://forth-standard.org/standard/core/TwoDROP
	d.addWord("2DROP", false, false, vm.dataStack.drop2);

	/// Duplicate cell pair x1 x2.
	///
	/// : [2DUP][link] ( x1 x2 -- x1 x2 x1 x2 )
	///   over over ;
	/// [link]: http://forth-standard.org/standard/core/TwoDUP
	d.addWord("2DUP", false, false, vm.dataStack.dup2);

	/// Copy cell pair x1 x2 to the top of the stack.
	///
	/// [2OVER][link] ( x1 x2 x3 x4 -- x1 x2 x3 x4 x1 x2 )
	/// [link]: http://forth-standard.org/standard/core/TwoOVER
	d.addWord("2OVER", false, false, vm.dataStack.over2);

	/// Duplicate cell pair x1 x2.
	///
	/// [2SWAP][link] ( x1 x2 x3 x4 -- x3 x4 x1 x2 )
	/// [link]: http://forth-standard.org/standard/core/TwoSWAP
	d.addWord("2SWAP", false, false, vm.dataStack.swap2);

	/// Execution: Transfer cell pair x1 x2 from the return stack.
	///
	/// : [2R>][link] ( -- x1 x2 ) ( R: x1 x2 -- )
	/// R> R> SWAP ; IMMEDIATE
	/// [link]: http://forth-standard.org/standard/core/TwoRfrom
	d.addWord("2R>", true, false, () {
		vm.dataStack.push(vm.returnStack.pop());
		vm.dataStack.push(vm.returnStack.pop());
		vm.dataStack.swap();
	});

	/// Execution: Copy cell pair x1 x2 from the return stack.
	///
	/// : [2R@][link] ( -- x1 x2 ) ( R: x1 x2 -- x1 x2 )
	/// R> R> 2DUP >R >R SWAP ; IMMEDIATE
	/// [link]: http://forth-standard.org/standard/core/TwoRFetch
	d.addWord("2R@", true, false, () {
		vm.dataStack.push(vm.returnStack.peek());
		vm.dataStack.push(vm.returnStack.peek());
		vm.dataStack.swap();
	});

	/// flag is true if and only if n1 is less than n2.
	///
	/// [<][link] ( n1 n2 -- flag )
	/// [link]: http://forth-standard.org/standard/core/less
	d.addWord("<", false, false, (){
		vm.dataStack.pop() > vm.dataStack.pop() ? vm.dataStack.push(flagTRUE) : vm.dataStack.push(flagFALSE);
	});

	/// flag is true if and only if x1 is not bit-for-bit the same as x2.
	///
	/// [<>][link] ( n1 n2 -- flag )
	/// [link]: http://forth-standard.org/standard/core/ne
	d.addWord("<>", false, false, (){
		vm.dataStack.pop() != vm.dataStack.pop() ? vm.dataStack.push(flagTRUE) : vm.dataStack.push(flagFALSE);
	});

	/// flag is true if and only if x1 is bit-for-bit the same as x2.
	///
	/// [=][link] ( n1 n2 -- flag )
	/// [link]: http://forth-standard.org/standard/core/Equal
	d.addWord("=", false, false, (){
		vm.dataStack.pop() == vm.dataStack.pop() ? vm.dataStack.push(flagTRUE) : vm.dataStack.push(flagFALSE);
	});

	/// flag is true if and only if n1 is more than n2.
	///
	/// [>][link] ( n1 n2 -- flag )
	/// [link]: http://forth-standard.org/standard/core/more
	d.addWord(">", false, false, (){
		vm.dataStack.pop() < vm.dataStack.pop() ? vm.dataStack.push(flagTRUE) : vm.dataStack.push(flagFALSE);
	});

	/// Moves data FROM [dataStack] TO [returnStack].
	///
	/// [>R][link] ( x -- ) ( R: -- x )
	/// [link]: http://forth-standard.org/standard/core/toR
	d.addWord(">R", false, false, () {
		vm.returnStack.push(vm.dataStack.pop());
	});

	/// Duplicate x if it is non-zero.
	///
	/// [?DUP][link] ( x -- 0 | x x )
	/// [link]: http://forth-standard.org/standard/core/qDUP
	d.addWord("?DUP", false, false, () {
		if (vm.dataStack.peek() != 0) vm.dataStack.dup();
	});

	/// x is the value stored at a-addr.
	///
	/// [@][link] ( a-addr -- x )
	/// [link]: http://forth-standard.org/standard/core/Fetch
	d.addWord("@", false, false, (){
		vm.dataStack.push(vm.dataSpace.fetchCell(vm.dataStack.pop()));
	});

	/// u is the absolute value of n.
	///
	/// [ABS][link] ( n -- u )
	/// [link]: http://forth-standard.org/standard/core/ABS
	d.addWord("ABS", false, false, (){
		vm.dataStack.push(vm.dataStack.pop().abs());
	});

	/// x3 is the bit-by-bit logical "and" of x1 with x2.
	///
	/// [AND][link] ( x1 x2 -- x3 )
	/// [link]: http://forth-standard.org/standard/core/AND
	d.addWord("AND", false, false, (){
		vm.dataStack.push(vm.dataStack.pop() & vm.dataStack.pop());
	});

	/// char is the character value for a space.
	///
	/// [BL][link] ( -- char )
	/// [link]: http://forth-standard.org/standard/core/BL
	d.addWord("BL", false, false, (){
		vm.dataStack.push(0x20); // SPACE = 0x20
	});

	/// Store char at c-addr.
	///
	/// [C!][link] ( char a-addr -- )
	/// [link]: http://forth-standard.org/standard/core/CStore
	d.addWord("C!", false, false, (){
		vm.dataSpace.storeChar(vm.dataStack.pop(), vm.dataStack.pop());
	});

	/// Reserve space for one character in the data space and store char in the space.
	///
	/// [C,][link] ( x -- )
	/// [link]: http://forth-standard.org/standard/core/CComma
	d.addWord("C,", false, false, (){
		vm.dataSpace.storeCharHere(vm.dataStack.pop());
	});

	/// Fetch the character stored at c-addr.
	///
	/// [C@][link] ( c-addr -- char )
	/// [link]: http://forth-standard.org/standard/core/CFetch
	//
	d.addWord("C@", false, false, (){
		vm.dataStack.push(vm.dataSpace.fetchChar(vm.dataStack.pop()));
	});

	/// Add the size in address units of a cell to a-addr1, giving a-addr2.
	///
	/// [CELL+][link] ( a-addr1 -- a-addr2 )
	/// [link]: http://forth-standard.org/standard/core/CELLPlus
	d.addWord("CELL+", false, false, (){
		vm.dataStack.push(vm.dataStack.pop() + cellSize);
	});

	/// n2 is the size in address units of n1 cells.
	///
	/// [CELLS][link] ( n1 -- n2 )
	/// [link]: http://forth-standard.org/standard/core/CELLS
	d.addWord("CELLS", false, false, (){
		vm.dataStack.push(vm.dataStack.pop() * cellSize);
	});

	/// Add the size in address units of a character to c-addr1, giving c-addr2.
	///
	/// [CHAR+][link] ( c-addr1 -- c-addr2 )
	/// [link]: http://forth-standard.org/standard/core/CHAR+
	// TODO: support extended characters
	d.addWord("CHAR+", false, false, (){
		vm.dataStack.push(vm.dataStack.pop() + 1);
	});

	/// n2 is the size in address units of n1 characters.
	///
	/// This word does nothing in this implementation.
	///
	/// [CHARS][link] ( n1 -- n2 )
	/// [link]: http://forth-standard.org/standard/core/CHARS
	// TODO: support extended characters
	d.addWordNope("CHARS");

	/// +n is the number of single-cell values contained in the data stack before +n was placed on the stack.
	///
	/// [DEPTH][link] ( -- +n )
	/// [link]: http://forth-standard.org/standard/core/DEPTH
	d.addWord("DEPTH", false, false, (){
		vm.dataStack.push(vm.dataStack.size);
	});

	/// Duplicate x.
	///
	/// [DUP][link] ( x -- x x )
	/// [link]: http://forth-standard.org/standard/core/DUP
	d.addWord("DUP", false, false, vm.dataStack.dup);

	/// If the data-space pointer is not aligned, reserve enough space to align it.
	///
	/// This word does nothing in this implementation.
	///
	/// [ALIGN][link] ( -- )
	/// [link]: http://forth-standard.org/standard/core/ALIGN
	d.addWordNope("ALIGN");

	/// a-addr is the first aligned address greater than or equal to addr.
	///
	/// This word does nothing in this implementation.
	///
	/// [DUP][link] ( addr -- a-addr )
	/// [link]: http://forth-standard.org/standard/core/ALIGN
	d.addWordNope("ALIGNED");

	/// Puts in the stack the address of a cell containing the current number-conversion radix {{2...36}}.
	///
	/// [BASE][link] ( -- a-addr )
	/// [link]: http://forth-standard.org/standard/core/BASE
	d.addWord("BASE", false, false, () {
		vm.dataStack.push(addrBASE);
	});

	/// Cause subsequent output to appear at the beginning of the next line.
	///
	/// [CR][link] ( -- )
	/// [link]: http://forth-standard.org/standard/core/CR
	d.addWord("CR", false, false, (){
		print("");
	});

	/// Set the numeric conversion radix to ten (decimal).
	///
	/// [DECIMAL][link] ( -- a-addr )
	/// [link]: http://forth-standard.org/standard/core/BASE
	d.addWord("DECIMAL", false, false, () {
		vm.dataSpace.storeCell(addrBASE, 10);
	});

	/// Remove x from the stack.
	///
	/// [DROP][link] ( x -- )
	/// [link]: http://forth-standard.org/standard/core/DROP
	d.addWord("DROP", false, false, vm.dataStack.drop);

	/// Return a false flag.
	///
	/// [FALSE][link] ( -- false )
	/// [link]: http://forth-standard.org/standard/core/FALSE
	d.addWord("FALSE", false, false, (){
		vm.dataStack.push(flagFALSE);
	});

	/// addr is the data-space pointer.
	///
	/// [HERE][link] ( -- addr )
	/// [link]: http://forth-standard.org/standard/core/HERE
	d.addWord("HERE", false, false, (){
		vm.dataStack.push(vm.dataSpace.pointer);
	});

	/// Set contents of BASE to sixteen.
	///
	/// [HEX][link] ( -- a-addr )
	/// [link]: http://forth-standard.org/standard/core/HEX
	d.addWord("HEX", false, false, () {
		vm.dataSpace.storeCell(addrBASE, 16);
	});

	/// Make the most recent definition an immediate word.
	///
	/// [IMMEDIATE][link] ( -- )
	/// [link]: http://forth-standard.org/standard/core/IMMEDIATE
	d.addWord("IMMEDIATE", false, false, () {
		d.wordsList.last.isImmediate = true;
	});

	/// Invert all bits of x1, giving its logical inverse x2.
	///
	/// [INVERT][link] ( x1 -- x2 )
	/// [link]: http://forth-standard.org/standard/core/INVERT
	d.addWord("INVERT", false, false, (){
		vm.dataStack.push(~vm.dataStack.pop());
	});

	/// Perform a logical left shift of u bit-places on x1, giving x2.
	///
	/// [LSHIFT][link] ( x1 u -- x2 )
	/// [link]: http://forth-standard.org/standard/core/LSHIFT
	d.addWord("LSHIFT", false, false, (){
		vm.dataStack.swap();
		vm.dataStack.push(vm.dataStack.pop() << vm.dataStack.pop());
		// TODO: An ambiguous condition exists if u is greater than or equal to the number of bits in a cell.
	});

	/// n3 is the greater of n1 and n2.
	///
	/// [MAX][link] ( n1 n2 -- n3 )
	/// [link]: http://forth-standard.org/standard/core/MAX
	d.addWord("MAX", false, false, (){
		vm.dataStack.push(max(vm.dataStack.pop(), vm.dataStack.pop()));
	});

	/// n3 is the lesser of n1 and n2.
	///
	/// [MIN][link] ( n1 n2 -- n3 )
	/// [link]: http://forth-standard.org/standard/core/MIN
	d.addWord("MIN", false, false, (){
		vm.dataStack.push(min(vm.dataStack.pop(), vm.dataStack.pop()));
	});

	/// Divide n1 by n2, giving the single-cell remainder n3.
	///
	/// [MOD][link] ( n1 n2 -- n3 )
	/// [link]: http://forth-standard.org/standard/core/MOD
	d.addWord("MOD", false, false, (){
		vm.dataStack.swap();
		vm.dataStack.push(vm.dataStack.pop() % vm.dataStack.pop());
		// TODO: An ambiguous condition exists if n2 is zero.
		// If n1 and n2 differ in sign, the implementation-defined result
	    // returned will be the same as that returned by either the phrase
		// >R S>D R> FM/MOD DROP or the phrase >R S>D R> SM/REM DROP.
	});

	/// Negate n1, giving its arithmetic inverse n2.
	///
	/// [NEGATE][link] ( n1 -- n2 )
	/// [link]: http://forth-standard.org/standard/core/NEGATE
	d.addWord("NEGATE", false, false, (){
		vm.dataStack.push(-vm.dataStack.pop());
	});

	/// Drop the first item below the top of stack.
	///
	/// [NIP][link] ( x1 x2 -- x2 )
	/// [link]: http://forth-standard.org/standard/core/NIP
	d.addWord("NIP", false, false, vm.dataStack.nip);

	/// x3 is the bit-by-bit inclusive-or of x1 with x2.
	///
	/// [OR][link] ( x1 x2 -- x3 )
	/// [link]: http://forth-standard.org/standard/core/OR
	d.addWord("OR", false, false, (){
		vm.dataStack.push(vm.dataStack.pop() | vm.dataStack.pop());
	});

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

	/// Interprets Forth source code received interactively from a user input device.
	///
	/// [QUIT][link] ( -- ) ( R: i * x -- )
	/// [link]: http://forth-standard.org/standard/core/QUIT
	d.addWordNope("QUIT");

	/// Rotate the top three stack entries.
	///
	/// [ROT][link] ( x1 x2 x3 -- x2 x3 x1 )
	/// [link]: http://forth-standard.org/standard/core/ROT
	d.addWord("ROT", false, false, vm.dataStack.rot);

	/// Perform a logical right shift of u bit-places on x1, giving x2.
	///
	/// [RSHIFT][link] ( x1 u -- x2 )
	/// [link]: http://forth-standard.org/standard/core/RSHIFT
	d.addWord("RSHIFT", false, false, (){
		vm.dataStack.swap();
		vm.dataStack.push(vm.dataStack.pop() >> vm.dataStack.pop());
		// TODO: An ambiguous condition exists if u is greater than or equal to the number of bits in a cell.
	});

	/// a-addr is the address of a cell containing the compilation-state flag.
	///
	/// [STATE][link] ( -- a-addr )
	/// [link]: http://forth-standard.org/standard/core/STATE
	d.addWord("STATE", false, false, (){
		vm.dataStack.push(addrSTATE);
	});

	/// Exchange the top two stack items.
	///
	/// [SWAP][link] ( x1 x2 -- x2 x1 )
	/// [link]: http://forth-standard.org/standard/core/SWAP
	d.addWord("SWAP", false, false, vm.dataStack.swap);

	/// Return a true flag.
	///
	/// [TRUE][link] ( -- true )
	/// [link]: http://forth-standard.org/standard/core/TRUE
	d.addWord("TRUE", false, false, (){
		vm.dataStack.push(flagTRUE);
	});

	/// Copy the first (top) stack item below the second stack item.
	///
	/// [TUCK][link] ( x1 x2 -- x2 x1 x2 )
	/// [link]: http://forth-standard.org/standard/core/TUCK
	d.addWord("TUCK", false, false, vm.dataStack.tuck);

	/// x3 is the bit-by-bit exclusive-or of x1 with x2.
	///
	/// [XOR][link] ( x1 x2 -- x3 )
	/// [link]: http://forth-standard.org/standard/core/XOR
	d.addWord("XOR", false, false, (){
		vm.dataStack.push(vm.dataStack.pop() ^ vm.dataStack.pop());
	});

	/// Display u in free field format.
	///
	/// [U.][link] ( u -- )
	/// [link]: http://forth-standard.org/standard/core/Ud
	d.addWord("U.", false, false, (){
		print(vm.dataStack.pop().toUnsigned(32));
	});

	/// flag is true if and only if u1 is less than u2.
	///
	/// [U<][link] ( u -- flag )
	/// [link]: http://forth-standard.org/standard/core/Uless
	d.addWord("U<", false, false, (){
		if (vm.dataStack.pop().toUnsigned(32) > vm.dataStack.pop().toUnsigned(32)) {
			vm.dataStack.push(flagTRUE);
		} else {
			vm.dataStack.push(flagFALSE);
		}
	});

	/// flag is true if and only if u1 is greater than u2.
	///
	/// [U>][link] ( u -- flag )
	/// [link]: http://forth-standard.org/standard/core/Umore
	d.addWord("U>", false, false, (){
		if (vm.dataStack.pop().toUnsigned(32) < vm.dataStack.pop().toUnsigned(32)) {
			vm.dataStack.push(flagTRUE);
		} else {
			vm.dataStack.push(flagFALSE);
		}
	});
}

/// Core words that are not part of the standard.
///
void includeWordsNotStandardCore(VirtualMachine vm, Dictionary d) {

	// TODO: modularize
	d.addWord("INTERPRET", false, false, () async {

		/// Concatenates all the source code strings, files and URLs into a single string.
		await vm.input.loadSourceCode();

		while (true) {

			/// Reads the next word.
			String wordStr = vm.input.nextWord();

			if (wordStr == null) {
				break;
			}

			/// Search for this word in the current dictionary.
			Word word = d.wordsMap[wordStr.toUpperCase()];

			/// If the word is found.
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


			/// If the word is not found.
			} else {

				/// Tries to convert the word to a number.
				try {

					num number; // parsed number
					bool isInt = true; // is it an integer?
					bool isDouble = false; // is it a double cell number?

					int base = vm.dataSpace.fetchCell(addrBASE); // (radix)

					// first and last characters of the word
					String prefix = wordStr.substring(0,1);
					//String suffix = wordStr.substring(wordStr.length - 1);

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
					// http://forth-standard.org/standard/core/toNUMBER

					// Is it a double cell integer?
					//
					// FIXME: current double-cell system is temporary. It will need to support
					// parsing a 64bit number and save it into two separate 32 bit integers
					if (wordStr.endsWith(".")) {
						isDouble = true;
						wordStr = wordStr.substring(0, wordStr.length - 1);
					}

					// Note: The ternary conditional inside the radix parameter, allows Dart to
					// automatically interpret any '0x' prefixed integers with hexadecimal base.
					number = int.parse(wordStr, radix: base == 10 ? null : base, onError: (wordStr) => null);

					//print("\nWORD $wordStr; BASE $base; PREFIX $prefix; DOUBLE: $isDouble; FLOAT: ${!isInt}"); // TEMP

					// If it couldn't be parsed, then tries it again as a prefixed integer.
					if (number == null) {

						// Sets the base as decimal,
						if (prefix == '#' ) {
							base = 10;
						// or as hexadecimal
						} else if (prefix == r'$') {
							base = 16;
						// or as binary.
						} else if (prefix == '%') {
							base = 2;
						}

						// Tries to parse the rest of the string.
						number = int.parse(wordStr.substring(1), radix: base, onError: (wordStr) => null);

						// If it fails, then tries to parse it as a character.
						if (number == null && wordStr.length == 3 && prefix == "'" && wordStr.endsWith("'")) {
							number = wordStr.codeUnitAt(1);
						}
					}

					// If it's not an integer, or a double, tries parsing it as floating point.
					//
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
					// http://forth-standard.org/standard/float
					// http://forth-standard.org/standard/float/toFLOAT
					if (number == null && !isDouble && base == 10) {

						// Only tries to parse it if the string has the correct scientific notation format.
						RegExp exp = new RegExp(r"[-+]?[0-9]*.?[0-9]*[deDE][-+]?[0-9]*");

						if (exp.hasMatch(wordStr)) {

							// Fixes the string for the Dart parser
							//
							String fixedWordStr = wordStr.replaceAll(new RegExp(r'[dD]'), 'e');
							// Dart double.parser() doesn't recognize floats ending in [e|E]
							if (fixedWordStr.endsWith('e') || fixedWordStr.endsWith('E')) fixedWordStr+= '+0';

							number = double.parse(fixedWordStr, (fixedWordStr) => null);
						}

						// If it couldn't be parsed as float either, throw an error.
						if (number == null) {
							throwError(e, new ForthError(-2048, $wordStr));
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

							if (isDouble) vm.dataStack.push(0); // FIXME (this is a temporary workaround for small ints)

						// Floats go to the floatStack.
						} else {
							vm.floatStack.push(number);
						}
					}


				/// If can't be converted, throw not-standard sys err "not a word not a number" (not understood).
				} catch(e) {
					throwError(e, new ForthError(-2048, wordStr));
					break;
				}

			}
		}

		// Loop ends when there are no more words.

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

	/// Display an integer binary format.
	d.addWord("BIN.", false, false, () {
		print(int32tobin(vm.dataStack.pop()));
	});

	/// Prints the values currently on the floating point stack.
	d.addWord(".FS", false, false, () {
		print("floatStack: ${vm.floatStack}");
	});

	/// Prints the values currently on the return point stack.
	d.addWord(".RS", false, false, () {
		print("returnStack: ${vm.returnStack}");
	});

	// Words from gforth

	// Examining
	// https://www.complang.tuwien.ac.at/forth/gforth/Docs-html/Examining.html

	// Floating-Point
	// https://www.complang.tuwien.ac.at/forth/gforth/Docs-html/Floating-Point-Tutorial.html
	// fnip ftuck fpick
	// f~abs f~rel

}

/// The optional Double-Number word set
///
/// http://forth-standard.org/standard/double
includeWordsStandardOptionalDouble(VirtualMachine vm, Dictionary d) {

	// Total: 23 (20 main + 3 extended)
	//
	// Implemented:
	//
	// 
	//
	// Not Implemented:
	//
	// 2CONSTANT 2LITERAL 2VARIABLE D+ D- D. D.R D0< D0= D2* D2/ D<
	// D= D>S DABS DMAX DMIN DNEGATE M*/ M+
	//
	// 2ROT 2VALUE DU<
	//

	/// 
	///
	/// [][link]
	/// [link]: 
	//d.addWord("", false, false, (){});
}

/// The optional Floating-Point word set
///
/// http://forth-standard.org/standard/float
includeWordsStandardOptionalFloat(VirtualMachine vm, Dictionary d) {

	// Total: 79 (31 main + 48 extended)
	//
	// Implemented:
	//
	// D>F F! F* F+ F- F/ F>D F@ FALIGN FALIGNED FDEPTH FDROP FDUP FLOOR FMAX FMIN FNEGATE FOVER FROT FROUND FSIN FSWAP 
	//
	// DFALIGN DFALIGNED F** F. F>S FABS FACOS FACOSH FALOG FASIN FASINH FATAN FATAN2 FATANH FCOS FCOSH EXP FLOG FLN FLNP1 FSIN FSINCOS FSINH FSQRT FTAN FTANH FTRUNC SFALIGN SFALIGNED
	//
	//
	// Not Implemented:
	//
	// >FLOAT F0< F0= F< FCONSTANT FLITERAL FLOAT+ FLOATS FVARIABLE REPRESENT
	//
	// DF! DF@ DFFIELD: DFLOAT+ DFLOATS FE. FEXPM1 FFIELD: FS. FVALUE F~ PRECISION S>F SET-PRECISION SF! SF@ SFFIELD: SFLOAT+ SFLOATS
	//

	/// r is the floating-point equivalent of d.
	///
	/// [D>F][link] ( d -- ) ( F: -- r ) 
	/// [link]: http://forth-standard.org/standard/float/DToF
	d.addWord("D>F", false, false, (){
		vm.floatStack.push(vm.dataStack.pop().toDouble());
	});

	/// If the data-space pointer is not double-float aligned, reserve enough data space to make it so.
	///
	/// This word does nothing in this implementation.
	///
	/// [DFALIGN][link] ( -- )
	/// [link]: http://forth-standard.org/standard/float/DFALIGN
	d.addWordNope("DFALIGN");

	/// df-addr is the first double-float-aligned address greater than or equal to addr.
	///
	/// This word does nothing in this implementation.
	///
	/// [DFALIGNED][link] ( addr -- df-addr )
	/// [link]: http://forth-standard.org/standard/float/DFALIGNED
	d.addWordNope("DFALIGNED");

	/// Store r at f-addr.
	///
	/// [F!][link] ( f-addr -- ) ( F: r -- )
	/// [link]: http://forth-standard.org/standard/float/FStore
	//
	// Stores a floating point number using eight bytes at the specified address.
	//
	// https://api.dartlang.org/stable/dart-typed_data/ByteData/setFloat64.html
	// https://en.wikipedia.org/wiki/Double-precision_floating-point_format
	d.addWord("F!", false, false, (){
		vm.dataSpace.storeFloat(vm.dataStack.pop(), vm.floatStack.pop());
	});

	/// r is the value stored at f-addr.
	///
	/// [F@][link] ( f-addr -- ) ( F: -- r )
	/// [link]: http://forth-standard.org/standard/float/FFetch
	//
	// Fetches a floating point number using eight bytes at the specified address.
	d.addWord("F@", false, false, (){
		vm.floatStack.push(vm.dataSpace.fetchFloat(vm.dataStack.pop()));
	});

	/// Multiply r1 by r2 giving r3.
	///
	/// [F*][link] ( F: r1 r2 -- r3 )
	/// [link]: http://forth-standard.org/standard/float/FTimes
	d.addWord("F*", false, false, (){
		vm.floatStack.push(vm.floatStack.pop() * vm.floatStack.pop());
	});

	/// Add r1 to r2 giving the sum r3.
	///
	/// [F+][link] ( F: r1 r2 -- r3 )
	/// [link]: http://forth-standard.org/standard/float/FPlus 
	d.addWord("F+", false, false, (){
		vm.floatStack.push(vm.floatStack.pop() + vm.floatStack.pop());
	});

	/// Subtract r2 from r1, giving r3.
	///
	/// [F-][link] ( F: r1 r2 -- r3 )
	/// [link]: http://forth-standard.org/standard/float/FMinus
	d.addWord("F-", false, false, (){
		vm.floatStack.swap();
		vm.floatStack.push(vm.floatStack.pop() - vm.floatStack.pop());
	});

	/// Divide r1 by r2, giving the quotient r3.
	///
	/// [F/][link] ( F: r1 r2 -- r3 )
	/// [link]: http://forth-standard.org/standard/float/FDiv
	d.addWord("F/", false, false, (){
		vm.floatStack.swap();
		vm.floatStack.push(vm.floatStack.pop() / vm.floatStack.pop());
	});

	/// Raise r1 to the power r2, giving the product r3.
	///
	/// [F**][link]
	/// [link]: http://forth-standard.org/standard/float/FTimesTimes
	d.addWord("F**", false, false, (){
		vm.floatStack.swap();
		vm.floatStack.push(pow(vm.floatStack.pop(), vm.floatStack.pop()));
	});

	/// Display, with a trailing space, the top number on the floating-point stack using fixed-point notation.
	///
	/// [F.][link] ( -- ) ( F: r -- )
	/// [link]: http://forth-standard.org/standard/float/Fd
	d.addWord("F.", false, false, (){
		print(vm.floatStack.pop());
		// TODO: An ambiguous condition exists if the value of BASE is not (decimal) ten or if the
		// character string representation exceeds the size of the pictured numeric output string buffer.
	});

	/// d is the double-cell signed-integer equivalent of the integer portion of r.
	///
	/// [F>D][link] ( -- d ) ( F: r -- )
	/// [link]: http://forth-standard.org/standard/float/FToD
	d.addWord("F>D", false, false, (){
		vm.dataStack.push(vm.floatStack.pop().toInt()); // FIXME TODO make it double
	});

	/// d is the single-cell signed-integer equivalent of the integer portion of r.
	///
	/// [F>S][link] ( -- d ) ( F: r -- )
	/// [link]: http://forth-standard.org/standard/float/FToS
	d.addWord("F>S", false, false, (){
		vm.dataStack.push(vm.floatStack.pop().toInt());
	});

	/// r2 is the absolute value of r1.
	///
	/// [FABS][link] ( F: r1 -- r2 )
	/// [link]: http://forth-standard.org/standard/float/FABS
	d.addWord("FABS", false, false, (){
		vm.floatStack.push(vm.floatStack.pop().abs());
	});

	/// r2 is the principal radian angle whose cosine is r1.
	///
	/// [FACOS][link] ( F: r1 -- r2 )
	/// [link]: http://forth-standard.org/standard/float/FACOS
	d.addWord("FACOS", false, false, (){
		vm.floatStack.push(acos(vm.floatStack.pop()));
		// TODO: An ambiguous condition exists if | r1 | is greater than one.
	});

	/// r2 is the floating-point value whose hyperbolic cosine is r1.
	///
	/// [FACOSH][link] ( F: r1 -- r2 )
	/// [link]: http://forth-standard.org/standard/float/FACOSH
	d.addWord("FACOSH", false, false, (){
		double x = vm.floatStack.pop();
		vm.floatStack.push(log(x + sqrt(x * x - 1)));
	});

	/// If the data-space pointer is not float aligned, reserve enough data space to make it so.
	///
	/// This word does nothing in this implementation.
	///
	/// [FALIGN][link] ( -- )
	/// [link]: http://forth-standard.org/standard/core/FALIGN
	d.addWordNope("FALIGN");

	/// f-addr is the first float-aligned address greater than or equal to addr.
	///
	/// This word does nothing in this implementation.
	///
	/// [FALIGNED][link] ( addr -- f-addr )
	/// [link]: http://forth-standard.org/standard/core/FALIGNED
	d.addWordNope("FALIGNED");

	/// Raise ten to the power r1, giving r2.
	///
	/// [FALOG][link] ( F: r1 -- r2 )
	/// [link]: http://forth-standard.org/standard/float/FALOG
	d.addWord("FALOG", false, false, (){
		vm.floatStack.push(pow(10, vm.floatStack.pop()));
	});

	/// r2 is the principal radian angle whose sine is r1.
	///
	/// [FASIN][link] ( F: r1 -- r2 )
	/// [link]: http://forth-standard.org/standard/float/FASIN
	d.addWord("FASIN", false, false, (){
		vm.floatStack.push(asin(vm.floatStack.pop()));
		// TODO: An ambiguous condition exists if | r1 | is greater than one.
	});

	/// r2 is the floating-point value whose hyperbolic sine is r1.
	///
	/// [FASINH][link] ( F: r1 -- r2 )
	/// [link]: http://forth-standard.org/standard/float/FASINH
	d.addWord("FASINH", false, false, (){
		double x = vm.floatStack.pop();
		vm.floatStack.push(log(x + sqrt(x * x + 1)));
	});

	/// r2 is the principal radian angle whose tangent is r1.
	///
	/// [FATAN][link] ( F: r1 -- r2 )	
	/// [link]: http://forth-standard.org/standard/float/FATAN
	d.addWord("FATAN", false, false, (){
		vm.floatStack.push(atan(vm.floatStack.pop()));
		// TODO: An ambiguous condition exists if r1 is less than or equal to zero.
	});

	/// r3 is the principal radian angle (between -π and π) whose tangent is r1/r2.
	///
	/// [FATAN2][link] ( F: r1 r2 -- r3 )	
	/// [link]: http://forth-standard.org/standard/float/FATANTwo
	d.addWord("FATAN2", false, false, (){
		vm.floatStack.swap();
		vm.floatStack.push(atan2(vm.floatStack.pop(), vm.floatStack.pop()));
		// TODO: An ambiguous condition exists r1 and r2 are zero.
	});

	/// r2 is the floating-point value whose hyperbolic tangent is r1.
	///
	/// [FATANH][link] ( F: r1 -- r2 )
	/// [link]: http://forth-standard.org/standard/float/FATANH
	d.addWord("FATANH", false, false, (){
		double x = vm.floatStack.pop();
		vm.floatStack.push(log((1+x)/(1-x)) / 2);
		// TODO: An ambiguous condition exists if r1 is outside the range of -1E0 to 1E0.
	});

	/// r2 is the cosine of the radian angle r1.
	///
	/// [FCOS][link] ( F: r1 -- r2 )	
	/// [link]: http://forth-standard.org/standard/float/FCOS
	d.addWord("FCOS", false, false, (){
		vm.floatStack.push(cos(vm.floatStack.pop()));
	});

	/// r2 is the hyperbolic cosine of r1.
	///
	/// [FCOSH][link] ( F: r1 -- r2 )	
	/// [link]: http://forth-standard.org/standard/float/FCOSH
	d.addWord("FCOSH", false, false, (){
		double x = vm.floatStack.pop();
		vm.floatStack.push((exp(2*x) + 1) / (2 * exp(x)));
	});

	/// +n is the number of values contained on the floating-point stack.
	///
	/// [FDEPTH][link] ( -- +n )
	/// [link]: http://forth-standard.org/standard/float/FDEPTH
	d.addWord("FDEPTH", false, false, (){
		vm.dataStack.push(vm.floatStack.size);
	});

	/// Remove r from the floating-point stack.
	///
	/// [FDROP][link] ( F: r -- )
	/// [link]: http://forth-standard.org/standard/float/FDROP
	d.addWord("FDROP", false, false, vm.floatStack.drop);

	/// Duplicate r.
	///
	/// [FDUP][link] ( F: r -- r r )
	/// [link]: http://forth-standard.org/standard/float/FDUP
	d.addWord("FDUP", false, false, vm.floatStack.dup);

	/// Raise e to the power r1, giving r2.
	///
	/// [FEXP][link] ( F: r1 -- r2 )
	/// [link]: http://forth-standard.org/standard/float/FEXP
	d.addWord("FEXP", false, false, (){
		vm.floatStack.push(exp(vm.floatStack.pop()));
	});

	/// Raise e to the power r1 and subtract one, giving r2.
	///
	/// [FEXPM1][link] ( F: r1 -- r2 )
	/// [link]: http://forth-standard.org/standard/float/FEXPM1
	d.addWord("FEXPM1", false, false, (){
		vm.floatStack.push(exp(vm.floatStack.pop()) - 1);
	});

	/// r2 is the base-ten logarithm of r1.
	///
	/// [FLOG][link] ( F: r1 -- r2 )	
	/// [link]: http://forth-standard.org/standard/float/FLOG
	d.addWord("FLOG", false, false, (){
		vm.floatStack.push(log(vm.floatStack.pop()) / LN10);
		// TODO: An ambiguous condition exists if r1 is less than or equal to zero.
	});

	/// Round r1 to an integral value using the "round toward negative infinity" rule, giving r2.
	///
	/// [FLOOR][link] ( F: r1 -- r2 )
	/// [link]: http://forth-standard.org/standard/float/FLOOR
	d.addWord("FLOOR", false, false, (){
		vm.floatStack.push(vm.floatStack.pop().floorToDouble());
	});

	/// r2 is the natural logarithm of r1. 
	///
	/// [FLN][link] ( F: r1 -- r2 )	
	/// [link]: http://forth-standard.org/standard/float/FLN
	d.addWord("FLN", false, false, (){
		vm.floatStack.push(log(vm.floatStack.pop()));
		// TODO: An ambiguous condition exists if r1 is less than or equal to zero.
	});

	/// r2 is the natural logarithm of the quantity r1 plus one.
	///
	/// [FLN][link] ( F: r1 -- r2 )	
	/// [link]: http://forth-standard.org/standard/float/FLNP1
	d.addWord("FLNP1", false, false, (){
		vm.floatStack.push(log(vm.floatStack.pop() + 1));
		// TODO: An ambiguous condition exists if r1 is less than or equal to negative one.
	});

	/// r3 is the greater of r1 and r2.
	///
	/// [FMAX][link] ( F: r1 r2 -- r3 )
	/// [link]: http://forth-standard.org/standard/float/FMAX
	d.addWord("FMAX", false, false, (){
		vm.floatStack.push(max(vm.floatStack.pop(), vm.floatStack.pop()));
	});

	/// r3 is the lesser of r1 and r2.
	///
	/// [FMIN][link] ( F: r1 r2 -- r3 )
	/// [link]: http://forth-standard.org/standard/float/FMIN
	d.addWord("FMIN", false, false, (){
		vm.floatStack.push(min(vm.floatStack.pop(), vm.floatStack.pop()));
	});

	/// r2 is the negation of r1.
	///
	/// [FNEGATE][link] ( F: r1 -- r2 )
	/// [link]: http://forth-standard.org/standard/float/FNEGATE
	d.addWord("FNEGATE", false, false, (){
		vm.floatStack.push(-vm.floatStack.pop());
	});

	/// Place a copy of r1 on top of the floating-point stack.
	///
	/// [FOVER][link] ( F: r1 r2 -- r1 r2 r1 )
	/// [link]: http://forth-standard.org/standard/float/FOVER
	d.addWord("FOVER", false, false, vm.floatStack.over);

	/// Rotate the top three floating-point stack entries.
	///
	/// [FROT][link] ( F: r1 r2 r3 -- r2 r3 r1 )
	/// [link]: http://forth-standard.org/standard/float/FROT
	d.addWord("FROT", false, false, vm.floatStack.rot);

	/// Round r1 to an integral value using the "round to nearest" rule, giving r2.
	///
	/// [FROUND][link] ( F: r1 -- r2 )
	/// [link]: http://forth-standard.org/standard/float/FROUND
	d.addWord("FROUND", false, false, (){
		vm.floatStack.push(vm.floatStack.pop().roundToDouble());
	});

	/// r2 is the sine of the radian angle r1.
	///
	/// [FSIN][link] ( F: r1 -- r2 )	
	/// [link]: http://forth-standard.org/standard/float/FSIN
	d.addWord("FSIN", false, false, (){
		vm.floatStack.push(sin(vm.floatStack.pop()));
	});

	/// r2 is the sine of the radian angle r1. r3 is the cosine of the radian angle r1.
	///
	/// [FSINCOS][link] ( F: r1 -- r2 r3 )	
	/// [link]: http://forth-standard.org/standard/float/FSINCOS
	d.addWord("FSINCOS", false, false, (){
		double x = vm.floatStack.pop();
		vm.floatStack.push(sin(x));
		vm.floatStack.push(cos(x));
	});

	/// r2 is the hyperbolic sine of r1.
	///
	/// [FSINH][link] ( F: r1 -- r2 )	
	/// [link]: http://forth-standard.org/standard/float/FSINH
	d.addWord("FSINH", false, false, (){
		double x = vm.floatStack.pop();
		vm.floatStack.push((exp(2*x) - 1) / (2 * exp(x)));
	});

	/// r2 is the hyperbolic tangent of r1.
	///
	/// [FTAN][link] ( F: r1 -- r2 )	
	/// [link]: http://forth-standard.org/standard/float/FTANH
	d.addWord("FTANH", false, false, (){
		double x = vm.floatStack.pop();
		vm.floatStack.push(
			((exp(2*x) - 1) / (2 * exp(x))) / ((exp(2*x) + 1) / (2 * exp(x)))
		);
	});

	/// Exchange the top two floating-point stack items.
	///
	/// [FSWAP][link] a ( F: x1 x2 -- x2 x1 )
	/// [link]: http://forth-standard.org/standard/float/FSWAP
	d.addWord("FSWAP", false, false, vm.floatStack.swap);

	/// If the data-space pointer is not single-float aligned, reserve enough data space to make it so.
	///
	/// This word does nothing in this implementation.
	///
	/// [SFALIGN][link] ( -- )
	/// [link]: http://forth-standard.org/standard/core/SFALIGN
	d.addWordNope("SFALIGN");

	/// sf-addr is the first single-float-aligned address greater than or equal to addr.
	///
	/// This word does nothing in this implementation.
	///
	/// [SFALIGNED][link] ( addr -- sf-addr )
	/// [link]: http://forth-standard.org/standard/core/SFALIGNED
	d.addWordNope("SFALIGNED");

	/// r2 is the square root of r1.
	///
	/// [FSQRT][link] ( F: r1 -- r2 )
	/// [link]: http://forth-standard.org/standard/float/FSQRT
	d.addWord("FSQRT", false, false, (){
		vm.floatStack.push(sqrt(vm.floatStack.pop()));
		// TODO: An ambiguous condition exists if r1 is less than zero.
	});

	/// r2 is the tangent of the radian angle r1.
	///
	/// [FTAN][link] ( F: r1 -- r2 )	
	/// [link]: http://forth-standard.org/standard/float/FTAN
	d.addWord("FTAN", false, false, (){
		vm.floatStack.push(tan(vm.floatStack.pop()));
		// TODO: An ambiguous condition exists if (r1) is zero.
	});

	/// Round r1 to an integral value using the "round towards zero" rule, giving r2.
	///
	/// [FTRUNC][link] ( F: r1 -- r2 )
	/// [link]: http://forth-standard.org/standard/float/TRUNC
	d.addWord("FTRUNC", false, false, (){
		vm.floatStack.push(vm.floatStack.pop().truncateToDouble());
	});
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
	//d.addWord("", false, false, (){}); // TODO
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
	//   .S ? DUMP WORDS
	//
	//   BYE STATE
	//
	// Not implemented:
	//
	//   SEE
	//
	//   AHEAD ASSEMBLER [DEFINED] [ELSE] [IF] [THEN] [UNDEFINED] CODE
	//   CS-PICK CS-ROLL EDITOR FORGET NAME>COMPILE NAME>INTERPRET
	//   NAME>STRING NR> N>R SYNONYM ;CODE TRAVERSE-WORDLIST

	/// Copy and display the values currently on the data stack.
	///
	/// [.S][link] ( -- )
	/// [link]: http://forth-standard.org/standard/tools/DotS
	d.addWord(".S", false, false, (){
		print("dataStack: ${vm.dataStack}");
	});

	/// Display the contents of u consecutive addresses starting at addr.
	///
	/// [DUMP][link] ( addr u -- )
	/// [link]: http://forth-standard.org/standard/tools/DUMP
	d.addWord("DUMP", false, false, (){
		vm.dataStack.over();
		print( dumpBytes(vm.dataSpace.data.buffer.asUint8List(vm.dataStack.pop(), vm.dataStack.pop()), vm.dataStack.pop()) );
	});

	/// Display the value stored at a-addr.
	///
	/// It's re-implemented in CLI.
	///
	/// [?][link] ( a-addr -- )
	/// [link]: http://forth-standard.org/standard/tools/q
	d.addWord("?", false, false, (){
		print(vm.dataSpace.fetchCell(vm.dataStack.pop()).toRadixString(vm.dataSpace.fetchCell(addrBASE)));
	});

	/// List the definition names in the first word list of the search order.
	///
	/// [WORDS][link] ( -- )
	/// [link]: http://forth-standard.org/standard/tools/WORDS
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
	d.addWordNope("BYE");
}


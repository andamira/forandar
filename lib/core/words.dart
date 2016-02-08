part of forandar;

/// Defines the [Forth standard CORE primitives][link].
///
/// [link]: http://forth-standard.org/standard/core/
void includeWordsStandardCore(VirtualMachine vm, Dictionary d) {

	// Total: 182 (133 main + 49 extended)
	//
	// Implemented:
	//
	// ! * + - , . / /MOD 0< 0= 1+ 1- 2! 2@ 2DROP 2DUP 2OVER 2SWAP ?DUP < = > >IN >R @ ABS AND ALIGN ALIGNED ALLOT BASE BL C! C, C@ CELL+ CELLS CHAR+ CHARS CR DEPTH DECIMAL DROP DUP HERE IMMEDIATE INVERT LSHIFT MAX MIN MOD NEGATE OR OVER QUIT R> R@ ROT RSHIFT STATE SWAP U. U< XOR
	//
	// 0<> 0> 2>R 2R> 2R@ <> FALSE HEX NIP PICK SOURCE-ID TRUE TUCK U>
	//
	//
	// Not implemented:
	//
	// # #> #S ' ( */ */MOD +! +LOOP ." 2* 2/
	// : ; <# >BODY >NUMBER ABORT
	// ABORT" ACCEPT BEGIN
	// CHAR CONSTANT COUNT CREATE DO DOES>
	// ELSE EMIT ENVIRONMENT? EVALUATE EXECUTE EXIT FILL FIND FM/MOD
	// HOLD I IF J KEY LEAVE LITERAL LOOP M*
	// MOVE POSTPONE RECURSE REPEAT
	// S" S>D SIGN SM/REM SOURCE SPACE SPACES THEN TYPE UM*
	// UM/MOD UNLOOP UNTIL VARIABLE WHILE WORD [ ['] [CHAR] ]
	//
	// .( .R :NONAME ?DO ACTION-OF AGAIN BUFFER: C"
	// CASE COMPILE, DEFER DEFER! DEFER@ ENDCASE ENDOF ERASE HOLDS
	// IS MARKER OF PAD PARSE PARSE-NAME REFILL RESTORE-INPUT ROLL
	// S\" SAVE-INPUT TO U.R UNUSED VALUE WITHIN
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
	d.addWord("!", (){
		vm.dataSpace.storeCell(vm.dataStack.pop(), vm.dataStack.pop());
	}, st: ST.Store.index);

	/// Multiply n1 | u1 by n2 | u2 giving the product n3 | u3.
	///
	/// [*][link] ( n1 | u1 n2 | u2 -- n3 | u3 )
	/// [link]: http://forth-standard.org/standard/core/Times
	d.addWord("*", (){
		vm.dataStack.push((vm.dataStack.pop() * vm.dataStack.pop()));
	}, st: ST.Times.index);

	/// Add n2 | u2 to n1 | u1, giving the sum n3 | u3.
	///
	/// [+][link] ( n1 | u1 n2 | u2 -- n3 | u3 )
	/// [link]: http://forth-standard.org/standard/core/Plus
	d.addWord("+", (){
		vm.dataStack.push(vm.dataStack.pop() + vm.dataStack.pop());
	}, st: ST.Plus.index);

	/// Reserve one cell of data space and store x in the cell.
	///
	/// [,][link] ( x -- )
	/// [link]: http://forth-standard.org/standard/core/Comma
	d.addWord(",", (){
		vm.dataSpace.storeCellHere(vm.dataStack.pop());
	}, st: ST.Comma.index);

	/// Subtract n2 | u2 from n1 | u1, giving the difference n3 | u3.
	///
	/// [-][link] ( n1 | u1 n2 | u2 -- n3 | u3 )
	/// [link]: http://forth-standard.org/standard/core/Minus
	d.addWord("-", (){
		vm.dataStack.swap();
		vm.dataStack.push(vm.dataStack.pop() - vm.dataStack.pop());
	}, st: ST.Minus.index);

	/// Display n in free field format.
	///
	/// [.][link] ( n -- )
	/// [link]: http://forth-standard.org/standard/core/d
	d.addWord(".", (){
		print(vm.dataStack.pop());
	}, st: ST.d.index);

	/// Divide n1 by n2, , giving the single-cell quotient n3.
	///
	/// [/][link] ( n1 n2 -- n3 )
	/// [link]: http://forth-standard.org/standard/core/Div
	d.addWord("/", (){
		vm.dataStack.swap();
		vm.dataStack.push(vm.dataStack.pop() ~/ vm.dataStack.pop());
		// TODO: An ambiguous condition exists if n2 is zero.
		// If n1 and n2 differ in sign, the implementation-defined result
		// returned will be the same as that returned by either the phrase
		// >R S>D R> FM/MOD SWAP DROP or the phrase >R S>D R> SM/REM SWAP DROP.
	}, st: ST.Div.index);

	/// Divide n1 by n2, giving the single-cell remainder n3 and the single-cell quotient n4.
	///
	/// : [/MOD][link] ( n1 n2 -- n3 n4 )
	/// 2DUP MOD -ROT / ;
	/// [link]: http://forth-standard.org/standard/core/DivMOD
	d.addWord("/MOD", (){
		int x = vm.dataStack.pop();
		int y = vm.dataStack.pop();
		vm.dataStack.push( y % x);
		vm.dataStack.push( y ~/ x);
		// TODO: An ambiguous condition exists if n2 is zero.
		// If n1 and n2 differ in sign, the implementation-defined result
		// returned will be the same as that returned by either the phrase
		// >R S>D R> FM/MOD or the phrase >R S>D R> SM/REM.
	}, st: ST.DivMOD.index);

	/// flag is true if and only if n is less than zero.
	///
	/// [0<][link] ( x -- flag )
	/// [link]: http://forth-standard.org/standard/core/Zeroless
	d.addWord("0<", (){
		vm.dataStack.pop() < 0 ? vm.dataStack.push(flagTRUE) : vm.dataStack.push(flagFALSE);
	}, st: ST.Zeroless.index);

	/// flag is true if and only if x is not equal to zero.
	///
	/// [0<>][link] ( x -- flag )
	/// [link]: http://forth-standard.org/standard/core/Zerone
	d.addWord("0<>", (){
		vm.dataStack.pop() != 0 ? vm.dataStack.push(flagTRUE) : vm.dataStack.push(flagFALSE);
	}, st: ST.Zerone.index);

	/// flag is true if and only if x is equal to zero.
	///
	/// [0=][link] ( x -- flag )
	/// [link]: http://forth-standard.org/standard/core/ZeroEqual
	d.addWord("0=", (){
		vm.dataStack.pop() == 0 ? vm.dataStack.push(flagTRUE) : vm.dataStack.push(flagFALSE);
	}, st: ST.ZeroEqual.index);

	/// flag is true if and only if n is greater than zero.
	///
	/// [0>][link] ( x -- flag )
	/// [link]: http://forth-standard.org/standard/core/Zeromore
	d.addWord("0>", (){
		vm.dataStack.pop() > 0 ? vm.dataStack.push(flagTRUE) : vm.dataStack.push(flagFALSE);
	}, st: ST.Zeromore.index);

	/// Add one (1) to n1 | u1 giving the sum n2 | u2.
	///
	/// [1+][link] ( n1 | u1 -- n2 | u2 )
	/// [link]: http://forth-standard.org/standard/core/OnePlus
	d.addWord("1+", (){
		vm.dataStack.push(vm.dataStack.pop() + 1);
	}, st: ST.OnePlus.index);

	/// Subtract one (1) from n1 | u1 giving the difference n2 | u2.
	///
	/// [1-][link] ( n1 | u1 -- n2 | u2 )
	/// [link]: http://forth-standard.org/standard/core/OneMinus
	d.addWord("1-", (){
		vm.dataStack.push(vm.dataStack.pop() - 1);
	}, st: ST.OneMinus.index);

	/// Store the cell pair x1 x2 at a-addr, with x2 at a-addr and x1 at the next consecutive cell.
	///
	/// : [2!][link] ( x1 x2 a-addr -- )
	/// SWAP OVER ! CELL+ ! ;
	/// [link]: http://forth-standard.org/standard/core/TwoStore
	d.addWord("2!", (){
		int addr = vm.dataStack.pop();
		vm.dataSpace.storeCell(addr + cellSize, vm.dataStack.pop() );
		vm.dataSpace.storeCell(addr, vm.dataStack.pop() );
	}, st: ST.TwoStore.index);

	/// Fetch the cell pair x1 x2 stored at a-addr. x2 is stored at a-addr and x1 at the next consecutive cell.
	///
	/// : [2@][link] ( a-addr -- x1 x2 )
	/// DUP CELL+ @ SWAP @ ;
	/// [link]: http://forth-standard.org/standard/core/TwoFetch
	d.addWord("2@", (){
		int addr = vm.dataStack.pop();
		vm.dataStack.push(vm.dataSpace.fetchCell(addr+cellSize));
		vm.dataStack.push(vm.dataSpace.fetchCell(addr));
	}, st: ST.TwoFetch.index);

	/// Execution: Transfer cell pair x1 x2 to the return stack.
	///
	/// : [2>R][link] ( x1 x2 -- ) ( R: -- x1 x2 )
	/// SWAP >R >R ; IMMEDIATE
	/// [link]: http://forth-standard.org/standard/core/TwotoR
	d.addWord("2>R", () {
		vm.dataStack.swap();
		vm.returnStack.push(vm.dataStack.pop());
		vm.returnStack.push(vm.dataStack.pop());
	}, st: ST.TwotoR.index, immediate: true);

	/// Drop cell pair x1 x2 from the stack.
	///
	/// [2DROP][link] ( x1 x2 -- )
	/// [link]: http://forth-standard.org/standard/core/TwoDROP
	d.addWord("2DROP", vm.dataStack.drop2, st: ST.TwoDROP.index);

	/// Duplicate cell pair x1 x2.
	///
	/// : [2DUP][link] ( x1 x2 -- x1 x2 x1 x2 )
	///   over over ;
	/// [link]: http://forth-standard.org/standard/core/TwoDUP
	d.addWord("2DUP", vm.dataStack.dup2, st: ST.TwoDUP.index);

	/// Copy cell pair x1 x2 to the top of the stack.
	///
	/// [2OVER][link] ( x1 x2 x3 x4 -- x1 x2 x3 x4 x1 x2 )
	/// [link]: http://forth-standard.org/standard/core/TwoOVER
	d.addWord("2OVER", vm.dataStack.over2, st: ST.TwoOVER.index);

	/// Duplicate cell pair x1 x2.
	///
	/// [2SWAP][link] ( x1 x2 x3 x4 -- x3 x4 x1 x2 )
	/// [link]: http://forth-standard.org/standard/core/TwoSWAP
	d.addWord("2SWAP", vm.dataStack.swap2, st: ST.TwoSWAP.index);

	/// Execution: Transfer cell pair x1 x2 from the return stack.
	///
	/// : [2R>][link] ( -- x1 x2 ) ( R: x1 x2 -- )
	/// R> R> SWAP ; IMMEDIATE
	/// [link]: http://forth-standard.org/standard/core/TwoRfrom
	d.addWord("2R>", () {
		vm.dataStack.push(vm.returnStack.pop());
		vm.dataStack.push(vm.returnStack.pop());
		vm.dataStack.swap();
	}, st: ST.TwoRfrom.index, immediate: true);

	/// Execution: Copy cell pair x1 x2 from the return stack.
	///
	/// : [2R@][link] ( -- x1 x2 ) ( R: x1 x2 -- x1 x2 )
	/// R> R> 2DUP >R >R SWAP ; IMMEDIATE
	/// [link]: http://forth-standard.org/standard/core/TwoRFetch
	d.addWord("2R@", () {
		vm.dataStack.push(vm.returnStack.peek());
		vm.dataStack.push(vm.returnStack.peek());
		vm.dataStack.swap();
	}, st: ST.TwoRFetch.index, immediate: true);

	/// flag is true if and only if n1 is less than n2.
	///
	/// [<][link] ( n1 n2 -- flag )
	/// [link]: http://forth-standard.org/standard/core/less
	d.addWord("<", (){
		vm.dataStack.pop() > vm.dataStack.pop() ? vm.dataStack.push(flagTRUE) : vm.dataStack.push(flagFALSE);
	}, st: ST.less.index);

	/// flag is true if and only if x1 is not bit-for-bit the same as x2.
	///
	/// [<>][link] ( n1 n2 -- flag )
	/// [link]: http://forth-standard.org/standard/core/ne
	d.addWord("<>", (){
		vm.dataStack.pop() != vm.dataStack.pop() ? vm.dataStack.push(flagTRUE) : vm.dataStack.push(flagFALSE);
	}, st: ST.ne.index);

	/// flag is true if and only if x1 is bit-for-bit the same as x2.
	///
	/// [=][link] ( n1 n2 -- flag )
	/// [link]: http://forth-standard.org/standard/core/Equal
	d.addWord("=", (){
		vm.dataStack.pop() == vm.dataStack.pop() ? vm.dataStack.push(flagTRUE) : vm.dataStack.push(flagFALSE);
	}, st: ST.Equal.index);

	/// flag is true if and only if n1 is more than n2.
	///
	/// [>][link] ( n1 n2 -- flag )
	/// [link]: http://forth-standard.org/standard/core/more
	d.addWord(">", (){
		vm.dataStack.pop() < vm.dataStack.pop() ? vm.dataStack.push(flagTRUE) : vm.dataStack.push(flagFALSE);
	}, st: ST.more.index);

	/// a-addr is the address of a cell containing the offset in characters from the start of the input buffer to the start of the parse area.
	///
	/// [>IN][link] ( -- a-addr )
	/// [link]: http://forth-standard.org/standard/core/toIN
	d.addWord(">IN", () {
		vm.dataStack.push(addrToIN);
	}, st: ST.toIN.index);

	/// Moves data FROM the data stack to the return stack.
	///
	/// [>R][link] ( x -- ) ( R: -- x )
	/// [link]: http://forth-standard.org/standard/core/toR
	d.addWord(">R", () {
		vm.returnStack.push(vm.dataStack.pop());
	}, st: ST.toR.index, immediate: true);

	/// Duplicate x if it is non-zero.
	///
	/// [?DUP][link] ( x -- 0 | x x )
	/// [link]: http://forth-standard.org/standard/core/qDUP
	d.addWord("?DUP", () {
		if (vm.dataStack.peek() != 0) vm.dataStack.dup();
	}, st: ST.qDUP.index);

	/// x is the value stored at a-addr.
	///
	/// [@][link] ( a-addr -- x )
	/// [link]: http://forth-standard.org/standard/core/Fetch
	d.addWord("@", (){
		vm.dataStack.push(vm.dataSpace.fetchCell(vm.dataStack.pop()));
	}, st: ST.Fetch.index);

	/// u is the absolute value of n.
	///
	/// [ABS][link] ( n -- u )
	/// [link]: http://forth-standard.org/standard/core/ABS
	d.addWord("ABS", (){
		vm.dataStack.push(vm.dataStack.pop().abs());
	}, st: ST.ABS.index);

	/// x3 is the bit-by-bit logical "and" of x1 with x2.
	///
	/// [AND][link] ( x1 x2 -- x3 )
	/// [link]: http://forth-standard.org/standard/core/AND
	d.addWord("AND", (){
		vm.dataStack.push(vm.dataStack.pop() & vm.dataStack.pop());
	}, st: ST.AND.index);

	/// char is the character value for a space.
	///
	/// [BL][link] ( -- char )
	/// [link]: http://forth-standard.org/standard/core/BL
	d.addWord("BL", (){
		vm.dataStack.push(0x20); // SPACE = 0x20
	}, st: ST.BL.index);

	/// Store char at c-addr.
	///
	/// [C!][link] ( char a-addr -- )
	/// [link]: http://forth-standard.org/standard/core/CStore
	d.addWord("C!", (){
		vm.dataSpace.storeChar(vm.dataStack.pop(), vm.dataStack.pop());
	}, st: ST.CStore.index);

	/// Reserve space for one character in the data space and store char in the space.
	///
	/// [C,][link] ( x -- )
	/// [link]: http://forth-standard.org/standard/core/CComma
	d.addWord("C,", (){
		vm.dataSpace.storeCharHere(vm.dataStack.pop());
	}, st: ST.CComma.index);

	/// Fetch the character stored at c-addr.
	///
	/// [C@][link] ( c-addr -- char )
	/// [link]: http://forth-standard.org/standard/core/CFetch
	//
	d.addWord("C@", (){
		vm.dataStack.push(vm.dataSpace.fetchChar(vm.dataStack.pop()));
	}, st: ST.CFetch.index);

	/// Add the size in address units of a cell to a-addr1, giving a-addr2.
	///
	/// [CELL+][link] ( a-addr1 -- a-addr2 )
	/// [link]: http://forth-standard.org/standard/core/CELLPlus
	d.addWord("CELL+", (){
		vm.dataStack.push(vm.dataStack.pop() + cellSize);
	}, st: ST.CELLPlus.index);

	/// n2 is the size in address units of n1 cells.
	///
	/// [CELLS][link] ( n1 -- n2 )
	/// [link]: http://forth-standard.org/standard/core/CELLS
	d.addWord("CELLS", (){
		vm.dataStack.push(vm.dataStack.pop() * cellSize);
	}, st: ST.CELLS.index);

	/// Add the size in address units of a character to c-addr1, giving c-addr2.
	///
	/// [CHAR+][link] ( c-addr1 -- c-addr2 )
	/// [link]: http://forth-standard.org/standard/core/CHARPlus
	// TODO: support extended characters
	d.addWord("CHAR+", (){
		vm.dataStack.push(vm.dataStack.pop() + 1);
	}, st: ST.CHARPlus.index);

	/// n2 is the size in address units of n1 characters.
	///
	/// This word does nothing in this implementation.
	///
	/// [CHARS][link] ( n1 -- n2 )
	/// [link]: http://forth-standard.org/standard/core/CHARS
	// TODO: support extended characters
	d.addWordNope("CHARS", st: ST.CHARS.index);

	/// +n is the number of single-cell values contained in the data stack before +n was placed on the stack.
	///
	/// [DEPTH][link] ( -- +n )
	/// [link]: http://forth-standard.org/standard/core/DEPTH
	d.addWord("DEPTH", (){
		vm.dataStack.push(vm.dataStack.size);
	}, st: ST.DEPTH.index);

	/// Duplicate x.
	///
	/// [DUP][link] ( x -- x x )
	/// [link]: http://forth-standard.org/standard/core/DUP
	d.addWord("DUP", vm.dataStack.dup, st: ST.DUP.index);

	/// If the data-space pointer is not aligned, reserve enough space to align it.
	///
	/// This word does nothing in this implementation.
	///
	/// [ALIGN][link] ( -- )
	/// [link]: http://forth-standard.org/standard/core/ALIGN
	d.addWordNope("ALIGN", st: ST.ALIGN.index);

	/// a-addr is the first aligned address greater than or equal to addr.
	///
	/// This word does nothing in this implementation.
	///
	/// [ALIGNED][link] ( addr -- a-addr )
	/// [link]: http://forth-standard.org/standard/core/ALIGNED
	d.addWordNope("ALIGNED", st: ST.ALIGNED.index);

	/// If n > 0, reserve n address units of data space. If n < 0, release | n | address units of data space.
	///
	/// [ALLOT][link] ( n -- )
	/// [link]: http://forth-standard.org/standard/core/ALLOT
	d.addWord("ALLOT", () {
		dataSpace.pointer += vm.dataStack.pop();
	}, st: ST.ALLOT.index);

	/// Puts in the stack the address of a cell containing the current number-conversion radix {{2...36}}.
	///
	/// [BASE][link] ( -- a-addr )
	/// [link]: http://forth-standard.org/standard/core/BASE
	d.addWord("BASE", () {
		vm.dataStack.push(addrBASE);
	}, st: ST.BASE.index);

	/// Cause subsequent output to appear at the beginning of the next line.
	///
	/// [CR][link] ( -- )
	/// [link]: http://forth-standard.org/standard/core/CR
	d.addWord("CR", (){
		print("");
	}, st: ST.CR.index);

	/// Set the numeric conversion radix to ten (decimal).
	///
	/// [DECIMAL][link] ( -- a-addr )
	/// [link]: http://forth-standard.org/standard/core/DECIMAL
	d.addWord("DECIMAL", () {
		vm.dataSpace.storeCell(addrBASE, 10);
	}, st: ST.DECIMAL.index);

	/// Remove x from the stack.
	///
	/// [DROP][link] ( x -- )
	/// [link]: http://forth-standard.org/standard/core/DROP
	d.addWord("DROP", vm.dataStack.drop, st: ST.DROP.index);

	/// Return a false flag.
	///
	/// [FALSE][link] ( -- false )
	/// [link]: http://forth-standard.org/standard/core/FALSE
	d.addWord("FALSE", (){
		vm.dataStack.push(flagFALSE);
	}, st: ST.FALSE.index);

	/// addr is the data-space pointer.
	///
	/// [HERE][link] ( -- addr )
	/// [link]: http://forth-standard.org/standard/core/HERE
	d.addWord("HERE", (){
		vm.dataStack.push(vm.dataSpace.pointer);
	}, st: ST.HERE.index);

	/// Set contents of BASE to sixteen.
	///
	/// [HEX][link] ( -- a-addr )
	/// [link]: http://forth-standard.org/standard/core/HEX
	d.addWord("HEX", () {
		vm.dataSpace.storeCell(addrBASE, 16);
	}, st: ST.HEX.index);

	/// Make the most recent definition an immediate word.
	///
	/// [IMMEDIATE][link] ( -- )
	/// [link]: http://forth-standard.org/standard/core/IMMEDIATE
	d.addWord("IMMEDIATE", () {
		d.wordsList.last.isImmediate = true;
	}, st: ST.IMMEDIATE.index);

	/// Invert all bits of x1, giving its logical inverse x2.
	///
	/// [INVERT][link] ( x1 -- x2 )
	/// [link]: http://forth-standard.org/standard/core/INVERT
	d.addWord("INVERT", (){
		vm.dataStack.push(~vm.dataStack.pop());
	}, st: ST.INVERT.index);

	/// Perform a logical left shift of u bit-places on x1, giving x2.
	///
	/// [LSHIFT][link] ( x1 u -- x2 )
	/// [link]: http://forth-standard.org/standard/core/LSHIFT
	d.addWord("LSHIFT", (){
		vm.dataStack.swap();
		vm.dataStack.push(vm.dataStack.pop() << vm.dataStack.pop());
		// TODO: An ambiguous condition exists if u is greater than or equal to the number of bits in a cell.
	}, st: ST.LSHIFT.index);

	/// n3 is the greater of n1 and n2.
	///
	/// [MAX][link] ( n1 n2 -- n3 )
	/// [link]: http://forth-standard.org/standard/core/MAX
	d.addWord("MAX", (){
		vm.dataStack.push(max(vm.dataStack.pop(), vm.dataStack.pop()));
	}, st: ST.MAX.index);

	/// n3 is the lesser of n1 and n2.
	///
	/// [MIN][link] ( n1 n2 -- n3 )
	/// [link]: http://forth-standard.org/standard/core/MIN
	d.addWord("MIN", (){
		vm.dataStack.push(min(vm.dataStack.pop(), vm.dataStack.pop()));
	}, st: ST.MIN.index);

	/// Divide n1 by n2, giving the single-cell remainder n3.
	///
	/// [MOD][link] ( n1 n2 -- n3 )
	/// [link]: http://forth-standard.org/standard/core/MOD
	d.addWord("MOD", (){
		vm.dataStack.swap();
		vm.dataStack.push(vm.dataStack.pop() % vm.dataStack.pop());
		// TODO: An ambiguous condition exists if n2 is zero.
		// If n1 and n2 differ in sign, the implementation-defined result
	    // returned will be the same as that returned by either the phrase
		// >R S>D R> FM/MOD DROP or the phrase >R S>D R> SM/REM DROP.
	}, st: ST.MOD.index);

	/// Negate n1, giving its arithmetic inverse n2.
	///
	/// [NEGATE][link] ( n1 -- n2 )
	/// [link]: http://forth-standard.org/standard/core/NEGATE
	d.addWord("NEGATE", (){
		vm.dataStack.push(-vm.dataStack.pop());
	}, st: ST.NEGATE.index);

	/// Drop the first item below the top of stack.
	///
	/// [NIP][link] ( x1 x2 -- x2 )
	/// [link]: http://forth-standard.org/standard/core/NIP
	d.addWord("NIP", vm.dataStack.nip, st: ST.NIP.index);

	/// x3 is the bit-by-bit inclusive-or of x1 with x2.
	///
	/// [OR][link] ( x1 x2 -- x3 )
	/// [link]: http://forth-standard.org/standard/core/OR
	d.addWord("OR", (){
		vm.dataStack.push(vm.dataStack.pop() | vm.dataStack.pop());
	}, st: ST.OR.index);

	/// Place a copy of x1 on top of the stack.
	///
	/// [OVER][link] ( x1 x2 -- x1 x2 x1 )
	/// [link]: http://forth-standard.org/standard/core/OVER
	d.addWord("OVER", vm.dataStack.over, st: ST.OVER.index);

	/// Remove u. Copy the xu to the top of the stack.
	///
	/// [PICK][link] ( xu...x1 x0 u -- xu...x1 x0 xu )
	/// [link]: http://forth-standard.org/standard/core/PICK
	d.addWord("PICK", () {
		vm.dataStack.pick(vm.dataStack.pop());
	}, st: ST.PICK.index);

	/// Interprets Forth source code received interactively from a user input device.
	///
	/// [QUIT][link] ( -- ) ( R: i * x -- )
	/// [link]: http://forth-standard.org/standard/core/QUIT
	d.addWordNope("QUIT", st: ST.QUIT.index);

	/// Moves data FROM the return stack to the data stack.
	///
	/// [R>][link] ( -- x  ( R: x -- )
	/// [link]: http://forth-standard.org/standard/core/Rfrom
	d.addWord("R>", () {
		vm.dataStack.push(vm.returnStack.pop());
	}, st: ST.Rfrom.index, immediate: true);

	/// Copy x from the return stack to the data stack.
	///
	/// [R@][link] ( -- x ) ( R: x -- x )
	/// [link]: http://forth-standard.org/standard/core/RFetch
	d.addWord("R@", () {
		vm.dataStack.push(vm.returnStack.peek());
	}, st: ST.RFetch.index, immediate: true);

	/// Rotate the top three stack entries.
	///
	/// [ROT][link] ( x1 x2 x3 -- x2 x3 x1 )
	/// [link]: http://forth-standard.org/standard/core/ROT
	d.addWord("ROT", vm.dataStack.rot, st: ST.ROT.index);

	/// Perform a logical right shift of u bit-places on x1, giving x2.
	///
	/// [RSHIFT][link] ( x1 u -- x2 )
	/// [link]: http://forth-standard.org/standard/core/RSHIFT
	d.addWord("RSHIFT", (){
		vm.dataStack.swap();
		vm.dataStack.push(vm.dataStack.pop() >> vm.dataStack.pop());
		// TODO: An ambiguous condition exists if u is greater than or equal to the number of bits in a cell.
	}, st: ST.RSHIFT.index);

	/// a-addr is the address of a cell containing the compilation-state flag.
	///
	/// [STATE][link] ( -- a-addr )
	/// [link]: http://forth-standard.org/standard/core/STATE
	d.addWord("STATE", (){
		vm.dataStack.push(addrSTATE);
	}, st: ST.STATE.index);

	/// Exchange the top two stack items.
	///
	/// [SWAP][link] ( x1 x2 -- x2 x1 )
	/// [link]: http://forth-standard.org/standard/core/SWAP
	d.addWord("SWAP", vm.dataStack.swap, st: ST.SWAP.index);

	/// Identifies the input source as follows:
	///
	/// -1 String (via EVALUATE)
	///  0 User input device
	///
	/// [SOURCE-ID][link] ( -- 0 | -1 )
	/// [link]: http://forth-standard.org/standard/core/SOURCE-ID
	d.addWord("SOURCE-ID", (){
		vm.dataStack.push(vm.source.id);
	}, st: ST.SOURCE_ID.index);

	/// Return a true flag.
	///
	/// [TRUE][link] ( -- true )
	/// [link]: http://forth-standard.org/standard/core/TRUE
	d.addWord("TRUE", (){
		vm.dataStack.push(flagTRUE);
	}, st: ST.TRUE.index);

	/// Copy the first (top) stack item below the second stack item.
	///
	/// [TUCK][link] ( x1 x2 -- x2 x1 x2 )
	/// [link]: http://forth-standard.org/standard/core/TUCK
	d.addWord("TUCK", vm.dataStack.tuck, st: ST.TUCK.index);

	/// x3 is the bit-by-bit exclusive-or of x1 with x2.
	///
	/// [XOR][link] ( x1 x2 -- x3 )
	/// [link]: http://forth-standard.org/standard/core/XOR
	d.addWord("XOR", (){
		vm.dataStack.push(vm.dataStack.pop() ^ vm.dataStack.pop());
	}, st: ST.XOR.index);

	/// Display u in free field format.
	///
	/// [U.][link] ( u -- )
	/// [link]: http://forth-standard.org/standard/core/Ud
	d.addWord("U.", (){
		print(vm.dataStack.pop().toUnsigned(32));
	}, st: ST.Ud.index);

	/// flag is true if and only if u1 is less than u2.
	///
	/// [U<][link] ( u -- flag )
	/// [link]: http://forth-standard.org/standard/core/Uless
	d.addWord("U<", (){
		if (vm.dataStack.pop().toUnsigned(32) > vm.dataStack.pop().toUnsigned(32)) {
			vm.dataStack.push(flagTRUE);
		} else {
			vm.dataStack.push(flagFALSE);
		}
	}, st: ST.Uless.index);

	/// flag is true if and only if u1 is greater than u2.
	///
	/// [U>][link] ( u -- flag )
	/// [link]: http://forth-standard.org/standard/core/Umore
	d.addWord("U>", (){
		if (vm.dataStack.pop().toUnsigned(32) < vm.dataStack.pop().toUnsigned(32)) {
			vm.dataStack.push(flagTRUE);
		} else {
			vm.dataStack.push(flagFALSE);
		}
	}, st: ST.Umore.index);
}

/// Core words that are not part of the standard.
///
void includeWordsNotStandardCore(VirtualMachine vm, Dictionary d) {

	// TODO: modularize
	d.addWord("INTERPRET", () {

		while (true) {

			/// Reads the next word.
			String wordStr = vm.source.nextWord();

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

					// NOTE: The ternary conditional inside the radix parameter, allows Dart to
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

	}, st: ST.INTERPRET.index);

}

/// Useful words that are not part of the standard.
///
/// [Gforth Word Index][http://www.complang.tuwien.ac.at/forth/gforth/Docs-html/Word-Index.html#Word-Index]
void includeWordsNotStandardExtra(VirtualMachine vm, Dictionary d) {

	///
	d.addWord("-ROT", vm.dataStack.rotCC);

	/// Tries to find the name token nt of the word represented by xt.
	///
	/// Returns 0 if it fails.
	/// Note that in the current implementation xt and nt are exactly the same.
	/// [toName][link] ( xt -- nt|0 )
	/// [link]: http://www.complang.tuwien.ac.at/forth/gforth/Docs-html/Name-token.html
	//d.addWord(">NAME", () {}); // TODO

	/// Tries to find the name of the [Word] represented by nt.
	///
	/// Note that in the current implementation xt and nt are exactly the same.
	/// [nameToString][link] ( nt -- addr count )
	/// [link]: http://www.complang.tuwien.ac.at/forth/gforth/Docs-html/Name-token.html
	//d.addWord("NAME>STRING", () {}); // TODO

		/// Prints the values currently on the floating point stack.
	d.addWord(".FS", () {
		print("floatStack: ${vm.floatStack}");
	});

	/// Prints the values currently on the return point stack.
	d.addWord(".RS", () {
		print("returnStack: ${vm.returnStack}");
	});

	/// Display an integer binary format.
	d.addWord("BIN.", () {
		print(int32tobin(vm.dataStack.pop()));
	});

	/// Prints the object space content. // TODO
	d.addWordNope("ODUMP");

	/// List the definition names and its st.
	///
	d.addWord("WORDS+ST", (){
		var str = new StringBuffer();

		for (Word w in d.wordsList.reversed) {
			try {
				str.write("${w.name} ${w.st} ");
			} catch(e) {
				// empty word slot (reserved st) //TEMP
			}
		}
		print(str);
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
	/// [link]: http://forth-standard.org/standard/float/DtoF
	d.addWord("D>F", (){
		vm.floatStack.push(vm.dataStack.pop().toDouble());
	}, st: ST.DtoF.index);

	/// If the data-space pointer is not double-float aligned, reserve enough data space to make it so.
	///
	/// This word does nothing in this implementation.
	///
	/// [DFALIGN][link] ( -- )
	/// [link]: http://forth-standard.org/standard/float/DFALIGN
	d.addWordNope("DFALIGN", st: ST.DFALIGN.index);

	/// df-addr is the first double-float-aligned address greater than or equal to addr.
	///
	/// This word does nothing in this implementation.
	///
	/// [DFALIGNED][link] ( addr -- df-addr )
	/// [link]: http://forth-standard.org/standard/float/DFALIGNED
	d.addWordNope("DFALIGNED", st: ST.DFALIGNED.index);

	/// Store r at f-addr.
	///
	/// [F!][link] ( f-addr -- ) ( F: r -- )
	/// [link]: http://forth-standard.org/standard/float/FStore
	//
	// Stores a floating point number using eight bytes at the specified address.
	//
	// https://api.dartlang.org/stable/dart-typed_data/ByteData/setFloat64.html
	// https://en.wikipedia.org/wiki/Double-precision_floating-point_format
	d.addWord("F!", (){
		vm.dataSpace.storeFloat(vm.dataStack.pop(), vm.floatStack.pop());
	}, st: ST.FStore.index);

	/// r is the value stored at f-addr.
	///
	/// [F@][link] ( f-addr -- ) ( F: -- r )
	/// [link]: http://forth-standard.org/standard/float/FFetch
	//
	// Fetches a floating point number using eight bytes at the specified address.
	d.addWord("F@", (){
		vm.floatStack.push(vm.dataSpace.fetchFloat(vm.dataStack.pop()));
	}, st: ST.FFetch.index);

	/// Multiply r1 by r2 giving r3.
	///
	/// [F*][link] ( F: r1 r2 -- r3 )
	/// [link]: http://forth-standard.org/standard/float/FTimes
	d.addWord("F*", (){
		vm.floatStack.push(vm.floatStack.pop() * vm.floatStack.pop());
	}, st: ST.FTimes.index);

	/// Add r1 to r2 giving the sum r3.
	///
	/// [F+][link] ( F: r1 r2 -- r3 )
	/// [link]: http://forth-standard.org/standard/float/FPlus 
	d.addWord("F+", (){
		vm.floatStack.push(vm.floatStack.pop() + vm.floatStack.pop());
	}, st: ST.FPlus.index);

	/// Subtract r2 from r1, giving r3.
	///
	/// [F-][link] ( F: r1 r2 -- r3 )
	/// [link]: http://forth-standard.org/standard/float/FMinus
	d.addWord("F-", (){
		vm.floatStack.swap();
		vm.floatStack.push(vm.floatStack.pop() - vm.floatStack.pop());
	}, st: ST.FMinus.index);

	/// Divide r1 by r2, giving the quotient r3.
	///
	/// [F/][link] ( F: r1 r2 -- r3 )
	/// [link]: http://forth-standard.org/standard/float/FDiv
	d.addWord("F/", (){
		vm.floatStack.swap();
		vm.floatStack.push(vm.floatStack.pop() / vm.floatStack.pop());
	}, st: ST.FDiv.index);

	/// Raise r1 to the power r2, giving the product r3.
	///
	/// [F**][link]
	/// [link]: http://forth-standard.org/standard/float/FTimesTimes
	d.addWord("F**", (){
		vm.floatStack.swap();
		vm.floatStack.push(pow(vm.floatStack.pop(), vm.floatStack.pop()));
	}, st: ST.FTimesTimes.index);

	/// Display, with a trailing space, the top number on the floating-point stack using fixed-point notation.
	///
	/// [F.][link] ( -- ) ( F: r -- )
	/// [link]: http://forth-standard.org/standard/float/Fd
	d.addWord("F.", (){
		print(vm.floatStack.pop());
		// TODO: An ambiguous condition exists if the value of BASE is not (decimal) ten or if the
		// character string representation exceeds the size of the pictured numeric output string buffer.
	}, st: ST.Fd.index);

	/// d is the double-cell signed-integer equivalent of the integer portion of r.
	///
	/// [F>D][link] ( -- d ) ( F: r -- )
	/// [link]: http://forth-standard.org/standard/float/FtoD
	d.addWord("F>D", (){
		vm.dataStack.push(vm.floatStack.pop().toInt()); // FIXME TODO make it double
	}, st: ST.FtoD.index);

	/// d is the single-cell signed-integer equivalent of the integer portion of r.
	///
	/// [F>S][link] ( -- d ) ( F: r -- )
	/// [link]: http://forth-standard.org/standard/float/FtoS
	d.addWord("F>S", (){
		vm.dataStack.push(vm.floatStack.pop().toInt());
	}, st: ST.FtoS.index);

	/// r2 is the absolute value of r1.
	///
	/// [FABS][link] ( F: r1 -- r2 )
	/// [link]: http://forth-standard.org/standard/float/FABS
	d.addWord("FABS", (){
		vm.floatStack.push(vm.floatStack.pop().abs());
	}, st: ST.FABS.index);

	/// r2 is the principal radian angle whose cosine is r1.
	///
	/// [FACOS][link] ( F: r1 -- r2 )
	/// [link]: http://forth-standard.org/standard/float/FACOS
	d.addWord("FACOS", (){
		vm.floatStack.push(acos(vm.floatStack.pop()));
		// TODO: An ambiguous condition exists if | r1 | is greater than one.
	}, st: ST.FACOS.index);

	/// r2 is the floating-point value whose hyperbolic cosine is r1.
	///
	/// [FACOSH][link] ( F: r1 -- r2 )
	/// [link]: http://forth-standard.org/standard/float/FACOSH
	d.addWord("FACOSH", (){
		double x = vm.floatStack.pop();
		vm.floatStack.push(log(x + sqrt(x * x - 1)));
	}, st: ST.FACOSH.index);

	/// If the data-space pointer is not float aligned, reserve enough data space to make it so.
	///
	/// This word does nothing in this implementation.
	///
	/// [FALIGN][link] ( -- )
	/// [link]: http://forth-standard.org/standard/core/FALIGN
	d.addWordNope("FALIGN", st: ST.FALIGN.index);

	/// f-addr is the first float-aligned address greater than or equal to addr.
	///
	/// This word does nothing in this implementation.
	///
	/// [FALIGNED][link] ( addr -- f-addr )
	/// [link]: http://forth-standard.org/standard/core/FALIGNED
	d.addWordNope("FALIGNED", st: ST.FALIGNED.index);

	/// Raise ten to the power r1, giving r2.
	///
	/// [FALOG][link] ( F: r1 -- r2 )
	/// [link]: http://forth-standard.org/standard/float/FALOG
	d.addWord("FALOG", (){
		vm.floatStack.push(pow(10, vm.floatStack.pop()));
	}, st: ST.FALOG.index);

	/// r2 is the principal radian angle whose sine is r1.
	///
	/// [FASIN][link] ( F: r1 -- r2 )
	/// [link]: http://forth-standard.org/standard/float/FASIN
	d.addWord("FASIN", (){
		vm.floatStack.push(asin(vm.floatStack.pop()));
		// TODO: An ambiguous condition exists if | r1 | is greater than one.
	}, st: ST.FASIN.index);

	/// r2 is the floating-point value whose hyperbolic sine is r1.
	///
	/// [FASINH][link] ( F: r1 -- r2 )
	/// [link]: http://forth-standard.org/standard/float/FASINH
	d.addWord("FASINH", (){
		double x = vm.floatStack.pop();
		vm.floatStack.push(log(x + sqrt(x * x + 1)));
	}, st: ST.FASINH.index);

	/// r2 is the principal radian angle whose tangent is r1.
	///
	/// [FATAN][link] ( F: r1 -- r2 )	
	/// [link]: http://forth-standard.org/standard/float/FATAN
	d.addWord("FATAN", (){
		vm.floatStack.push(atan(vm.floatStack.pop()));
		// TODO: An ambiguous condition exists if r1 is less than or equal to zero.
	}, st: ST.FATAN.index);

	/// r3 is the principal radian angle (between -π and π) whose tangent is r1/r2.
	///
	/// [FATAN2][link] ( F: r1 r2 -- r3 )	
	/// [link]: http://forth-standard.org/standard/float/FATANTwo
	d.addWord("FATAN2", (){
		vm.floatStack.swap();
		vm.floatStack.push(atan2(vm.floatStack.pop(), vm.floatStack.pop()));
		// TODO: An ambiguous condition exists r1 and r2 are zero.
	}, st: ST.FATANTwo.index);

	/// r2 is the floating-point value whose hyperbolic tangent is r1.
	///
	/// [FATANH][link] ( F: r1 -- r2 )
	/// [link]: http://forth-standard.org/standard/float/FATANH
	d.addWord("FATANH", (){
		double x = vm.floatStack.pop();
		vm.floatStack.push(log((1+x)/(1-x)) / 2);
		// TODO: An ambiguous condition exists if r1 is outside the range of -1E0 to 1E0.
	}, st: ST.FATANH.index);

	/// r2 is the cosine of the radian angle r1.
	///
	/// [FCOS][link] ( F: r1 -- r2 )	
	/// [link]: http://forth-standard.org/standard/float/FCOS
	d.addWord("FCOS", (){
		vm.floatStack.push(cos(vm.floatStack.pop()));
	}, st: ST.FCOS.index);

	/// r2 is the hyperbolic cosine of r1.
	///
	/// [FCOSH][link] ( F: r1 -- r2 )	
	/// [link]: http://forth-standard.org/standard/float/FCOSH
	d.addWord("FCOSH", (){
		double x = vm.floatStack.pop();
		vm.floatStack.push((exp(2*x) + 1) / (2 * exp(x)));
	}, st: ST.FCOSH.index);

	/// +n is the number of values contained on the floating-point stack.
	///
	/// [FDEPTH][link] ( -- +n )
	/// [link]: http://forth-standard.org/standard/float/FDEPTH
	d.addWord("FDEPTH", (){
		vm.dataStack.push(vm.floatStack.size);
	}, st: ST.FDEPTH.index);

	/// Remove r from the floating-point stack.
	///
	/// [FDROP][link] ( F: r -- )
	/// [link]: http://forth-standard.org/standard/float/FDROP
	d.addWord("FDROP", vm.floatStack.drop, st: ST.FDROP.index);

	/// Duplicate r.
	///
	/// [FDUP][link] ( F: r -- r r )
	/// [link]: http://forth-standard.org/standard/float/FDUP
	d.addWord("FDUP", vm.floatStack.dup, st: ST.FDUP.index);

	/// Raise e to the power r1, giving r2.
	///
	/// [FEXP][link] ( F: r1 -- r2 )
	/// [link]: http://forth-standard.org/standard/float/FEXP
	d.addWord("FEXP", (){
		vm.floatStack.push(exp(vm.floatStack.pop()));
	}, st: ST.FEXP.index);

	/// Raise e to the power r1 and subtract one, giving r2.
	///
	/// [FEXPM1][link] ( F: r1 -- r2 )
	/// [link]: http://forth-standard.org/standard/float/FEXPMOne
	d.addWord("FEXPM1", (){
		vm.floatStack.push(exp(vm.floatStack.pop()) - 1);
	}, st: ST.FEXPMOne.index);

	/// r2 is the base-ten logarithm of r1.
	///
	/// [FLOG][link] ( F: r1 -- r2 )	
	/// [link]: http://forth-standard.org/standard/float/FLOG
	d.addWord("FLOG", (){
		vm.floatStack.push(log(vm.floatStack.pop()) / LN10);
		// TODO: An ambiguous condition exists if r1 is less than or equal to zero.
	}, st: ST.FLOG.index);

	/// Round r1 to an integral value using the "round toward negative infinity" rule, giving r2.
	///
	/// [FLOOR][link] ( F: r1 -- r2 )
	/// [link]: http://forth-standard.org/standard/float/FLOOR
	d.addWord("FLOOR", (){
		vm.floatStack.push(vm.floatStack.pop().floorToDouble());
	}, st: ST.FLOOR.index);

	/// r2 is the natural logarithm of r1. 
	///
	/// [FLN][link] ( F: r1 -- r2 )	
	/// [link]: http://forth-standard.org/standard/float/FLN
	d.addWord("FLN", (){
		vm.floatStack.push(log(vm.floatStack.pop()));
		// TODO: An ambiguous condition exists if r1 is less than or equal to zero.
	}, st: ST.FLN.index);

	/// r2 is the natural logarithm of the quantity r1 plus one.
	///
	/// [FLN][link] ( F: r1 -- r2 )	
	/// [link]: http://forth-standard.org/standard/float/FLNPOne
	d.addWord("FLNP1", (){
		vm.floatStack.push(log(vm.floatStack.pop() + 1));
		// TODO: An ambiguous condition exists if r1 is less than or equal to negative one.
	}, st: ST.FLNPOne.index);

	/// r3 is the greater of r1 and r2.
	///
	/// [FMAX][link] ( F: r1 r2 -- r3 )
	/// [link]: http://forth-standard.org/standard/float/FMAX
	d.addWord("FMAX", (){
		vm.floatStack.push(max(vm.floatStack.pop(), vm.floatStack.pop()));
	}, st: ST.FMAX.index);

	/// r3 is the lesser of r1 and r2.
	///
	/// [FMIN][link] ( F: r1 r2 -- r3 )
	/// [link]: http://forth-standard.org/standard/float/FMIN
	d.addWord("FMIN", (){
		vm.floatStack.push(min(vm.floatStack.pop(), vm.floatStack.pop()));
	}, st: ST.FMIN.index);

	/// r2 is the negation of r1.
	///
	/// [FNEGATE][link] ( F: r1 -- r2 )
	/// [link]: http://forth-standard.org/standard/float/FNEGATE
	d.addWord("FNEGATE", (){
		vm.floatStack.push(-vm.floatStack.pop());
	}, st: ST.FNEGATE.index);

	/// Place a copy of r1 on top of the floating-point stack.
	///
	/// [FOVER][link] ( F: r1 r2 -- r1 r2 r1 )
	/// [link]: http://forth-standard.org/standard/float/FOVER
	d.addWord("FOVER", vm.floatStack.over, st: ST.FOVER.index);

	/// Rotate the top three floating-point stack entries.
	///
	/// [FROT][link] ( F: r1 r2 r3 -- r2 r3 r1 )
	/// [link]: http://forth-standard.org/standard/float/FROT
	d.addWord("FROT", vm.floatStack.rot, st: ST.FROT.index);

	/// Round r1 to an integral value using the "round to nearest" rule, giving r2.
	///
	/// [FROUND][link] ( F: r1 -- r2 )
	/// [link]: http://forth-standard.org/standard/float/FROUND
	d.addWord("FROUND", (){
		vm.floatStack.push(vm.floatStack.pop().roundToDouble());
	}, st: ST.FROUND.index);

	/// r2 is the sine of the radian angle r1.
	///
	/// [FSIN][link] ( F: r1 -- r2 )	
	/// [link]: http://forth-standard.org/standard/float/FSIN
	d.addWord("FSIN", (){
		vm.floatStack.push(sin(vm.floatStack.pop()));
	}, st: ST.FSIN.index);

	/// r2 is the sine of the radian angle r1. r3 is the cosine of the radian angle r1.
	///
	/// [FSINCOS][link] ( F: r1 -- r2 r3 )	
	/// [link]: http://forth-standard.org/standard/float/FSINCOS
	d.addWord("FSINCOS", (){
		double x = vm.floatStack.pop();
		vm.floatStack.push(sin(x));
		vm.floatStack.push(cos(x));
	}, st: ST.FSINCOS.index);

	/// r2 is the hyperbolic sine of r1.
	///
	/// [FSINH][link] ( F: r1 -- r2 )	
	/// [link]: http://forth-standard.org/standard/float/FSINH
	d.addWord("FSINH", (){
		double x = vm.floatStack.pop();
		vm.floatStack.push((exp(2*x) - 1) / (2 * exp(x)));
	}, st: ST.FSINH.index);

	/// r2 is the hyperbolic tangent of r1.
	///
	/// [FTAN][link] ( F: r1 -- r2 )	
	/// [link]: http://forth-standard.org/standard/float/FTANH
	d.addWord("FTANH", (){
		double x = vm.floatStack.pop();
		vm.floatStack.push(
			((exp(2*x) - 1) / (2 * exp(x))) / ((exp(2*x) + 1) / (2 * exp(x)))
		);
	}, st: ST.FTANH.index);

	/// Exchange the top two floating-point stack items.
	///
	/// [FSWAP][link] a ( F: x1 x2 -- x2 x1 )
	/// [link]: http://forth-standard.org/standard/float/FSWAP
	d.addWord("FSWAP", vm.floatStack.swap, st: ST.FSWAP.index);

	/// If the data-space pointer is not single-float aligned, reserve enough data space to make it so.
	///
	/// This word does nothing in this implementation.
	///
	/// [SFALIGN][link] ( -- )
	/// [link]: http://forth-standard.org/standard/core/SFALIGN
	d.addWordNope("SFALIGN", st: ST.SFALIGN.index);

	/// sf-addr is the first single-float-aligned address greater than or equal to addr.
	///
	/// This word does nothing in this implementation.
	///
	/// [SFALIGNED][link] ( addr -- sf-addr )
	/// [link]: http://forth-standard.org/standard/core/SFALIGNED
	d.addWordNope("SFALIGNED", st: ST.SFALIGNED.index);

	/// r2 is the square root of r1.
	///
	/// [FSQRT][link] ( F: r1 -- r2 )
	/// [link]: http://forth-standard.org/standard/float/FSQRT
	d.addWord("FSQRT", (){
		vm.floatStack.push(sqrt(vm.floatStack.pop()));
		// TODO: An ambiguous condition exists if r1 is less than zero.
	}, st: ST.FSQRT.index);

	/// r2 is the tangent of the radian angle r1.
	///
	/// [FTAN][link] ( F: r1 -- r2 )	
	/// [link]: http://forth-standard.org/standard/float/FTAN
	d.addWord("FTAN", (){
		vm.floatStack.push(tan(vm.floatStack.pop()));
		// TODO: An ambiguous condition exists if (r1) is zero.
	}, st: ST.FTAN.index);

	/// Round r1 to an integral value using the "round towards zero" rule, giving r2.
	///
	/// [FTRUNC][link] ( F: r1 -- r2 )
	/// [link]: http://forth-standard.org/standard/float/TRUNC
	d.addWord("FTRUNC", (){
		vm.floatStack.push(vm.floatStack.pop().truncateToDouble());
	}, st: ST.FTRUNC.index);
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
	d.addWord(".S", (){
		print("dataStack: ${vm.dataStack}");
	}, st: ST.DotS.index);

	/// Display the contents of u consecutive addresses starting at addr.
	///
	/// [DUMP][link] ( addr u -- )
	/// [link]: http://forth-standard.org/standard/tools/DUMP
	d.addWord("DUMP", (){
		vm.dataStack.over();
		print( dumpBytes(vm.dataSpace.getCharList(vm.dataStack.pop(), vm.dataStack.pop()), vm.dataStack.pop()) );
	}, st: ST.DUMP.index);

	/// Display the value stored at a-addr.
	///
	/// It's re-implemented in CLI.
	///
	/// [?][link] ( a-addr -- )
	/// [link]: http://forth-standard.org/standard/tools/q
	d.addWord("?", (){
		print(vm.dataSpace.fetchCell(vm.dataStack.pop()).toRadixString(vm.dataSpace.fetchCell(addrBASE)));
	}, st: ST.q.index);

	/// List the definition names in the first word list of the search order.
	///
	/// [WORDS][link] ( -- )
	/// [link]: http://forth-standard.org/standard/tools/WORDS
	d.addWord("WORDS", (){
		var str = new StringBuffer();
		for (Word w in d.wordsList.reversed) {
			try {
				str.write("${w.name} ");
			} catch(e) {
				// empty word slot (reserved st) //TEMP
			}
		}
		print(str);
	}, st: ST.WORDS.index);

	/// Return control to the host operating system, if any.
	///
	/// It's re-implemented in CLI.
	///
	/// [BYE][link] ( -- )
	/// [link]: http://forth-standard.org/standard/tools/BYE
	d.addWordNope("BYE", st: ST.BYE.index);
}


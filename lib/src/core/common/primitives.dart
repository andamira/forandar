part of forandar.core.primitives;

class Primitives {

  final VirtualMachine vm;

  Primitives(this.vm);

  /// Loads the primitives definitions in the dictionary.
  load() {

    // CORE DEFINITIONS
    // ----------------

    // Core standard words.
    standardCore();

    // Core non-standard words of common use.
    nonStandardCore();

    // Useful non-standard extra words.
    nonStandardExtra();

    // OPTIONAL DEFINITIONS
    // --------------------

    // Block.
    standardOptionalBlock();

    // Double.
    standardOptionalDouble();

    // Exception.
    standardOptionalException();

    // Facility.
    standardOptionalFacility();

    // File.
    standardOptionalFile();

    // Floating-Point.
    standardOptionalFloat();

    // Locals.
    standardOptionalLocals();

    // Memory.
    standardOptionalMemory();

    // Programming-tools.
    standardOptionalTools();

    // Search.
    standardOptionalSearch();

    // String.
    standardOptionalString();

    // Extended-Character.
    standardOptionalXChar();
  }

  /// Defines the [Forth standard CORE primitives][link].
  ///
  /// [link]: http://forth-standard.org/standard/core/
  standardCore() {

    // Total: 182 (133 main + 49 extended)
    //
    // Implemented:
    //
    // ! * + +! - , . / /MOD 0< 0= 1+ 1- 2! 2@ 2DROP 2DUP 2OVER 2SWAP ?DUP < = > >IN >R @ ABS AND ALIGN ALIGNED ALLOT BASE BL C! C, C@ CELL+ CELLS CHAR+ CHARS CR DEPTH DECIMAL DROP DUP EVALUATE EXECUTE HERE IMMEDIATE INVERT LSHIFT MAX MIN MOD NEGATE OR OVER QUIT R> R@ ROT RSHIFT SOURCE SPACE SPACES STATE SWAP U. U< XOR
    //
    // 0<> 0> 2>R 2R> 2R@ <> ERASE FALSE HEX NIP PAD PARSE PARSE-NAME PICK REFILL ROLL SOURCE-ID TRUE TUCK U>
    //
    //
    // Not implemented:
    //
    // # #> #S ' ( */ */MOD +LOOP ." 2* 2/
    // : ; <# >BODY >NUMBER ABORT
    // ABORT" ACCEPT BEGIN
    // CHAR CONSTANT COUNT CREATE DO DOES>
    // ELSE EMIT ENVIRONMENT? EXIT FILL FIND FM/MOD
    // HOLD I IF J KEY LEAVE LITERAL LOOP M*
    // MOVE POSTPONE RECURSE REPEAT
    // S" S>D SIGN SM/REM THEN TYPE UM*
    // UM/MOD UNLOOP UNTIL VARIABLE WHILE WORD [ ['] [CHAR] ]
    //
    // .( .R :NONAME ?DO ACTION-OF AGAIN BUFFER: C"
    // CASE COMPILE, DEFER DEFER! DEFER@ ENDCASE ENDOF HOLDS
    // IS MARKER OF RESTORE-INPUT
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
    vm.dict.addWord("!", (){
      vm.dataSpace.storeCell(vm.dataStack.pop, vm.dataStack.pop);
    }, nt: Nt.Store);

    /// Multiply n1 | u1 by n2 | u2 giving the product n3 | u3.
    ///
    /// [*][link] ( n1 | u1 n2 | u2 -- n3 | u3 )
    /// [link]: http://forth-standard.org/standard/core/Times
    vm.dict.addWord("*", (){
      vm.dataStack.push((vm.dataStack.pop * vm.dataStack.pop));
    }, nt: Nt.Times);

    /// Add n2 | u2 to n1 | u1, giving the sum n3 | u3.
    ///
    /// [+][link] ( n1 | u1 n2 | u2 -- n3 | u3 )
    /// [link]: http://forth-standard.org/standard/core/Plus
    vm.dict.addWord("+", (){
      vm.dataStack.push(vm.dataStack.pop + vm.dataStack.pop);
    }, nt: Nt.Plus);

    /// Add n | u to the single-cell number at a-addr.
    ///
    /// [+!][link] ( n | u a-addr -- )
    /// [link]: http://forth-standard.org/standard/core/PlusStore
    vm.dict.addWord("+!", (){
      int addr = vm.dataStack.pop;
      vm.dataSpace.storeCell(addr, vm.dataSpace.fetchCell(addr) + vm.dataStack.pop);
    }, nt: Nt.PlusStore);

    /// Reserve one cell of data space and store x in the cell.
    ///
    /// [,][link] ( x -- )
    /// [link]: http://forth-standard.org/standard/core/Comma
    vm.dict.addWord(",", (){
      vm.dataSpace.storeCellHere(vm.dataStack.pop);
    }, nt: Nt.Comma);

    /// Subtract n2 | u2 from n1 | u1, giving the difference n3 | u3.
    ///
    /// [-][link] ( n1 | u1 n2 | u2 -- n3 | u3 )
    /// [link]: http://forth-standard.org/standard/core/Minus
    vm.dict.addWord("-", (){
      vm.dataStack.swap();
      vm.dataStack.push(vm.dataStack.pop - vm.dataStack.pop);
    }, nt: Nt.Minus);

    /// Display n in free field format.
    ///
    /// [.][link] ( n -- )
    /// [link]: http://forth-standard.org/standard/core/d
    vm.dict.addWord(".", (){
      print(vm.dataStack.pop);
    }, nt: Nt.d);

    /// Divide n1 by n2, , giving the single-cell quotient n3.
    ///
    /// [/][link] ( n1 n2 -- n3 )
    /// [link]: http://forth-standard.org/standard/core/Div
    vm.dict.addWord("/", (){
      vm.dataStack.swap();
      vm.dataStack.push(vm.dataStack.pop ~/ vm.dataStack.pop);
      // CHECK: An ambiguous condition exists if n2 is zero.
      // If n1 and n2 differ in sign, the implementation-defined result
      // returned will be the same as that returned by either the phrase
      // >R S>D R> FM/MOD SWAP DROP or the phrase >R S>D R> SM/REM SWAP DROP.
    }, nt: Nt.Div);

    /// Divide n1 by n2, giving the single-cell remainder n3 and the single-cell quotient n4.
    ///
    /// : [/MOD][link] ( n1 n2 -- n3 n4 )
    /// 2DUP MOD -ROT / ;
    /// [link]: http://forth-standard.org/standard/core/DivMOD
    vm.dict.addWord("/MOD", (){
      int x = vm.dataStack.pop;
      int y = vm.dataStack.pop;
      vm.dataStack.push( y % x);
      vm.dataStack.push( y ~/ x);
      // CHECK: An ambiguous condition exists if n2 is zero.
      // If n1 and n2 differ in sign, the implementation-defined result
      // returned will be the same as that returned by either the phrase
      // >R S>D R> FM/MOD or the phrase >R S>D R> SM/REM.
    }, nt: Nt.DivMOD);

    /// flag is true if and only if n is less than zero.
    ///
    /// [0<][link] ( x -- flag )
    /// [link]: http://forth-standard.org/standard/core/Zeroless
    vm.dict.addWord("0<", (){
      vm.dataStack.pop < 0 ? vm.dataStack.push(flagTRUE) : vm.dataStack.push(flagFALSE);
    }, nt: Nt.Zeroless);

    /// flag is true if and only if x is not equal to zero.
    ///
    /// [0<>][link] ( x -- flag )
    /// [link]: http://forth-standard.org/standard/core/Zerone
    vm.dict.addWord("0<>", (){
      vm.dataStack.pop != 0 ? vm.dataStack.push(flagTRUE) : vm.dataStack.push(flagFALSE);
    }, nt: Nt.Zerone);

    /// flag is true if and only if x is equal to zero.
    ///
    /// [0=][link] ( x -- flag )
    /// [link]: http://forth-standard.org/standard/core/ZeroEqual
    vm.dict.addWord("0=", (){
      vm.dataStack.pop == 0 ? vm.dataStack.push(flagTRUE) : vm.dataStack.push(flagFALSE);
    }, nt: Nt.ZeroEqual);

    /// flag is true if and only if n is greater than zero.
    ///
    /// [0>][link] ( x -- flag )
    /// [link]: http://forth-standard.org/standard/core/Zeromore
    vm.dict.addWord("0>", (){
      vm.dataStack.pop > 0 ? vm.dataStack.push(flagTRUE) : vm.dataStack.push(flagFALSE);
    }, nt: Nt.Zeromore);

    /// Add one (1) to n1 | u1 giving the sum n2 | u2.
    ///
    /// [1+][link] ( n1 | u1 -- n2 | u2 )
    /// [link]: http://forth-standard.org/standard/core/OnePlus
    vm.dict.addWord("1+", (){
      vm.dataStack.push(vm.dataStack.pop + 1);
    }, nt: Nt.OnePlus);

    /// Subtract one (1) from n1 | u1 giving the difference n2 | u2.
    ///
    /// [1-][link] ( n1 | u1 -- n2 | u2 )
    /// [link]: http://forth-standard.org/standard/core/OneMinus
    vm.dict.addWord("1-", (){
      vm.dataStack.push(vm.dataStack.pop - 1);
    }, nt: Nt.OneMinus);

    /// Store the cell pair x1 x2 at a-addr, with x2 at a-addr and x1 at the next consecutive cell.
    ///
    /// : [2!][link] ( x1 x2 a-addr -- )
    /// SWAP OVER ! CELL+ ! ;
    /// [link]: http://forth-standard.org/standard/core/TwoStore
    vm.dict.addWord("2!", (){
      int addr = vm.dataStack.pop;
      vm.dataSpace.storeCell(addr + sizeCELL, vm.dataStack.pop );
      vm.dataSpace.storeCell(addr, vm.dataStack.pop );
    }, nt: Nt.TwoStore);

    /// Fetch the cell pair x1 x2 stored at a-addr. x2 is stored at a-addr and x1 at the next consecutive cell.
    ///
    /// : [2@][link] ( a-addr -- x1 x2 )
    /// DUP CELL+ @ SWAP @ ;
    /// [link]: http://forth-standard.org/standard/core/TwoFetch
    vm.dict.addWord("2@", (){
      int addr = vm.dataStack.pop;
      vm.dataStack.push(vm.dataSpace.fetchCell(addr + sizeCELL));
      vm.dataStack.push(vm.dataSpace.fetchCell(addr));
    }, nt: Nt.TwoFetch);

    /// Execution: Transfer cell pair x1 x2 to the return stack.
    ///
    /// : [2>R][link] ( x1 x2 -- ) ( R: -- x1 x2 )
    /// SWAP >R >R ; IMMEDIATE
    /// [link]: http://forth-standard.org/standard/core/TwotoR
    vm.dict.addWord("2>R", () {
      vm.dataStack.swap();
      vm.returnStack.push(vm.dataStack.pop);
      vm.returnStack.push(vm.dataStack.pop);
    }, nt: Nt.TwotoR, immediate: true);

    /// Drop cell pair x1 x2 from the stack.
    ///
    /// [2DROP][link] ( x1 x2 -- )
    /// [link]: http://forth-standard.org/standard/core/TwoDROP
    vm.dict.addWord("2DROP", vm.dataStack.drop2, nt: Nt.TwoDROP);

    /// Duplicate cell pair x1 x2.
    ///
    /// : [2DUP][link] ( x1 x2 -- x1 x2 x1 x2 )
    /// OVER OVER ;
    /// [link]: http://forth-standard.org/standard/core/TwoDUP
    vm.dict.addWord("2DUP", vm.dataStack.dup2, nt: Nt.TwoDUP);

    /// Copy cell pair x1 x2 to the top of the stack.
    ///
    /// [2OVER][link] ( x1 x2 x3 x4 -- x1 x2 x3 x4 x1 x2 )
    /// [link]: http://forth-standard.org/standard/core/TwoOVER
    vm.dict.addWord("2OVER", vm.dataStack.over2, nt: Nt.TwoOVER);

    /// Duplicate cell pair x1 x2.
    ///
    /// [2SWAP][link] ( x1 x2 x3 x4 -- x3 x4 x1 x2 )
    /// [link]: http://forth-standard.org/standard/core/TwoSWAP
    vm.dict.addWord("2SWAP", vm.dataStack.swap2, nt: Nt.TwoSWAP);

    /// Execution: Transfer cell pair x1 x2 from the return stack.
    ///
    /// : [2R>][link] ( -- x1 x2 ) ( R: x1 x2 -- )
    /// R> R> SWAP ; IMMEDIATE
    /// [link]: http://forth-standard.org/standard/core/TwoRfrom
    vm.dict.addWord("2R>", () {
      vm.dataStack.push(vm.returnStack.pop);
      vm.dataStack.push(vm.returnStack.pop);
      vm.dataStack.swap();
    }, nt: Nt.TwoRfrom, immediate: true);

    /// Execution: Copy cell pair x1 x2 from the return stack.
    ///
    /// : [2R@][link] ( -- x1 x2 ) ( R: x1 x2 -- x1 x2 )
    /// R> R> 2DUP >R >R SWAP ; IMMEDIATE
    /// [link]: http://forth-standard.org/standard/core/TwoRFetch
    vm.dict.addWord("2R@", () {
      vm.dataStack.push(vm.returnStack.peek);
      vm.dataStack.push(vm.returnStack.peek);
      vm.dataStack.swap();
    }, nt: Nt.TwoRFetch, immediate: true);

    /// flag is true if and only if n1 is less than n2.
    ///
    /// [<][link] ( n1 n2 -- flag )
    /// [link]: http://forth-standard.org/standard/core/less
    vm.dict.addWord("<", (){
      vm.dataStack.pop > vm.dataStack.pop ? vm.dataStack.push(flagTRUE) : vm.dataStack.push(flagFALSE);
    }, nt: Nt.less);

    /// flag is true if and only if x1 is not bit-for-bit the same as x2.
    ///
    /// [<>][link] ( n1 n2 -- flag )
    /// [link]: http://forth-standard.org/standard/core/ne
    vm.dict.addWord("<>", (){
      vm.dataStack.pop != vm.dataStack.pop ? vm.dataStack.push(flagTRUE) : vm.dataStack.push(flagFALSE);
    }, nt: Nt.ne);

    /// flag is true if and only if x1 is bit-for-bit the same as x2.
    ///
    /// [=][link] ( n1 n2 -- flag )
    /// [link]: http://forth-standard.org/standard/core/Equal
    vm.dict.addWord("=", (){
      vm.dataStack.pop == vm.dataStack.pop ? vm.dataStack.push(flagTRUE) : vm.dataStack.push(flagFALSE);
    }, nt: Nt.Equal);

    /// flag is true if and only if n1 is more than n2.
    ///
    /// [>][link] ( n1 n2 -- flag )
    /// [link]: http://forth-standard.org/standard/core/more
    vm.dict.addWord(">", (){
      vm.dataStack.pop < vm.dataStack.pop ? vm.dataStack.push(flagTRUE) : vm.dataStack.push(flagFALSE);
    }, nt: Nt.more);

    /// a-addr is the address of a cell containing the offset in characters from the start of the input buffer to the start of the parse area.
    ///
    /// [>IN][link] ( -- a-addr )
    /// [link]: http://forth-standard.org/standard/core/toIN
    vm.dict.addWord(">IN", () {
      vm.dataStack.push(addrToIN);
    }, nt: Nt.toIN);

    /// Moves data FROM the data stack to the return stack.
    ///
    /// [>R][link] ( x -- ) ( R: -- x )
    /// [link]: http://forth-standard.org/standard/core/toR
    vm.dict.addWord(">R", () {
      vm.returnStack.push(vm.dataStack.pop);
    }, nt: Nt.toR, immediate: true);

    /// Duplicate x if it is non-zero.
    ///
    /// [?DUP][link] ( x -- 0 | x x )
    /// [link]: http://forth-standard.org/standard/core/qDUP
    vm.dict.addWord("?DUP", () {
      if (vm.dataStack.peek != 0) vm.dataStack.dup();
    }, nt: Nt.qDUP);

    /// x is the value stored at a-addr.
    ///
    /// [@][link] ( a-addr -- x )
    /// [link]: http://forth-standard.org/standard/core/Fetch
    vm.dict.addWord("@", (){
      vm.dataStack.push(vm.dataSpace.fetchCell(vm.dataStack.pop));
    }, nt: Nt.Fetch);

    /// u is the absolute value of n.
    ///
    /// [ABS][link] ( n -- u )
    /// [link]: http://forth-standard.org/standard/core/ABS
    vm.dict.addWord("ABS", (){
      vm.dataStack.push(vm.dataStack.pop.abs());
    }, nt: Nt.ABS);

    /// If the data-space pointer is not aligned, reserve enough space to align it.
    ///
    /// This word does nothing in this implementation.
    ///
    /// [ALIGN][link] ( -- )
    /// [link]: http://forth-standard.org/standard/core/ALIGN
    vm.dict.addWordNope("ALIGN", nt: Nt.ALIGN);

    /// a-addr is the first aligned address greater than or equal to addr.
    ///
    /// This word does nothing in this implementation.
    ///
    /// [ALIGNED][link] ( addr -- a-addr )
    /// [link]: http://forth-standard.org/standard/core/ALIGNED
    vm.dict.addWordNope("ALIGNED", nt: Nt.ALIGNED);

    /// If n > 0, reserve n address units of data space. If n < 0, release | n | address units of data space.
    ///
    /// [ALLOT][link] ( n -- )
    /// [link]: http://forth-standard.org/standard/core/ALLOT
    vm.dict.addWord("ALLOT", () {
      vm.dataSpace.pointer += vm.dataStack.pop;
    }, nt: Nt.ALLOT);

    /// x3 is the bit-by-bit logical "and" of x1 with x2.
    ///
    /// [AND][link] ( x1 x2 -- x3 )
    /// [link]: http://forth-standard.org/standard/core/AND
    vm.dict.addWord("AND", (){
      vm.dataStack.push(vm.dataStack.pop & vm.dataStack.pop);
    }, nt: Nt.AND);

    /// Puts in the stack the address of a cell containing the current number-conversion radix {{2...36}}.
    ///
    /// [BASE][link] ( -- a-addr )
    /// [link]: http://forth-standard.org/standard/core/BASE
    vm.dict.addWord("BASE", () {
      vm.dataStack.push(addrBASE);
    }, nt: Nt.BASE);

    /// char is the character value for a space.
    ///
    /// [BL][link] ( -- char )
    /// [link]: http://forth-standard.org/standard/core/BL
    vm.dict.addWord("BL", (){
      vm.dataStack.push(0x20); // SPACE = 0x20
    }, nt: Nt.BL);

    /// Store char at c-addr.
    ///
    /// [C!][link] ( char a-addr -- )
    /// [link]: http://forth-standard.org/standard/core/CStore
    vm.dict.addWord("C!", (){
      vm.dataSpace.storeChar(vm.dataStack.pop, vm.dataStack.pop);
    }, nt: Nt.CStore);

    /// Reserve space for one character in the data space and store char in the space.
    ///
    /// [C,][link] ( x -- )
    /// [link]: http://forth-standard.org/standard/core/CComma
    vm.dict.addWord("C,", (){
      vm.dataSpace.storeCharHere(vm.dataStack.pop);
    }, nt: Nt.CComma);

    /// Fetch the character stored at c-addr.
    ///
    /// [C@][link] ( c-addr -- char )
    /// [link]: http://forth-standard.org/standard/core/CFetch
    //
    vm.dict.addWord("C@", (){
      vm.dataStack.push(vm.dataSpace.fetchChar(vm.dataStack.pop));
    }, nt: Nt.CFetch);

    /// Add the size in address units of a cell to a-addr1, giving a-addr2.
    ///
    /// [CELL+][link] ( a-addr1 -- a-addr2 )
    /// [link]: http://forth-standard.org/standard/core/CELLPlus
    vm.dict.addWord("CELL+", (){
      vm.dataStack.push(vm.dataStack.pop + sizeCELL);
    }, nt: Nt.CELLPlus);

    /// n2 is the size in address units of n1 cells.
    ///
    /// [CELLS][link] ( n1 -- n2 )
    /// [link]: http://forth-standard.org/standard/core/CELLS
    vm.dict.addWord("CELLS", (){
      vm.dataStack.push(vm.dataStack.pop * sizeCELL);
    }, nt: Nt.CELLS);

    /// Add the size in address units of a character to c-addr1, giving c-addr2.
    ///
    /// [CHAR+][link] ( c-addr1 -- c-addr2 )
    /// [link]: http://forth-standard.org/standard/core/CHARPlus
    vm.dict.addWord("CHAR+", (){
      // TODO: support extended characters
      vm.dataStack.push(vm.dataStack.pop + sizeCHAR);
    }, nt: Nt.CHARPlus);

    /// n2 is the size in address units of n1 characters.
    ///
    /// This word does nothing in this implementation.
    ///
    /// [CHARS][link] ( n1 -- n2 )
    /// [link]: http://forth-standard.org/standard/core/CHARS
    vm.dict.addWordNope("CHARS", nt: Nt.CHARS);

    /// Cause subsequent output to appear at the beginning of the next line.
    ///
    /// [CR][link] ( -- )
    /// [link]: http://forth-standard.org/standard/core/CR
    vm.dict.addWord("CR", (){
      print("");
    }, nt: Nt.CR);

    /// Set the numeric conversion radix to ten (decimal).
    ///
    /// [DECIMAL][link] ( -- a-addr )
    /// [link]: http://forth-standard.org/standard/core/DECIMAL
    vm.dict.addWord("DECIMAL", () {
      vm.dataSpace.storeCell(addrBASE, 10);
    }, nt: Nt.DECIMAL);

    /// +n is the number of single-cell values contained in the data stack before +n was placed on the stack.
    ///
    /// [DEPTH][link] ( -- +n )
    /// [link]: http://forth-standard.org/standard/core/DEPTH
    vm.dict.addWord("DEPTH", (){
      vm.dataStack.push(vm.dataStack.size);
    }, nt: Nt.DEPTH);

    /// Duplicate x.
    ///
    /// [DUP][link] ( x -- x x )
    /// [link]: http://forth-standard.org/standard/core/DUP
    vm.dict.addWord("DUP", vm.dataStack.dup, nt: Nt.DUP);

    /// Remove x from the stack.
    ///
    /// [DROP][link] ( x -- )
    /// [link]: http://forth-standard.org/standard/core/DROP
    vm.dict.addWord("DROP", vm.dataStack.drop, nt: Nt.DROP);

    /// Evaluate a string.
    ///
    /// [EVALUATE][link] ( i * x c-addr u -- j * x )
    /// [link]: http://forth-standard.org/standard/core/EVALUATE
    vm.dict.addWord("EVALUATE", (){

      // Save the current input source specification.
      vm.dict.execNt(Nt.SAVE_INPUT); // TODO

      // Store minus-one (-1) in SOURCE-ID if it is present.
      vm.input.sourceId = -1;

      // Make the string described by c-addr and u both the input source and input buffer.

      // TEMP FIXME
      //vm.dataSpace.setCharRange(addrInputBuffer, inputUTF8);
      //vm.input.sourceLength = inputUTF8.length;

      // set >IN to zero
      vm.dataSpace.storeCell(addrToIN, 0);

      try {
        // Interpret.
        vm.dict.execNt(Nt.INTERPRET);

      } on ForthError catch(error) {
        print(error);

      } catch(error) {
        print(ForthError.unmanaged(error, preMsg: "EVALUATE »"));

      } finally {
        // Clear the stacks in any case.
        vm.dataStack.clear();
        vm.floatStack.clear();
        vm.returnStack.clear();
        vm.controlStack.clear();
      }

      // When the parse area is empty, restore the prior input source specification.
      // TODO
      vm.dict.execNt(Nt.RESTORE_INPUT); // TODO

    }, nt: Nt.EVALUATE);

    /// If u is greater than zero, clear all bits in each of u consecutive address units of memory beginning at addr.
    ///
    /// [ERASE][link] ( addr u -- )
    /// [link]: http://forth-standard.org/standard/core/ERASE
    vm.dict.addWord("ERASE", (){
      int length = vm.dataStack.pop;
      int address =  vm.dataStack.pop;
      if (length > 0) {
        vm.dataSpace.fillCharRange(address, length, 0);
      }
    }, nt: Nt.ERASE);

    /// Remove xt from the stack and perform the semantics identified by it. Other stack effects are due to the word EXECUTEd.
    ///
    /// [EXECUTE][link] ( i * x xt -- j * x )
    /// [link]: http://forth-standard.org/standard/core/EXECUTE
    vm.dict.addWord("EXECUTE", (){
      vm.dict.execNtIndex(vm.dataStack.pop);
    }, nt: Nt.EXECUTE);

    /// Return a false flag.
    ///
    /// [FALSE][link] ( -- false )
    /// [link]: http://forth-standard.org/standard/core/FALSE
    vm.dict.addWord("FALSE", (){
      vm.dataStack.push(flagFALSE);
    }, nt: Nt.FALSE);

    /// addr is the data-space pointer.
    ///
    /// [HERE][link] ( -- addr )
    /// [link]: http://forth-standard.org/standard/core/HERE
    vm.dict.addWord("HERE", (){
      vm.dataStack.push(vm.dataSpace.pointer);
    }, nt: Nt.HERE);

    /// Set contents of BASE to sixteen.
    ///
    /// [HEX][link] ( -- a-addr )
    /// [link]: http://forth-standard.org/standard/core/HEX
    vm.dict.addWord("HEX", () {
      vm.dataSpace.storeCell(addrBASE, 16);
    }, nt: Nt.HEX);

    /// Make the most recent definition an immediate word.
    ///
    /// [IMMEDIATE][link] ( -- )
    /// [link]: http://forth-standard.org/standard/core/IMMEDIATE
    vm.dict.addWord("IMMEDIATE", () {
      vm.dict.lastWord.isImmediate = true;
    }, nt: Nt.IMMEDIATE);

    /// Invert all bits of x1, giving its logical inverse x2.
    ///
    /// [INVERT][link] ( x1 -- x2 )
    /// [link]: http://forth-standard.org/standard/core/INVERT
    vm.dict.addWord("INVERT", (){
      vm.dataStack.push(~vm.dataStack.pop);
    }, nt: Nt.INVERT);

    /// Receive one character char.
    ///
    /// [KEY][link] ( -- char )
    /// [link]: http://forth-standard.org/standard/core/KEY
    vm.dict.addWordNope("KEY", nt: Nt.KEY);

    /// Perform a logical left shift of u bit-places on x1, giving x2.
    ///
    /// [LSHIFT][link] ( x1 u -- x2 )
    /// [link]: http://forth-standard.org/standard/core/LSHIFT
    vm.dict.addWord("LSHIFT", (){
      vm.dataStack.swap();
      vm.dataStack.push(vm.dataStack.pop << vm.dataStack.pop);
      // CHECK: An ambiguous condition exists if u is greater thans
      // or equal to the number of bits in a cell.
    }, nt: Nt.LSHIFT);

    /// n3 is the greater of n1 and n2.
    ///
    /// [MAX][link] ( n1 n2 -- n3 )
    /// [link]: http://forth-standard.org/standard/core/MAX
    vm.dict.addWord("MAX", (){
      vm.dataStack.push(max(vm.dataStack.pop, vm.dataStack.pop));
    }, nt: Nt.MAX);

    /// n3 is the lesser of n1 and n2.
    ///
    /// [MIN][link] ( n1 n2 -- n3 )
    /// [link]: http://forth-standard.org/standard/core/MIN
    vm.dict.addWord("MIN", (){
      vm.dataStack.push(min(vm.dataStack.pop, vm.dataStack.pop));
    }, nt: Nt.MIN);

    /// Divide n1 by n2, giving the single-cell remainder n3.
    ///
    /// [MOD][link] ( n1 n2 -- n3 )
    /// [link]: http://forth-standard.org/standard/core/MOD
    vm.dict.addWord("MOD", (){
      vm.dataStack.swap();
      vm.dataStack.push(vm.dataStack.pop % vm.dataStack.pop);
      // CHECK: An ambiguous condition exists if n2 is zero.
      // If n1 and n2 differ in sign, the implementation-defined result
      // returned will be the same as that returned by either the phrase
      // >R S>D R> FM/MOD DROP or the phrase >R S>D R> SM/REM DROP.
    }, nt: Nt.MOD);

    /// Negate n1, giving its arithmetic inverse n2.
    ///
    /// [NEGATE][link] ( n1 -- n2 )
    /// [link]: http://forth-standard.org/standard/core/NEGATE
    vm.dict.addWord("NEGATE", (){
      vm.dataStack.push(-vm.dataStack.pop);
    }, nt: Nt.NEGATE);

    /// Drop the first item below the top of stack.
    ///
    /// [NIP][link] ( x1 x2 -- x2 )
    /// [link]: http://forth-standard.org/standard/core/NIP
    vm.dict.addWord("NIP", vm.dataStack.nip, nt: Nt.NIP);

    /// x3 is the bit-by-bit inclusive-or of x1 with x2.
    ///
    /// [OR][link] ( x1 x2 -- x3 )
    /// [link]: http://forth-standard.org/standard/core/OR
    vm.dict.addWord("OR", (){
      vm.dataStack.push(vm.dataStack.pop | vm.dataStack.pop);
    }, nt: Nt.OR);

    /// Place a copy of x1 on top of the stack.
    ///
    /// [OVER][link] ( x1 x2 -- x1 x2 x1 )
    /// [link]: http://forth-standard.org/standard/core/OVER
    vm.dict.addWord("OVER", vm.dataStack.over, nt: Nt.OVER);

    /// c-addr is the address of a transient region that can be used to hold data for intermediate processing.
    ///
    /// [PAD][link] ( -- c-addr )
    /// [link]: http://forth-standard.org/standard/core/PAD
    vm.dict.addWord("PAD", () {
      vm.dataStack.push(addrPAD);
    }, nt: Nt.PAD);

    /// Parse ccc delimited by the delimiter char.
    ///
    /// c-addr is the address (within the input buffer) and u
    /// is the length of the parsed string. If the parse area
    /// was empty, the resulting string has a zero length.
    ///
    /// [PARSE][link] ( char "ccc<char>" -- c-addr u )
    /// [link]: http://forth-standard.org/standard/core/PARSE
    vm.dict.addWord("PARSE", () {
      // TODO
    }, nt: Nt.PARSE);

    /// Skip leading space delimiters. Parse name delimited by a space.
    ///
    /// c-addr is the address of the selected string within
    /// the input buffer and u is its length in characters.
    /// If the parse area is empty or contains only white space,
    /// the resulting string has length zero.
    ///
    /// [PARSE-NAME][link] ( "<spaces>name<space>" -- c-addr u )
    /// [link]: http://forth-standard.org/standard/core/PARSE-NAME
    vm.dict.addWord("PARSE-NAME", () {

      // Put in the data stack the current position in the input buffer.
      int pointer = vm.dataSpace.fetchCell(addrToIN);
      vm.dataStack.push(addrInputBuffer + pointer);
      vm.dataStack.push(vm.input.sourceLength - pointer);

      // Skip the leading delimiter characters (space).
      vm.dict.execNts([Nt.BL, Nt.SKIP]);

      int startWord = vm.dataStack.peekNOS;

      // Get the string until the next delimiter.
      vm.dict.execNts([Nt.BL, Nt.SCAN]);

      int endWord = vm.dataStack.peekNOS;

      vm.dict.execNt(Nt.TwoDROP);

      // Put in the data stack the string of the name found.
      vm.dataStack.push(startWord);
      vm.dataStack.push(endWord - startWord);

      // Update >IN
      vm.dataSpace.storeCell(addrToIN, endWord - addrInputBuffer);

    }, nt: Nt.PARSE_NAME);

    /// Remove u. Copy the xu to the top of the stack.
    ///
    /// [PICK][link] ( xu...x1 x0 u -- xu...x1 x0 xu )
    /// [link]: http://forth-standard.org/standard/core/PICK
    vm.dict.addWord("PICK", () {
      vm.dataStack.pick(vm.dataStack.pop);
    }, nt: Nt.PICK);

    /// Remove u. Rotate u+1 items on the top of the stack.
    ///
    /// [ROLL][link] ( xu xu-1 ... x0 u -- xu-1 ... x0 xu )
    /// [link]: http://forth-standard.org/standard/core/ROLL
    vm.dict.addWord("ROLL", () {
      vm.dataStack.roll(vm.dataStack.pop);
      // CHECK: An ambiguous condition exists if there are less
      // than u+2 items on the stack before ROLL is executed.
    }, nt: Nt.ROLL);

    /// Interprets Forth source code received interactively from a user input device.
    ///
    /// [QUIT][link] ( -- ) ( R: i * x -- )
    /// [link]: http://forth-standard.org/standard/core/QUIT
    vm.dict.addWord("QUIT", () async {

      // Empty the return stack.
      vm.returnStack.clear();

      // Store 0 in SOURCE-ID .
      vm.input.sourceId = 0;

      // Enter interpretation state.
      vm.interpretationState = true;

      while(true) {

        // Accept a line from the input source into the input buffer.
        await vm.dict.execNt(Nt.REFILL);

        // If REFILL failed, break the loop (Normally it shouldn't happen).
        if (vm.dataStack.pop == flagFALSE) break;

        try {
          // Interpret.
          vm.dict.execNt(Nt.INTERPRET);

        } on ForthError catch(error) {
          print(error);

          // Clear the stacks.
          vm.dataStack.clear();
          vm.floatStack.clear();
          vm.returnStack.clear();
          vm.controlStack.clear();

        } catch(error) {
          print(ForthError.unmanaged(error, preMsg: "QUIT » INTERPRET »"));

          // Clear the stacks.
          vm.dataStack.clear();
          vm.floatStack.clear();
          vm.returnStack.clear();
          vm.controlStack.clear();
        }

        // Display the implementation-defined system prompt.
        //
        // If:
        //  - in interpretation state.
        //  - all processing has been completed.
        //  - and no ambiguous condition exists.
        if (vm.interpretationState) {
          print("  ok"); // TODO
        }
      }
    }, nt: Nt.QUIT);

    /// Moves data FROM the return stack to the data stack.
    ///
    /// [R>][link] ( -- x  ( R: x -- )
    /// [link]: http://forth-standard.org/standard/core/Rfrom
    vm.dict.addWord("R>", () {
      vm.dataStack.push(vm.returnStack.pop);
    }, nt: Nt.Rfrom, immediate: true);

    /// Copy x from the return stack to the data stack.
    ///
    /// [R@][link] ( -- x ) ( R: x -- x )
    /// [link]: http://forth-standard.org/standard/core/RFetch
    vm.dict.addWord("R@", () {
      vm.dataStack.push(vm.returnStack.peek);
    }, nt: Nt.RFetch, immediate: true);

    /// Attempt to fill the input buffer from the input source, returning a true flag if successful.
    ///
    /// [REFILL][link] ( -- flag )
    /// [link]: http://forth-standard.org/standard/core/REFILL
    vm.dict.addWord("REFILL", () async {

      // The input source comes from the terminal
      if (vm.input.fromTerm()) {

        String input;

        // Attempts to receive input into the terminal input buffer.
        try {
          input = await vm.input.readLineFromTerminal();
        }
        // If there is no input available returns false.
        catch(e) {

          // NOTE: This shouldn't fail, but, e.g. in case,
          // the input source is coming from a remote system
          // REFILL could return a false value if a channel
          // closes and the system can't receive more input.

          vm.dataStack.push(flagFALSE);

          print(ForthError.unmanaged(e));
          return;
        }

        // Converts the string to UTF8.
        List<int> inputUTF8 = UTF8.encode(input);

        // Checks the size fits in the buffer.
        if (inputUTF8.length > inputBufferSize) {
          throw new ForthError(-256);

          // TODO: Review this course of action.
        }

        // Copies the terminal input to the input buffer.
        vm.dataSpace.setCharRange(addrInputBuffer, inputUTF8);

        // Sets the length of the input source.
        vm.input.sourceLength = inputUTF8.length;

        // Sets >IN to zero.
        vm.dataSpace.storeCell(addrToIN, 0);

        // Returns true.
        vm.dataStack.push(flagTRUE);

      } else {

        // TODO: fill from --evaluate
        // When the input source is a string from EVALUATE,
        // return false and perform no other action.

        // TODO: fill from --include
        // When the input source is a text file, attempt to read
        // the next line from the text-input file. If successful,
        // make the result the current input buffer, set >IN to
        // zero, and return true. Otherwise return false.
      }

      //vm.dataStack.push(flagTRUE);

      // When the input source is a string from EVALUATE, return false and perform no other action.
      //vm.dataStack.push(flagFALSE);

    }, nt: Nt.REFILL, immediate: true);

    /// Attempt to restore the input source specification to the state described by x1 through xn.
    ///
    /// flag is true if the input source specification cannot be so restored.
    ///
    /// [RESTORE-INPUT][link] ( xn ... x1 n -- flag )
    /// [link]: http://forth-standard.org/standard/core/RESTORE-INPUT
    vm.dict.addWord("RESTORE_INPUT", (){
      // CHECK: An ambiguous condition exists if the input source represented
      // by the arguments is not the same as the current input source.
    }, nt: Nt.RESTORE_INPUT);

    /// Rotate the top three stack entries.
    ///
    /// [ROT][link] ( x1 x2 x3 -- x2 x3 x1 )
    /// [link]: http://forth-standard.org/standard/core/ROT
    vm.dict.addWord("ROT", vm.dataStack.rot, nt: Nt.ROT);

    /// Perform a logical right shift of u bit-places on x1, giving x2.
    ///
    /// [RSHIFT][link] ( x1 u -- x2 )
    /// [link]: http://forth-standard.org/standard/core/RSHIFT
    vm.dict.addWord("RSHIFT", (){
      vm.dataStack.swap();
      vm.dataStack.push(vm.dataStack.pop >> vm.dataStack.pop);
      // CHECK: An ambiguous condition exists if u is greater than
      // or equal to the number of bits in a cell.
    }, nt: Nt.RSHIFT);

    /// x1 through xn describe the current state of the input source specification for later use by RESTORE-INPUT.
    ///
    /// [SAVE-INPUT][link] ( -- xn ... x1 n )
    /// [link]: http://forth-standard.org/standard/core/SAVE-INPUT
    vm.dict.addWord("SAVE_INPUT", () {

    }, nt: Nt.SAVE_INPUT);

    /// c-addr is the address of, and u is the number of characters in, the input buffer.
    ///
    /// [SOURCE][link] ( -- c-addr u )
    /// [link]: http://forth-standard.org/standard/core/SOURCE
    vm.dict.addWord("SOURCE", () {
      vm.dataStack.push(addrInputBuffer);
      vm.dataStack.push(vm.input.sourceLength);
    }, nt: Nt.SOURCE);

    /// Identifies the input source as follows:
    ///
    /// fileid   Text file "fileid"
    ///     -1   String (via EVALUATE)
    ///      0   User input device
    ///
    /// [SOURCE-ID][link] ( -- 0 | -1 )
    /// [link]: http://forth-standard.org/standard/core/SOURCE-ID
    vm.dict.addWord("SOURCE-ID", (){
      vm.dataStack.push(vm.input.sourceId);
    }, nt: Nt.SOURCE_ID);

    /// Display one space.
    ///
    /// [SPACE][link] ( -- )
    /// [link]: http://forth-standard.org/standard/core/SPACE
    vm.dict.addWordNope("SPACE", nt: Nt.SPACE);

    /// If n is greater than zero, display n spaces.
    ///
    /// [SPACES][link] ( u -- )
    /// [link]: http://forth-standard.org/standard/core/SPACES
    vm.dict.addWordNope("SPACES", nt: Nt.SPACES);

    /// a-addr is the address of a cell containing the compilation-state flag.
    ///
    /// [STATE][link] ( -- a-addr )
    /// [link]: http://forth-standard.org/standard/core/STATE
    vm.dict.addWord("STATE", (){
      vm.dataStack.push(addrSTATE);
    }, nt: Nt.STATE);

    /// Exchange the top two stack items.
    ///
    /// [SWAP][link] ( x1 x2 -- x2 x1 )
    /// [link]: http://forth-standard.org/standard/core/SWAP
    vm.dict.addWord("SWAP", vm.dataStack.swap, nt: Nt.SWAP);

    /// Return a true flag.
    ///
    /// [TRUE][link] ( -- true )
    /// [link]: http://forth-standard.org/standard/core/TRUE
    vm.dict.addWord("TRUE", (){
      vm.dataStack.push(flagTRUE);
    }, nt: Nt.TRUE);

    /// Copy the first (top) stack item below the second stack item.
    ///
    /// [TUCK][link] ( x1 x2 -- x2 x1 x2 )
    /// [link]: http://forth-standard.org/standard/core/TUCK
    vm.dict.addWord("TUCK", vm.dataStack.tuck, nt: Nt.TUCK);

    /// x3 is the bit-by-bit exclusive-or of x1 with x2.
    ///
    /// [XOR][link] ( x1 x2 -- x3 )
    /// [link]: http://forth-standard.org/standard/core/XOR
    vm.dict.addWord("XOR", (){
      vm.dataStack.push(vm.dataStack.pop ^ vm.dataStack.pop);
    }, nt: Nt.XOR);

    /// Display u in free field format.
    ///
    /// [U.][link] ( u -- )
    /// [link]: http://forth-standard.org/standard/core/Ud
    vm.dict.addWord("U.", (){
      print(vm.dataStack.pop.toUnsigned(32));
    }, nt: Nt.Ud);

    /// flag is true if and only if u1 is less than u2.
    ///
    /// [U<][link] ( u -- flag )
    /// [link]: http://forth-standard.org/standard/core/Uless
    vm.dict.addWord("U<", (){
      if (vm.dataStack.pop.toUnsigned(32) > vm.dataStack.pop.toUnsigned(32)) {
        vm.dataStack.push(flagTRUE);
      } else {
        vm.dataStack.push(flagFALSE);
      }
    }, nt: Nt.Uless);

    /// flag is true if and only if u1 is greater than u2.
    ///
    /// [U>][link] ( u -- flag )
    /// [link]: http://forth-standard.org/standard/core/Umore
    vm.dict.addWord("U>", (){
      if (vm.dataStack.pop.toUnsigned(32) < vm.dataStack.pop.toUnsigned(32)) {
        vm.dataStack.push(flagTRUE);
      } else {
        vm.dataStack.push(flagFALSE);
      }
    }, nt: Nt.Umore);

  } // standardCore


  /// Core words that are not part of the standard.
  ///
  nonStandardCore() {

    // Implemented:
    //
    // BOOTMESSAGE INTERPRET SCAN SKIP
    //
    // Not Implemented:
    //
    // COLD

    /// Displays the boot message.
    ///
    /// BOOTMESSAGE ( -- )
    vm.dict.addWord("BOOTMESSAGE", () {
      print("Type `bye' to exit");
    }, nt: Nt.BOOTMESSAGE);

    /// Embodies the text interpreter semantics.
    vm.dict.addWord("INTERPRET", () {

      while (true) {

        // Read the next word.
        vm.dict.execNt(Nt.PARSE_NAME);

        vm.dataStack.swap();
        String wordStr = vm.dataSpace.fetchString(vm.dataStack.pop, vm.dataStack.pop);

        if (wordStr.isEmpty) {
          break;
        }

        /// Search for this word in the current dictionary.
        Word word = vm.dict.wordByName(wordStr);

        /// If the word is found.
        if( word != null) {

          /// If this word is compile only and we are in interpretation state, throw err -14.
          if (word.isCompileOnly && vm.interpretationState) {

            throw new ForthError(-14);

          /// If this word != [isImmediate] and we are in compile state, compile it.
          } else if (!word.isImmediate && vm.compilationState) {
            //print("TODO: compile: $wordStr"); // TEMP
            // ...

          /// Executes the word In any other case.
          } else {
            //print("execute: $wordStr"); // TEMP
            word.exec();
          }


        /// If the word could not be found then
        /// tries converting the word to a number.
        } else {

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

          // print("\nWORD $wordStr; BASE $base; PREFIX $prefix; DOUBLE: $isDouble; FLOAT: ${!isInt}"); // TEMP

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
              throw new ForthError(-13, postMsg: wordStr);
            } else {
              isInt = false;
            }
          }

          /// If we are compiling, compile the number in the data space.
          if (vm.compilationState) {
            // TODO
            print("\t» compile the number"); // TEMP

          /// If we are interpreting leave it on the stack.
          } else {

            // Integers go to the dataStack.
            if (isInt) {
              // print("\t» number to the dataStack"); // TEMP
              vm.dataStack.push(number.toInt());

              if (isDouble) {
                // print("\t» is double number"); // TEMP
                vm.dataStack.push(0); // FIXME (this is a temporary workaround for small ints)
              }

            // Floats go to the floatStack.
            } else {
              // print("\t» number to the floatStack"); // TEMP
              vm.floatStack.push(number);
            }

          }

        }
      }

      // Loop ends when there are no more words.

    }, nt: Nt.INTERPRET);

    /// Scan the string c-addr1 u1 for the first occurence of char.
    ///
    /// Leave match address c-addr2 and length remaining u2. If no
    /// match occurred then u2 is zero and c-addr2 is c-addr1 + u1.
    ///
    /// ( c-addr1 u1 char -- c-addr2 u2 )
    vm.dict.addWord("SCAN", (){
      int char    = vm.dataStack.pop;
      int length  = vm.dataStack.pop;
      int address = vm.dataStack.pop;

      List<int> codePoints = vm.dataSpace.fetchString(address, length).runes.toList();

      int index = codePoints.indexOf(char);

      if (index >= 0) {
        int indexUTF8 = util.UTF8CodeUnitsPerCodePointsList(codePoints.sublist(0, index));
        vm.dataStack.push(address + indexUTF8);
        vm.dataStack.push(length - indexUTF8);
      } else {
        vm.dataStack.push(address + length);
        vm.dataStack.push(0);
      }
    }, nt: Nt.SCAN);

    /// Skip over leading occurences of char in the string c-addr1 u1.
    ///
    /// Leave the address of the first non-matching character char2
    /// and length remaining u2. If no characters were skipped,
    /// leave the original string c-addr1 u1.
    ///
    /// ( c-addr1 u1 char -- c-addr2 u2 | c-addr1 u1 )
    vm.dict.addWord("SKIP", (){
      int char    = vm.dataStack.pop;
      int length  = vm.dataStack.pop;
      int address = vm.dataStack.pop;

      List codePoints = vm.dataSpace.fetchString(address, length).runes.toList();
      int skippedBytes = 0;

      for (int i = 0; i < codePoints.length; i++) {
        if (codePoints[i] != char) {
          vm.dataStack.push(address + skippedBytes);
          vm.dataStack.push(length - skippedBytes);
          return;
        }
        skippedBytes += util.UTF8CodeUnitsPerCodePoint(codePoints[i]);
      }
      vm.dataStack.push(address);
      vm.dataStack.push(length);
    }, nt: Nt.SKIP);

  } // nonstandardCore

  /// Useful words that are not part of the standard.
  ///
  /// [Gforth Word Index][http://www.complang.tuwien.ac.at/forth/gforth/Docs-html/Word-Index.html#Word-Index]
  nonStandardExtra() {

    // Implemented:
    //
    // -ROT .FS .RS BIN. ODUMP WORDS+NT
    //
    // Not Implemented:
    //
    // >NAME NAME>STRING FNIP FPICK FTUCK

    ///
    vm.dict.addWord("-ROT", vm.dataStack.rotCC);

    /// Tries to find the name token nt of the word represented by xt.
    ///
    /// Returns 0 if it fails.
    /// Note that in the current implementation xt and nt are exactly the same.
    /// [toName][link] ( xt -- nt|0 )
    /// [link]: http://www.complang.tuwien.ac.at/forth/gforth/Docs-html/Name-token.html
    //vm.dict.addWord(">NAME", () {}); // TODO

    /// Tries to find the name of the [Word] represented by nt.
    ///
    /// Note that in the current implementation xt and nt are exactly the same.
    /// [nameToString][link] ( nt -- addr count )
    /// [link]: http://www.complang.tuwien.ac.at/forth/gforth/Docs-html/Name-token.html
    //vm.dict.addWord("NAME>STRING", () {}); // TODO

      /// Prints the values currently on the floating point stack.
    vm.dict.addWord(".FS", () {
      print("floatStack: ${vm.floatStack}");
    }, nt: Nt.DotFS);

    /// Prints the values currently on the return point stack.
    vm.dict.addWord(".RS", () {
      print("returnStack: ${vm.returnStack}");
    }, nt: Nt.DotRS);

    /// Display the string stored at ( c-addr u -- )
    vm.dict.addWord("?STRING", (){
      vm.dataStack.swap();
      print(vm.dataSpace.fetchString(vm.dataStack.pop, vm.dataStack.pop));
    }, nt: Nt.qSTRING);

    /// Display an integer binary format.
    vm.dict.addWord("BIN.", () {
      print(util.int32ToBin(vm.dataStack.pop));
    });

    /// Prints the object space content.
    vm.dict.addWordNope("ODUMP"); // TODO

    // Words from gforth

    // Examining
    // https://www.complang.tuwien.ac.at/forth/gforth/Docs-html/Examining.html

    // Floating-Point
    // https://www.complang.tuwien.ac.at/forth/gforth/Docs-html/Floating-Point-Tutorial.html
    // fnip ftuck fpick
    // f~abs f~rel

  } // nonstandardExtra

  /// The optional Block word set.
  ///
  /// http://forth-standard.org/standard/block
  standardOptionalBlock() {

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

  } // standardOptionalBlock

  /// The optional Double-Number word set
  ///
  /// http://forth-standard.org/standard/double
  standardOptionalDouble() {

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

  } // standardOptionalDouble

  /// The optional Exception word set.
  ///
  /// http://forth-standard.org/standard/exception
  standardOptionalException() {

    // Total:  ()
    //
    // Implemented:
    //
    //
    //
    // Not implemented:
    //
    //
    //
    //

  } // standardOptionalException

  /// The optional Facility word set.
  ///
  /// https://forth-standard.org/standard/facility
  standardOptionalFacility() {

    // Total: 23 (3 main + 3 extended)
    //
    // Implemented:
    //
    // TIME&DATE
    //
    // Not Implemented:
    //
    // AT-XY KEY? PAGE
    //
    // +FIELD BEGIN-STRUCTURE CFIELD: EKEY EKEY>CHAR EKEY>FKEY EKEY? EMIT? END-STRUCTURE FIELD: K-ALT-MASK K-CTRL-MASK K-DELETE K-DOWN K-END K-F1 K-F10 K-F11 K-F12 K-F2 K-F3 K-F4 K-F5 K-F6 K-F7 K-F8 K-F9 K-HOME K-INSERT K-LEFT K-NEXT K-PRIOR K-RIGHT K-SHIFT-MASK K-UP MS

    /// Return the current time and date.
    ///
    /// +n1 is the second {0...59}, +n2 is the minute {0...59}, +n3 is the hour {0...23},
    /// +n4 is the day {1...31}, +n5 is the month {1...12} and +n6 is the year (e.g., 1991).
    ///
    /// [TIME&DATE][link] ( -- +n1 +n2 +n3 +n4 +n5 +n6 )
    /// [link]: http://forth-standard.org/standard/float/TIMEandDATE
    vm.dict.addWord("TIME&DATE", (){
      DateTime d = new DateTime.now();
      vm.dataStack.pushList([d.second, d.minute, d.hour, d.day, d.month, d.year]);
    }, nt: Nt.TIMEandDATE);

  } // standardOptionalFacility

  /// The optional File word set.
  ///
  /// http://forth-standard.org/standard/file
  standardOptionalFile() {

    // Total:  ()
    //
    // Implemented:
    //
    //
    //
    // Not implemented:
    //
    //
    //
    //

  } // standardOptionalFile

  /// The optional Floating-Point word set
  ///
  /// http://forth-standard.org/standard/float
  standardOptionalFloat() {

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
    vm.dict.addWord("D>F", (){
      vm.floatStack.push(vm.dataStack.pop.toDouble());
    }, nt: Nt.DtoF);

    /// If the data-space pointer is not double-float aligned, reserve enough data space to make it so.
    ///
    /// This word does nothing in this implementation.
    ///
    /// [DFALIGN][link] ( -- )
    /// [link]: http://forth-standard.org/standard/float/DFALIGN
    vm.dict.addWordNope("DFALIGN", nt: Nt.DFALIGN);

    /// df-addr is the first double-float-aligned address greater than or equal to addr.
    ///
    /// This word does nothing in this implementation.
    ///
    /// [DFALIGNED][link] ( addr -- df-addr )
    /// [link]: http://forth-standard.org/standard/float/DFALIGNED
    vm.dict.addWordNope("DFALIGNED", nt: Nt.DFALIGNED);

    /// Store r at f-addr.
    ///
    /// [F!][link] ( f-addr -- ) ( F: r -- )
    /// [link]: http://forth-standard.org/standard/float/FStore
    //
    // Stores a floating point number using eight bytes at the specified address.
    //
    // https://api.dartlang.org/stable/dart-typed_data/ByteData/setFloat64.html
    // https://en.wikipedia.org/wiki/Double-precision_floating-point_format
    vm.dict.addWord("F!", (){
      vm.dataSpace.storeFloat(vm.dataStack.pop, vm.floatStack.pop);
    }, nt: Nt.FStore);

    /// r is the value stored at f-addr.
    ///
    /// [F@][link] ( f-addr -- ) ( F: -- r )
    /// [link]: http://forth-standard.org/standard/float/FFetch
    //
    // Fetches a floating point number using eight bytes at the specified address.
    vm.dict.addWord("F@", (){
      vm.floatStack.push(vm.dataSpace.fetchFloat(vm.dataStack.pop));
    }, nt: Nt.FFetch);

    /// Multiply r1 by r2 giving r3.
    ///
    /// [F*][link] ( F: r1 r2 -- r3 )
    /// [link]: http://forth-standard.org/standard/float/FTimes
    vm.dict.addWord("F*", (){
      vm.floatStack.push(vm.floatStack.pop * vm.floatStack.pop);
    }, nt: Nt.FTimes);

    /// Add r1 to r2 giving the sum r3.
    ///
    /// [F+][link] ( F: r1 r2 -- r3 )
    /// [link]: http://forth-standard.org/standard/float/FPlus
    vm.dict.addWord("F+", (){
      vm.floatStack.push(vm.floatStack.pop + vm.floatStack.pop);
    }, nt: Nt.FPlus);

    /// Subtract r2 from r1, giving r3.
    ///
    /// [F-][link] ( F: r1 r2 -- r3 )
    /// [link]: http://forth-standard.org/standard/float/FMinus
    vm.dict.addWord("F-", (){
      vm.floatStack.swap();
      vm.floatStack.push(vm.floatStack.pop - vm.floatStack.pop);
    }, nt: Nt.FMinus);

    /// Divide r1 by r2, giving the quotient r3.
    ///
    /// [F/][link] ( F: r1 r2 -- r3 )
    /// [link]: http://forth-standard.org/standard/float/FDiv
    vm.dict.addWord("F/", (){
      vm.floatStack.swap();
      vm.floatStack.push(vm.floatStack.pop / vm.floatStack.pop);
    }, nt: Nt.FDiv);

    /// Raise r1 to the power r2, giving the product r3.
    ///
    /// [F**][link]
    /// [link]: http://forth-standard.org/standard/float/FTimesTimes
    vm.dict.addWord("F**", (){
      vm.floatStack.swap();
      vm.floatStack.push(pow(vm.floatStack.pop, vm.floatStack.pop));
    }, nt: Nt.FTimesTimes);

    /// Display, with a trailing space, the top number on the floating-point stack using fixed-point notation.
    ///
    /// [F.][link] ( -- ) ( F: r -- )
    /// [link]: http://forth-standard.org/standard/float/Fd
    vm.dict.addWord("F.", (){
      print(vm.floatStack.pop);
      // CHECK: An ambiguous condition exists if the value of BASE is not (decimal) ten or if the
      // character string representation exceeds the size of the pictured numeric output string buffer.
    }, nt: Nt.Fd);

    /// d is the double-cell signed-integer equivalent of the integer portion of r.
    ///
    /// [F>D][link] ( -- d ) ( F: r -- )
    /// [link]: http://forth-standard.org/standard/float/FtoD
    vm.dict.addWord("F>D", (){
      vm.dataStack.push(vm.floatStack.pop.toInt()); // FIXME TODO make it double
    }, nt: Nt.FtoD);

    /// d is the single-cell signed-integer equivalent of the integer portion of r.
    ///
    /// [F>S][link] ( -- d ) ( F: r -- )
    /// [link]: http://forth-standard.org/standard/float/FtoS
    vm.dict.addWord("F>S", (){
      vm.dataStack.push(vm.floatStack.pop.toInt());
    }, nt: Nt.FtoS);

    /// r2 is the absolute value of r1.
    ///
    /// [FABS][link] ( F: r1 -- r2 )
    /// [link]: http://forth-standard.org/standard/float/FABS
    vm.dict.addWord("FABS", (){
      vm.floatStack.push(vm.floatStack.pop.abs());
    }, nt: Nt.FABS);

    /// r2 is the principal radian angle whose cosine is r1.
    ///
    /// [FACOS][link] ( F: r1 -- r2 )
    /// [link]: http://forth-standard.org/standard/float/FACOS
    vm.dict.addWord("FACOS", (){
      vm.floatStack.push(acos(vm.floatStack.pop));
      // CHECK: An ambiguous condition exists if | r1 | is greater than one.
    }, nt: Nt.FACOS);

    /// r2 is the floating-point value whose hyperbolic cosine is r1.
    ///
    /// [FACOSH][link] ( F: r1 -- r2 )
    /// [link]: http://forth-standard.org/standard/float/FACOSH
    vm.dict.addWord("FACOSH", (){
      double x = vm.floatStack.pop;
      vm.floatStack.push(log(x + sqrt(x * x - 1)));
    }, nt: Nt.FACOSH);

    /// If the data-space pointer is not float aligned, reserve enough data space to make it so.
    ///
    /// This word does nothing in this implementation.
    ///
    /// [FALIGN][link] ( -- )
    /// [link]: http://forth-standard.org/standard/core/FALIGN
    vm.dict.addWordNope("FALIGN", nt: Nt.FALIGN);

    /// f-addr is the first float-aligned address greater than or equal to addr.
    ///
    /// This word does nothing in this implementation.
    ///
    /// [FALIGNED][link] ( addr -- f-addr )
    /// [link]: http://forth-standard.org/standard/core/FALIGNED
    vm.dict.addWordNope("FALIGNED", nt: Nt.FALIGNED);

    /// Raise ten to the power r1, giving r2.
    ///
    /// [FALOG][link] ( F: r1 -- r2 )
    /// [link]: http://forth-standard.org/standard/float/FALOG
    vm.dict.addWord("FALOG", (){
      vm.floatStack.push(pow(10, vm.floatStack.pop));
    }, nt: Nt.FALOG);

    /// r2 is the principal radian angle whose sine is r1.
    ///
    /// [FASIN][link] ( F: r1 -- r2 )
    /// [link]: http://forth-standard.org/standard/float/FASIN
    vm.dict.addWord("FASIN", (){
      vm.floatStack.push(asin(vm.floatStack.pop));
      // CHECK: An ambiguous condition exists if | r1 | is greater than one.
    }, nt: Nt.FASIN);

    /// r2 is the floating-point value whose hyperbolic sine is r1.
    ///
    /// [FASINH][link] ( F: r1 -- r2 )
    /// [link]: http://forth-standard.org/standard/float/FASINH
    vm.dict.addWord("FASINH", (){
      double x = vm.floatStack.pop;
      vm.floatStack.push(log(x + sqrt(x * x + 1)));
    }, nt: Nt.FASINH);

    /// r2 is the principal radian angle whose tangent is r1.
    ///
    /// [FATAN][link] ( F: r1 -- r2 )
    /// [link]: http://forth-standard.org/standard/float/FATAN
    vm.dict.addWord("FATAN", (){
      vm.floatStack.push(atan(vm.floatStack.pop));
      // CHECK: An ambiguous condition exists if r1 is less than or equal to zero.
    }, nt: Nt.FATAN);

    /// r3 is the principal radian angle (between -π and π) whose tangent is r1/r2.
    ///
    /// [FATAN2][link] ( F: r1 r2 -- r3 )
    /// [link]: http://forth-standard.org/standard/float/FATANTwo
    vm.dict.addWord("FATAN2", (){
      vm.floatStack.swap();
      vm.floatStack.push(atan2(vm.floatStack.pop, vm.floatStack.pop));
      // CHECK: An ambiguous condition exists r1 and r2 are zero.
    }, nt: Nt.FATANTwo);

    /// r2 is the floating-point value whose hyperbolic tangent is r1.
    ///
    /// [FATANH][link] ( F: r1 -- r2 )
    /// [link]: http://forth-standard.org/standard/float/FATANH
    vm.dict.addWord("FATANH", (){
      double x = vm.floatStack.pop;
      vm.floatStack.push(log((1+x)/(1-x)) / 2);
      // CHECK: An ambiguous condition exists if r1 is outside the range of -1E0 to 1E0.
    }, nt: Nt.FATANH);

    /// r2 is the cosine of the radian angle r1.
    ///
    /// [FCOS][link] ( F: r1 -- r2 )
    /// [link]: http://forth-standard.org/standard/float/FCOS
    vm.dict.addWord("FCOS", (){
      vm.floatStack.push(cos(vm.floatStack.pop));
    }, nt: Nt.FCOS);

    /// r2 is the hyperbolic cosine of r1.
    ///
    /// [FCOSH][link] ( F: r1 -- r2 )
    /// [link]: http://forth-standard.org/standard/float/FCOSH
    vm.dict.addWord("FCOSH", (){
      double x = vm.floatStack.pop;
      vm.floatStack.push((exp(2*x) + 1) / (2 * exp(x)));
    }, nt: Nt.FCOSH);

    /// +n is the number of values contained on the floating-point stack.
    ///
    /// [FDEPTH][link] ( -- +n )
    /// [link]: http://forth-standard.org/standard/float/FDEPTH
    vm.dict.addWord("FDEPTH", (){
      vm.dataStack.push(vm.floatStack.size);
    }, nt: Nt.FDEPTH);

    /// Remove r from the floating-point stack.
    ///
    /// [FDROP][link] ( F: r -- )
    /// [link]: http://forth-standard.org/standard/float/FDROP
    vm.dict.addWord("FDROP", vm.floatStack.drop, nt: Nt.FDROP);

    /// Duplicate r.
    ///
    /// [FDUP][link] ( F: r -- r r )
    /// [link]: http://forth-standard.org/standard/float/FDUP
    vm.dict.addWord("FDUP", vm.floatStack.dup, nt: Nt.FDUP);

    /// Raise e to the power r1, giving r2.
    ///
    /// [FEXP][link] ( F: r1 -- r2 )
    /// [link]: http://forth-standard.org/standard/float/FEXP
    vm.dict.addWord("FEXP", (){
      vm.floatStack.push(exp(vm.floatStack.pop));
    }, nt: Nt.FEXP);

    /// Raise e to the power r1 and subtract one, giving r2.
    ///
    /// [FEXPM1][link] ( F: r1 -- r2 )
    /// [link]: http://forth-standard.org/standard/float/FEXPMOne
    vm.dict.addWord("FEXPM1", (){
      vm.floatStack.push(exp(vm.floatStack.pop) - 1);
    }, nt: Nt.FEXPMOne);

    /// r2 is the base-ten logarithm of r1.
    ///
    /// [FLOG][link] ( F: r1 -- r2 )
    /// [link]: http://forth-standard.org/standard/float/FLOG
    vm.dict.addWord("FLOG", (){
      vm.floatStack.push(log(vm.floatStack.pop) / LN10);
      // CHECK: An ambiguous condition exists if r1 is less than or equal to zero.
    }, nt: Nt.FLOG);

    /// Round r1 to an integral value using the "round toward negative infinity" rule, giving r2.
    ///
    /// [FLOOR][link] ( F: r1 -- r2 )
    /// [link]: http://forth-standard.org/standard/float/FLOOR
    vm.dict.addWord("FLOOR", (){
      vm.floatStack.push(vm.floatStack.pop.floorToDouble());
    }, nt: Nt.FLOOR);

    /// r2 is the natural logarithm of r1.
    ///
    /// [FLN][link] ( F: r1 -- r2 )
    /// [link]: http://forth-standard.org/standard/float/FLN
    vm.dict.addWord("FLN", (){
      vm.floatStack.push(log(vm.floatStack.pop));
      // CHECK: An ambiguous condition exists if r1 is less than or equal to zero.
    }, nt: Nt.FLN);

    /// r2 is the natural logarithm of the quantity r1 plus one.
    ///
    /// [FLN][link] ( F: r1 -- r2 )
    /// [link]: http://forth-standard.org/standard/float/FLNPOne
    vm.dict.addWord("FLNP1", (){
      vm.floatStack.push(log(vm.floatStack.pop + 1));
      // CHECK: An ambiguous condition exists if r1 is less than or equal to negative one.
    }, nt: Nt.FLNPOne);

    /// r3 is the greater of r1 and r2.
    ///
    /// [FMAX][link] ( F: r1 r2 -- r3 )
    /// [link]: http://forth-standard.org/standard/float/FMAX
    vm.dict.addWord("FMAX", (){
      vm.floatStack.push(max(vm.floatStack.pop, vm.floatStack.pop));
    }, nt: Nt.FMAX);

    /// r3 is the lesser of r1 and r2.
    ///
    /// [FMIN][link] ( F: r1 r2 -- r3 )
    /// [link]: http://forth-standard.org/standard/float/FMIN
    vm.dict.addWord("FMIN", (){
      vm.floatStack.push(min(vm.floatStack.pop, vm.floatStack.pop));
    }, nt: Nt.FMIN);

    /// r2 is the negation of r1.
    ///
    /// [FNEGATE][link] ( F: r1 -- r2 )
    /// [link]: http://forth-standard.org/standard/float/FNEGATE
    vm.dict.addWord("FNEGATE", (){
      vm.floatStack.push(-vm.floatStack.pop);
    }, nt: Nt.FNEGATE);

    /// Place a copy of r1 on top of the floating-point stack.
    ///
    /// [FOVER][link] ( F: r1 r2 -- r1 r2 r1 )
    /// [link]: http://forth-standard.org/standard/float/FOVER
    vm.dict.addWord("FOVER", vm.floatStack.over, nt: Nt.FOVER);

    /// Rotate the top three floating-point stack entries.
    ///
    /// [FROT][link] ( F: r1 r2 r3 -- r2 r3 r1 )
    /// [link]: http://forth-standard.org/standard/float/FROT
    vm.dict.addWord("FROT", vm.floatStack.rot, nt: Nt.FROT);

    /// Round r1 to an integral value using the "round to nearest" rule, giving r2.
    ///
    /// [FROUND][link] ( F: r1 -- r2 )
    /// [link]: http://forth-standard.org/standard/float/FROUND
    vm.dict.addWord("FROUND", (){
      vm.floatStack.push(vm.floatStack.pop.roundToDouble());
    }, nt: Nt.FROUND);

    /// r2 is the sine of the radian angle r1.
    ///
    /// [FSIN][link] ( F: r1 -- r2 )
    /// [link]: http://forth-standard.org/standard/float/FSIN
    vm.dict.addWord("FSIN", (){
      vm.floatStack.push(sin(vm.floatStack.pop));
    }, nt: Nt.FSIN);

    /// r2 is the sine of the radian angle r1. r3 is the cosine of the radian angle r1.
    ///
    /// [FSINCOS][link] ( F: r1 -- r2 r3 )
    /// [link]: http://forth-standard.org/standard/float/FSINCOS
    vm.dict.addWord("FSINCOS", (){
      double x = vm.floatStack.pop;
      vm.floatStack.push(sin(x));
      vm.floatStack.push(cos(x));
    }, nt: Nt.FSINCOS);

    /// r2 is the hyperbolic sine of r1.
    ///
    /// [FSINH][link] ( F: r1 -- r2 )
    /// [link]: http://forth-standard.org/standard/float/FSINH
    vm.dict.addWord("FSINH", (){
      double x = vm.floatStack.pop;
      vm.floatStack.push((exp(2*x) - 1) / (2 * exp(x)));
    }, nt: Nt.FSINH);

    /// r2 is the hyperbolic tangent of r1.
    ///
    /// [FTAN][link] ( F: r1 -- r2 )
    /// [link]: http://forth-standard.org/standard/float/FTANH
    vm.dict.addWord("FTANH", (){
      double x = vm.floatStack.pop;
      vm.floatStack.push(
        ((exp(2*x) - 1) / (2 * exp(x))) / ((exp(2*x) + 1) / (2 * exp(x)))
      );
    }, nt: Nt.FTANH);

    /// Exchange the top two floating-point stack items.
    ///
    /// [FSWAP][link] a ( F: x1 x2 -- x2 x1 )
    /// [link]: http://forth-standard.org/standard/float/FSWAP
    vm.dict.addWord("FSWAP", vm.floatStack.swap, nt: Nt.FSWAP);

    /// If the data-space pointer is not single-float aligned, reserve enough data space to make it so.
    ///
    /// This word does nothing in this implementation.
    ///
    /// [SFALIGN][link] ( -- )
    /// [link]: http://forth-standard.org/standard/core/SFALIGN
    vm.dict.addWordNope("SFALIGN", nt: Nt.SFALIGN);

    /// sf-addr is the first single-float-aligned address greater than or equal to addr.
    ///
    /// This word does nothing in this implementation.
    ///
    /// [SFALIGNED][link] ( addr -- sf-addr )
    /// [link]: http://forth-standard.org/standard/core/SFALIGNED
    vm.dict.addWordNope("SFALIGNED", nt: Nt.SFALIGNED);

    /// r2 is the square root of r1.
    ///
    /// [FSQRT][link] ( F: r1 -- r2 )
    /// [link]: http://forth-standard.org/standard/float/FSQRT
    vm.dict.addWord("FSQRT", (){
      vm.floatStack.push(sqrt(vm.floatStack.pop));
      // CHECK: An ambiguous condition exists if r1 is less than zero.
    }, nt: Nt.FSQRT);

    /// r2 is the tangent of the radian angle r1.
    ///
    /// [FTAN][link] ( F: r1 -- r2 )
    /// [link]: http://forth-standard.org/standard/float/FTAN
    vm.dict.addWord("FTAN", (){
      vm.floatStack.push(tan(vm.floatStack.pop));
      // CHECK: An ambiguous condition exists if (r1) is zero.
    }, nt: Nt.FTAN);

    /// Round r1 to an integral value using the "round towards zero" rule, giving r2.
    ///
    /// [FTRUNC][link] ( F: r1 -- r2 )
    /// [link]: http://forth-standard.org/standard/float/TRUNC
    vm.dict.addWord("FTRUNC", (){
      vm.floatStack.push(vm.floatStack.pop.truncateToDouble());
    }, nt: Nt.FTRUNC);

  } // standardOptionalFloat

  /// The optional Locals word set.
  ///
  /// http://forth-standard.org/standard/locals
  standardOptionalLocals() {

    // Total:  ()
    //
    // Implemented:
    //
    //
    //
    // Not implemented:
    //
    //
    //
    //

  } // standardOptionalLocals

  /// The optional Memory word set.
  ///
  /// http://forth-standard.org/standard/memory
  standardOptionalMemory() {

    // Total:  ()
    //
    // Implemented:
    //
    //
    //
    // Not implemented:
    //
    //
    //
    //

  } // standardOptionalMemory

  /// The optional Programming-Tools word set.
  ///
  /// contains words most often used during the development of applications.
  /// http://forth-standard.org/standard/tools
  standardOptionalTools() {

    // Total: 27 (5 main + 22 extended)
    //
    // Implemented:
    //
    //   .S ? DUMP WORDS
    //
    //   BYE NR> N>R STATE
    //
    // Not implemented:
    //
    //   SEE
    //
    //   AHEAD ASSEMBLER [DEFINED] [ELSE] [IF] [THEN] [UNDEFINED] CODE
    //   CS-PICK CS-ROLL EDITOR FORGET NAME>COMPILE NAME>INTERPRET
    //   NAME>STRING SYNONYM ;CODE TRAVERSE-WORDLIST

    /// Copy and display the values currently on the data stack.
    ///
    /// [.S][link] ( -- )
    /// [link]: http://forth-standard.org/standard/tools/DotS
    vm.dict.addWord(".S", (){
      print("dataStack: ${vm.dataStack}");
    }, nt: Nt.DotS);

    /// Display the value stored at a-addr.
    ///
    /// It's re-implemented in CLI.
    ///
    /// [?][link] ( a-addr -- )
    /// [link]: http://forth-standard.org/standard/tools/q
    vm.dict.addWord("?", (){
      print(vm.dataSpace.fetchCell(vm.dataStack.pop).toRadixString(vm.dataSpace.fetchCell(addrBASE)));
    }, nt: Nt.q);

    /// Display the contents of u consecutive addresses starting at addr.
    ///
    /// [DUMP][link] ( addr u -- )
    /// [link]: http://forth-standard.org/standard/tools/DUMP
    vm.dict.addWord("DUMP", (){
      vm.dataStack.over();
      print( util.dumpBytes(vm.dataSpace.getCharRange(vm.dataStack.pop, vm.dataStack.pop), vm.dataStack.pop) );
    }, nt: Nt.DUMP);

    /// Remove n+1 items from the data stack and store them for later retrieval by NR>.
    ///
    /// [N>R][link] ( i * n +n -- ) ( R: -- j * x +n )
    /// [link]: http://forth-standard.org/standard/core/NtoR
    vm.dict.addWord("N>R", () {
      // CHECK: The return stack may be used to store the data.
      // Until this data has been retrieved by NR>:
      //   - this data will not be overwritten by a subsequent invocation of N>R and
      //   - a program may not access data placed on the return stack before the invocation of N>R.
      vm.returnStack.pushList(vm.dataStack.popList(vm.dataStack.peek + 1));
    }, nt: Nt.NtoR, immediate: true);

    /// Retrieve the items previously stored by an invocation of N>R.
    ///
    /// [NR>][link] ( -- i * x +n ) ( R: j * x +n -- )
    /// [link]: http://forth-standard.org/standard/core/NRfrom
    vm.dict.addWord("NR>", () {
      // CHECK: It is an ambiguous condition if NR> is used with data not stored by N>R.
      vm.dataStack.pushList(vm.returnStack.popList(vm.returnStack.peek + 1));
    }, nt: Nt.NRfrom, immediate: true);

    /// Return control to the host operating system, if any.
    ///
    /// It's re-implemented in CLI.
    ///
    /// [BYE][link] ( -- )
    /// [link]: http://forth-standard.org/standard/tools/BYE
    vm.dict.addWordNope("BYE", nt: Nt.BYE);

    /// List the definition names in the first word list of the search order.
    ///
    /// [WORDS][link] ( -- )
    /// [link]: http://forth-standard.org/standard/tools/WORDS
    vm.dict.addWord("WORDS", (){
      var str = new StringBuffer();
      vm.dict.words.forEach((w) { str.write("${w.name} "); });
      print(str);
    }, nt: Nt.WORDS);

  } // standardOptionalTools

  /// The optional Search word set.
  ///
  /// http://forth-standard.org/standard/search
  standardOptionalSearch() {

    // Total:  ()
    //
    // Implemented:
    //
    //
    //
    // Not implemented:
    //
    //
    //
    //

  } // standardOptionalSearch

  /// The optional String word set.
  ///
  /// http://forth-standard.org/standard/string
  standardOptionalString() {

    // Total:  ()
    //
    // Implemented:
    //
    //
    //
    // Not implemented:
    //
    //
    //
    //

  } // standardOptionalString

  /// The optional Extended-Character word set.
  ///
  /// http://forth-standard.org/standard/xchar
  standardOptionalXChar() {

    // Total:  ()
    //
    // Implemented:
    //
    //
    //
    // Not implemented:
    //
    //
    //
    //

  } // standardOptionalXChar
}

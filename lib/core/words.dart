part of forandar;

/// Defines the [Forth standard CORE primitives][link].
///
/// [link]: http://forth-standard.org/standard/core/
void includeWordsStandardCore(VirtualMachine vm, Dictionary d) {

	// Total: 133
	//
	// Implemented:
	//
	// 2DROP 2DUP ?DUP >R DROP DUP IMMEDIATE OVER SWAP ROT
	//
	// Not implemented:
	//
	// ! # #> #S ' ( * */ */MOD + +! +LOOP , - . ." / /MOD 0< 0= 1+ 1- 2! 2* 2/
	// 2@ 2OVER 2SWAP : ; < <# = > >BODY >IN >NUMBER @ ABORT
	// ABORT" ABS ACCEPT ALIGN ALIGNED ALLOT AND BASE BEGIN BL C! C, C@ CELL+
	// CELLS CHAR CHAR+ CHARS CONSTANT COUNT CR CREATE DECIMAL DEPTH DO DOES>
	// ELSE EMIT ENVIRONMENT? EVALUATE EXECUTE EXIT FILL FIND FM/MOD
	// HERE HOLD I IF INVERT J KEY LEAVE LITERAL LOOP LSHIFT M* MAX
	// MIN MOD MOVE NEGATE OR POSTPONE QUIT R> R@ RECURSE REPEAT RSHIFT
	// S" S>D SIGN SM/REM SOURCE SPACE SPACES STATE THEN TYPE U. U< UM*
	// UM/MOD UNLOOP UNTIL VARIABLE WHILE WORD XOR [ ['] [CHAR] ]

	
	// Words that manipulate [dataStack].

	///
	d.addWord(".", false, false, (){}); // TODO

	///
	d.addWord("DUP", false, false, vm.dataStack.Dup);

	/// Duplicate cell pair x1 x2.
	///
	/// : [2DUP][link] ( x1 x2 -- x1 x2 x1 x2 )
	///	  over over ;
	/// [link]: http://forth-standard.org/standard/core/TwoDUP
	d.addWord("2DUP", false, false, vm.dataStack.Dup2);

	///
	d.addWord("?DUP", false, false, () {
		if (vm.dataStack.size > 0) vm.dataStack.Dup();
	});

	/// Remove x from the stack.
	///
	/// [DROP][link] ( x -- )
	/// [link]: http://forth-standard.org/standard/core/DROP
	d.addWord("DROP", false, false, vm.dataStack.Drop);

	/// Drop cell pair x1 x2 from the stack.
	///
	/// [2DROP][link] ( x1 x2 -- )
	/// [link]: http://forth-standard.org/standard/core/TwoDROP
	d.addWord("2DROP", false, false, vm.dataStack.Drop2);

	/// Place a copy of x1 on top of the stack.
	///
	/// [OVER][link] ( x1 x2 -- x1 x2 x1 )
	/// [link]: http://forth-standard.org/standard/core/OVER
	d.addWord("OVER", false, false, vm.dataStack.Over);

	/// Exchange the top two stack items.
	///
	/// [SWAP][link] ( x1 x2 -- x2 x1 )
	/// [link]: http://forth-standard.org/standard/core/SWAP
	d.addWord("SWAP", false, false, vm.dataStack.Swap);

	/// Rotate the top three stack entries.
	///
	/// [ROT][link] ( x1 x2 x3 -- x2 x3 x1 )
	/// [link]: http://forth-standard.org/standard/core/ROT
	d.addWord("ROT", false, false, vm.dataStack.Rot);

	/// Moves data FROM [dataStack] TO [returnStack].
	///
	/// [toR][link] ( x -- ) ( R: -- x )
	/// [link]: http://forth-standard.org/standard/core/toR
	d.addWord(">R", false, false, () {
		vm.returnStack.Push(vm.dataStack.Pop());
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

/// Defines the [Forth standard CORE EXTENDED primitives][link].
///
/// [link]: http://forth-standard.org/standard/core/
void includeWordsStandardCoreExtended(VirtualMachine vm, Dictionary d) {

	// Total: 49
	//
	// Implemented:
	//
	// NIP PICK TUCK
	//
	// Not implemented:
	//
	// .( .R 0<> 0> 2>R 2R> 2R@ :NONAME <> ?DO ACTION-OF AGAIN BUFFER: C"
	// CASE COMPILE, DEFER DEFER! DEFER@ ENDCASE ENDOF ERASE FALSE HEX HOLDS
	// IS MARKER OF PAD PARSE PARSE-NAME REFILL RESTORE-INPUT ROLL
	// S\" SAVE-INPUT SOURCE-ID TO TRUE U.R U> UNUSED VALUE WITHIN
	// [COMPILE] \

	/// Drop the first item below the top of stack.
	///
	/// ( x1 x2 -- x2 )
	d.addWord("NIP", false, false, vm.dataStack.Nip);

	/// Remove u. Copy the xu to the top of the stack.
	///
	/// [PICK][link] ( xu...x1 x0 u -- xu...x1 x0 xu )
	/// [link]: http://forth-standard.org/standard/core/PICK
	d.addWord("PICK", false, false, () {
		vm.dataStack.Pick(vm.dataStack.Pop());
	});

	/// Copy the first (top) stack item below the second stack item.
	///
	/// [TUCK][link] ( x1 x2 -- x2 x1 x2 )
	/// [link]: http://forth-standard.org/standard/core/TUCK
	d.addWord("TUCK", false, false, vm.dataStack.Tuck);
}

/// Core words that are not part of the standard.
///   
void includeWordsNotStandardCore(VirtualMachine vm, Dictionary d) {

	///
	d.addWord("INTERPRET", false, false, (){ // TODO

		/// Reads the next word from source.

			/// Search this word in the current dictionary.

				/// If this word = [isCompileOnly] and we are not in compile mode, throw err -14.

				/// If this word != [isImmediate] and we are in compile mode, compile it.

				/// Executes the word In any other case.

			/// If word is not found, tries to convert it to a number in current base.

				/// If that's not possible, throw not-standard sys err "not a word not a number" (not understood).

				/// If we are in compiling, compile the number in the data space.

				/// If we are interpreting leave it in the stack.

		/// Loop ends when there are no more words.

	});

}

/// Useful words that are not part of the standard.
///
/// [Gforth Word Index][http://www.complang.tuwien.ac.at/forth/gforth/Docs-html/Word-Index.html#Word-Index]
void includeWordsNotStandardExtra(VirtualMachine vm, Dictionary d) {


	///
	d.addWord("-ROT", false, false, vm.dataStack.RotCC);

	/// Tries to find the name token nt of the word represented by xt.
	///
	/// Returns 0 if it fails.
	/// Note that in the current implementation xt and nt are exactly the same.
	/// [toName][link] ( xt -- nt|0 )
	/// [link]: http://www.complang.tuwien.ac.at/forth/gforth/Docs-html/Name-token.html
	d.addWord(">NAME", false, false, () {}); // TODO

	/// Tries to find the name of the [Word] represented by nt.
	///
	/// Note that in the current implementation xt and nt are exactly the same.
	/// [nameToString][link] ( nt -- addr count )
	/// [link]: http://www.complang.tuwien.ac.at/forth/gforth/Docs-html/Name-token.html
	d.addWord("NAME>STRING", false, false, () {}); // TODO

	/// ...
	///
	/// [id.][link] ( nt -- )  name>string type ;
	/// [link]: TODO
	d.addWord("ID.", false, false, () {}); // TODO
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

	///
	d.addWord("EVALUATE", false, false, (){}); // TODO
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
	//
	//
	// Not implemented:
	//
	//   .S ? DUMP SEE WORDS
	//
	//   AHEAD ASSEMBLER BYE [DEFINED] [ELSE] [IF] [THEN] [UNDEFINED] CODE
	//   CS-PICK CS-ROLL EDITOR FORGET NAME>COMPILE NAME>INTERPRET
	//   NAME>STRING NR> N>R STATE SYNONYM ;CODE TRAVERSE-WORDLIST

	///
	d.addWord(".S", false, false, (){}); // TODO
}



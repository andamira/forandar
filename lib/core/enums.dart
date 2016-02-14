part of forandar;

/// Enumeration of Forth Words st.
///
/// In order to be able to call forth words using the nt (= xt)
/// from inside primitives definitions in Dart.
/// 
/// E.g. to get the nt/xt: Primitive.Store.index
///
/// Using long names from forth-standard.org with the exception of
/// the character minus (-), which is converted to underscore (_).
enum Nt {

	// Standard Core words

	Store,                                 // !
	num,                                   // #
	num_end,                               // #>
	numS,                                  // #S
	Tick,                                  // '
	p,                                     // (
	Times,                                 // *
	TimesDiv,                              // */
	TimesDivMOD,                           // */MOD
	Plus,                                  // +
	PlusStore,                             // +!
	PlusLOOP,                              // +LOOP
	Comma,                                 // ,
	Minus,                                 // -
	d,                                     // .
	Dotq,                                  // ."
	Div,                                   // /
	DivMOD,                                // /MOD
	Zeroless,                              // 0<
	ZeroEqual,                             // 0=
	OnePlus,                               // 1+
	OneMinus,                              // 1-
	TwoStore,                              // 2!
	TwoTimes,                              // 2*
	TwoDiv,                                // 2/
	TwoFetch,                              // 2@
	TwoDROP,                               // 2DROP
	TwoDUP,                                // 2DUP
	TwoOVER,                               // 2OVER
	TwoSWAP,                               // 2SWAP
	Colon,                                 // :
	Semi,                                  // ;
	less,                                  // <
	num_start,                             // <#
	Equal,                                 // =
	more,                                  // >
	toBODY,                                // >BODY
	toIN,                                  // >IN
	toNUMBER,                              // >NUMBER
	toR,                                   // >R
	qDUP,                                  // ?DUP
	Fetch,                                 // @
	ABORT,                                 // ABORT
	ABORTq,                                // ABORT"
	ABS,                                   // ABS
	ACCEPT,                                // ACCEPT
	ALIGN,                                 // ALIGN
	ALIGNED,                               // ALIGNED
	ALLOT,                                 // ALLOT
	AND,                                   // AND
	BASE,                                  // BASE
	BEGIN,                                 // BEGIN
	BL,                                    // BL
	CStore,                                // C!
	CComma,                                // C,
	CFetch,                                // C@
	CELLPlus,                              // CELL+
	CELLS,                                 // CELLS
	CHAR,                                  // CHAR
	CHARPlus,                              // CHAR+
	CHARS,                                 // CHARS
	CONSTANT,                              // CONSTANT
	COUNT,                                 // COUNT
	CR,                                    // CR
	CREATE,                                // CREATE
	DECIMAL,                               // DECIMAL
	DEPTH,                                 // DEPTH
	DO,                                    // DO
	DOES,                                  // DOES>
	DROP,                                  // DROP
	DUP,                                   // DUP
	ELSE,                                  // ELSE
	EMIT,                                  // EMIT
	ENVIRONMENTq,                          // ENVIRONMENT?
	EVALUATE,                              // EVALUATE
	EXECUTE,                               // EXECUTE
	EXIT,                                  // EXIT
	FILL,                                  // FILL
	FIND,                                  // FIND
	FMDivMOD,                              // FM/MOD
	HERE,                                  // HERE
	HOLD,                                  // HOLD
	I,                                     // I
	IF,                                    // IF
	IMMEDIATE,                             // IMMEDIATE
	INVERT,                                // INVERT
	J,                                     // J
	KEY,                                   // KEY
	LEAVE,                                 // LEAVE
	LITERAL,                               // LITERAL
	LOOP,                                  // LOOP
	LSHIFT,                                // LSHIFT
	MTimes,                                // M*
	MAX,                                   // MAX
	MIN,                                   // MIN
	MOD,                                   // MOD
	MOVE,                                  // MOVE
	NEGATE,                                // NEGATE
	OR,                                    // OR
	OVER,                                  // OVER
	POSTPONE,                              // POSTPONE
	QUIT,                                  // QUIT
	Rfrom,                                 // R>
	RFetch,                                // R@
	RECURSE,                               // RECURSE
	REPEAT,                                // REPEAT
	ROT,                                   // ROT
	RSHIFT,                                // RSHIFT
	Sq,                                    // S"
	StoD,                                  // S>D
	SIGN,                                  // SIGN
	SMDivREM,                              // SM/REM
	SOURCE,                                // SOURCE
	SPACE,                                 // SPACE
	SPACES,                                // SPACES
	STATE,                                 // STATE
	SWAP,                                  // SWAP
	THEN,                                  // THEN
	TYPE,                                  // TYPE
	Ud,                                    // U.
	Uless,                                 // U<
	UMTimes,                               // UM*
	UMDivMOD,                              // UM/MOD
	UNLOOP,                                // UNLOOP
	UNTIL,                                 // UNTIL
	VARIABLE,                              // VARIABLE
	WHILE,                                 // WHILE
	WORD,                                  // WORD
	XOR,                                   // XOR
	Bracket,                               // [
	BracketTick,                           // [']
	BracketCHAR,                           // [CHAR]
	right_bracket,                         // ]

	// Standard Core extension words

	Dotp,                                  // .(
	DotR,                                  // .R
	Zerone,                                // 0<>
	Zeromore,                              // 0>
	TwotoR,                                // 2>R
	TwoRfrom,                              // 2R>
	TwoRFetch,                             // 2R@
	ColonNONAME,                           // :NONAME
	ne,                                    // <>
	qDO,                                   // ?DO
	ACTION_OF,                             // ACTION-OF
	AGAIN,                                 // AGAIN
	BUFFERColon,                           // BUFFER:
	Cq,                                    // C"
	CASE,                                  // CASE
	COMPILEComma,                          // COMPILE,
	DEFER,                                 // DEFER
	DEFERStore,                            // DEFER!
	DEFERFetch,                            // DEFER@
	ENDCASE,                               // ENDCASE
	ENDOF,                                 // ENDOF
	ERASE,                                 // ERASE
	FALSE,                                 // FALSE
	HEX,                                   // HEX
	HOLDS,                                 // HOLDS
	IS,                                    // IS
	MARKER,                                // MARKER
	NIP,                                   // NIP
	OF,                                    // OF
	PAD,                                   // PAD
	PARSE,                                 // PARSE
	PARSE_NAME,                            // PARSE-NAME
	PICK,                                  // PICK
	REFILL,                                // REFILL
	RESTORE_INPUT,                         // RESTORE-INPUT
	ROLL,                                  // ROLL
	Seq,                                   // S\"
	SAVE_INPUT,                            // SAVE-INPUT
	SOURCE_ID,                             // SOURCE-ID
	TO,                                    // TO
	TRUE,                                  // TRUE
	TUCK,                                  // TUCK
	UDotR,                                 // U.R
	Umore,                                 // U>
	UNUSED,                                // UNUSED
	VALUE,                                 // VALUE
	WITHIN,                                // WITHIN
	BracketCOMPILE,                        // [COMPILE]
	bs,                                    // \

	// Standard Block words

	BLK,                                   // BLK
	BLOCK,                                 // BLOCK
	BUFFER,                                // BUFFER
//	EVALUATE,                              // EVALUATE
	FLUSH,                                 // FLUSH
	LOAD,                                  // LOAD
	SAVE_BUFFERS,                          // SAVE-BUFFERS
	UPDATE,                                // UPDATE

	// Standard Block extension words

	EMPTY_BUFFERS,                         // EMPTY-BUFFERS
	LIST,                                  // LIST
//	REFILL,                                // REFILL
	SCR,                                   // SCR
	THRU,                                  // THRU
//	bs,                                    // \

	// Standard Double-Number words

	TwoCONSTANT,                           // 2CONSTANT
	TwoLITERAL,                            // 2LITERAL
	TwoVARIABLE,                           // 2VARIABLE
	DPlus,                                 // D+
	DMinus,                                // D-
	Dd,                                    // D.
	DDotR,                                 // D.R
	DZeroless,                             // D0<
	DZeroEqual,                            // D0=
	DTwoTimes,                             // D2*
	DTwoDiv,                               // D2/
	Dless,                                 // D<
	DEqual,                                // D=
	DtoS,                                  // D>S
	DABS,                                  // DABS
	DMAX,                                  // DMAX
	DMIN,                                  // DMIN
	DNEGATE,                               // DNEGATE
	MTimesDiv,                             // M*/
	MPlus,                                 // M+

	// Standard Double-Number extension words

	TwoROT,                                // 2ROT
	TwoVALUE,                              // 2VALUE
	DUless,                                // DU<

	// Standard Exception words

	CATCH,                                 // CATCH
	THROW,                                 // THROW

	// Standard Exception extension words

//	ABORT,                                 // ABORT
//	ABORTq,                                // ABORT"

	// Standard Facility words

	AT_XY,                                 // AT-XY
	KEYq,                                  // KEY?
	PAGE,                                  // PAGE

	// Standard Facility extension words

	PlusFIELD,                             // +FIELD
	BEGIN_STRUCTURE,                       // BEGIN-STRUCTURE
	CFIELDColon,                           // CFIELD:
	EKEY,                                  // EKEY
	EKEYtoCHAR,                            // EKEY>CHAR
	EKEYtoFKEY,                            // EKEY>FKEY
	EKEYq,                                 // EKEY?
	EMITq,                                 // EMIT?
	END_STRUCTURE,                         // END-STRUCTURE
	FIELDColon,                            // FIELD:
	K_ALT_MASK,                            // K-ALT-MASK
	K_CTRL_MASK,                           // K-CTRL-MASK
	K_DELETE,                              // K-DELETE
	K_DOWN,                                // K-DOWN
	K_END,                                 // K-END
	K_FOne,                                // K-F1
	K_FOneZero,                            // K-F10
	K_FOneOne,                             // K-F11
	K_FOneTwo,                             // K-F12
	K_FTwo,                                // K-F2
	K_F3,                                  // K-F3
	K_F4,                                  // K-F4
	K_F5,                                  // K-F5
	K_F6,                                  // K-F6
	K_F7,                                  // K-F7
	K_F8,                                  // K-F8
	K_F9,                                  // K-F9
	K_HOME,                                // K-HOME
	K_INSERT,                              // K-INSERT
	K_LEFT,                                // K-LEFT
	K_NEXT,                                // K-NEXT
	K_PRIOR,                               // K-PRIOR
	K_RIGHT,                               // K-RIGHT
	K_SHIFT_MASK,                          // K-SHIFT-MASK
	K_UP,                                  // K-UP
	MS,                                    // MS
	TIMEandDATE,                           // TIME&amp;DATE

	// Standard File words

//	p,                                     // (
	BIN,                                   // BIN
	CLOSE_FILE,                            // CLOSE-FILE
	CREATE_FILE,                           // CREATE-FILE
	DELETE_FILE,                           // DELETE-FILE
	FILE_POSITION,                         // FILE-POSITION
	FILE_SIZE,                             // FILE-SIZE
	INCLUDE_FILE,                          // INCLUDE-FILE
	INCLUDED,                              // INCLUDED
	OPEN_FILE,                             // OPEN-FILE
	RDivO,                                 // R/O
	RDivW,                                 // R/W
	READ_FILE,                             // READ-FILE
	READ_LINE,                             // READ-LINE
	REPOSITION_FILE,                       // REPOSITION-FILE
	RESIZE_FILE,                           // RESIZE-FILE
//	Sq,                                    // S"
//	SOURCE_ID,                             // SOURCE-ID
	WDivO,                                 // W/O
	WRITE_FILE,                            // WRITE-FILE
	WRITE_LINE,                            // WRITE-LINE

	// Standard File extension words

	FILE_STATUS,                           // FILE-STATUS
	FLUSH_FILE,                            // FLUSH-FILE
	INCLUDE,                               // INCLUDE
//	REFILL,                                // REFILL
	RENAME_FILE,                           // RENAME-FILE
	REQUIRE,                               // REQUIRE
	REQUIRED,                              // REQUIRED
//	Seq,                                   // S\"

	// Standard Float words

	toFLOAT,                               // >FLOAT
	DtoF,                                  // D>F
	FStore,                                // F!
	FTimes,                                // F*
	FPlus,                                 // F+
	FMinus,                                // F-
	FDiv,                                  // F/
	FZeroless,                             // F0<
	FZeroEqual,                            // F0=
	Fless,                                 // F<
	FtoD,                                  // F>D
	FFetch,                                // F@
	FALIGN,                                // FALIGN
	FALIGNED,                              // FALIGNED
	FCONSTANT,                             // FCONSTANT
	FDEPTH,                                // FDEPTH
	FDROP,                                 // FDROP
	FDUP,                                  // FDUP
	FLITERAL,                              // FLITERAL
	FLOATPlus,                             // FLOAT+
	FLOATS,                                // FLOATS
	FLOOR,                                 // FLOOR
	FMAX,                                  // FMAX
	FMIN,                                  // FMIN
	FNEGATE,                               // FNEGATE
	FOVER,                                 // FOVER
	FROT,                                  // FROT
	FROUND,                                // FROUND
	FSWAP,                                 // FSWAP
	FVARIABLE,                             // FVARIABLE
	REPRESENT,                             // REPRESENT

	// Standard Float extension words

	DFStore,                               // DF!
	DFFetch,                               // DF@
	DFALIGN,                               // DFALIGN
	DFALIGNED,                             // DFALIGNED
	DFFIELDColon,                          // DFFIELD:
	DFLOATPlus,                            // DFLOAT+
	DFLOATS,                               // DFLOATS
	FTimesTimes,                           // F**
	Fd,                                    // F.
	FtoS,                                  // F>S
	FABS,                                  // FABS
	FACOS,                                 // FACOS
	FACOSH,                                // FACOSH
	FALOG,                                 // FALOG
	FASIN,                                 // FASIN
	FASINH,                                // FASINH
	FATAN,                                 // FATAN
	FATANTwo,                              // FATAN2
	FATANH,                                // FATANH
	FCOS,                                  // FCOS
	FCOSH,                                 // FCOSH
	FEd,                                   // FE.
	FEXP,                                  // FEXP
	FEXPMOne,                              // FEXPM1
	FFIELDColon,                           // FFIELD:
	FLN,                                   // FLN
	FLNPOne,                               // FLNP1
	FLOG,                                  // FLOG
	FSd,                                   // FS.
	FSIN,                                  // FSIN
	FSINCOS,                               // FSINCOS
	FSINH,                                 // FSINH
	FSQRT,                                 // FSQRT
	FTAN,                                  // FTAN
	FTANH,                                 // FTANH
	FTRUNC,                                // FTRUNC
	FVALUE,                                // FVALUE
	Ftilde,                                // F~
	PRECISION,                             // PRECISION
	StoF,                                  // S>F
	SET_PRECISION,                         // SET-PRECISION
	SFStore,                               // SF!
	SFFetch,                               // SF@
	SFALIGN,                               // SFALIGN
	SFALIGNED,                             // SFALIGNED
	SFFIELDColon,                          // SFFIELD:
	SFLOATPlus,                            // SFLOAT+
	SFLOATS,                               // SFLOATS

	// Standard Locals words

	LOCAL,                                 // (LOCAL)

	// Standard Locals extension words

	LOCALS,                                // LOCALS|
	bColon,                                // {:

	// Standard Memory words

	ALLOCATE,                              // ALLOCATE
	FREE,                                  // FREE
	RESIZE,                                // RESIZE

	// Standard Memory extension words

	// Standard Programming-Tools words

	DotS,                                  // .S
	q,                                     // ?
	DUMP,                                  // DUMP
	SEE,                                   // SEE
	WORDS,                                 // WORDS

	// Standard Programming-Tools extension words

	SemiCODE,                              // ;CODE
	AHEAD,                                 // AHEAD
	ASSEMBLER,                             // ASSEMBLER
	BYE,                                   // BYE
	CODE,                                  // CODE
	CS_PICK,                               // CS-PICK
	CS_ROLL,                               // CS-ROLL
	EDITOR,                                // EDITOR
	FORGET,                                // FORGET
	NtoR,                                  // N>R
	NAMEtoCOMPILE,                         // NAME>COMPILE
	NAMEtoINTERPRET,                       // NAME>INTERPRET
	NAMEtoSTRING,                          // NAME>STRING
	NRfrom,                                // NR>
//	STATE,                                 // STATE
	SYNONYM,                               // SYNONYM
	TRAVERSE_WORDLIST,                     // TRAVERSE-WORDLIST
	BracketDEFINED,                        // [DEFINED]
	BracketELSE,                           // [ELSE]
	BracketIF,                             // [IF]
	BracketTHEN,                           // [THEN]
	BracketUNDEFINED,                      // [UNDEFINED]

	// Standard Search-Order words

	DEFINITIONS,                           // DEFINITIONS
//	FIND,                                  // FIND
	FORTH_WORDLIST,                        // FORTH-WORDLIST
	GET_CURRENT,                           // GET-CURRENT
	GET_ORDER,                             // GET-ORDER
	SEARCH_WORDLIST,                       // SEARCH-WORDLIST
	SET_CURRENT,                           // SET-CURRENT
	SET_ORDER,                             // SET-ORDER
	WORDLIST,                              // WORDLIST

	// Standard Search-Order extension words

	ALSO,                                  // ALSO
	FORTH,                                 // FORTH
	ONLY,                                  // ONLY
	ORDER,                                 // ORDER
	PREVIOUS,                              // PREVIOUS

	// Standard String words

	MinusTRAILING,                         // -TRAILING
	DivSTRING,                             // /STRING
	BLANK,                                 // BLANK
	CMOVE,                                 // CMOVE
	CMOVEtop,                              // CMOVE>
	COMPARE,                               // COMPARE
	SEARCH,                                // SEARCH
	SLITERAL,                              // SLITERAL

	// Standard String extension words

	REPLACES,                              // REPLACES
	SUBSTITUTE,                            // SUBSTITUTE
	UNESCAPE,                              // UNESCAPE

	// Standard Extended-Character words

	X_SIZE,                                // X-SIZE
	XCStorePlus,                           // XC!+
	XCStorePlusq,                          // XC!+?
	XCComma,                               // XC,
	XC_SIZE,                               // XC-SIZE
	XCFetchPlus,                           // XC@+
	XCHARPlus,                             // XCHAR+
	XEMIT,                                 // XEMIT
	XKEY,                                  // XKEY
	XKEYq,                                 // XKEY?

	// Standard Extended-Character extension words

	PlusXDivSTRING,                        // +X/STRING
	MinusTRAILING_GARBAGE,                 // -TRAILING-GARBAGE
//	CHAR,                                  // CHAR
	EKEYtoXCHAR,                           // EKEY>XCHAR
//	PARSE,                                 // PARSE
	X_WIDTH,                               // X-WIDTH
	XC_WIDTH,                              // XC-WIDTH
	XCHARMinus,                            // XCHAR-
	XHOLD,                                 // XHOLD
	XSTRINGMinus,                          // X\STRING-
//	BracketCHAR,                           // [CHAR]


	// Not-Standard Core words
	BOOTMESSAGE,                           // BOOTMESSAGE
	INTERPRET,                             // INTERPRET
	SCAN,                                  // SCAN
	SKIP,                                  // SKIP

	// Not-Standard Extended words
	DotFS,                                 // .FS
	DotRS,                                 // .RS
	qSTRING,                               // ?STRING

}


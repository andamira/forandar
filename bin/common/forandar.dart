part of forandar;

VirtualMachine forth;

main(List<String> args) async {

  /// Creates the Forth [VirtualMachine].
  forth = new VirtualMachine(input: new InputQueue(), args: args, argParser: argParser);

  /// Includes the primitives dependent on the CLI interface.
  includeWordsCli(forth, forth.dict);

  /// Interprets the code in the input queue.
  //forth.dict.execNt(Nt.INTERPRET); // TODO FIXME

  /// Starts the interactive interpreter if BYE hasn't been called.
  forth.dict.execNt(Nt.BOOTMESSAGE);
  forth.dict.execNt(Nt.QUIT);
}

/// Parses the arguments from the command line.
///
/// Updates the default configuration in [c].
/// Fills the source code input queue in [i].
void argParser(List<String> args, Configuration c, InputQueue i) {

  ArgResults results;
  ArgParser parser = new ArgParser(allowTrailingOptions: false);

  parser
    ..addSeparator('Usage: forandar [options]')
    ..addSeparator('The default value is shown at the end of each description.') // ---
    ..addSeparator('Load source code options:') // ---

    /// Argument -e, --evaluate
    ..addOption('evaluate', abbr: 'e',
      allowMultiple: true,
      splitCommas: false, // Must be false to preserve the commas (,) in string
      valueHelp: 'STRING',
      help: "Interpret STRING (with `EVALUATE')"
    )

    /// Argument -i, --include
    ..addOption('include', abbr: 'i',
      allowMultiple: true,
      valueHelp: 'FILE',
      help: "Load FILE (with `INCLUDE')"
    )

    ..addSeparator('Virtual machine options:') // ---

    /// Argument -d, --data-stack-size
    ..addOption('data-stack-size', abbr: 'd',
      allowMultiple: false,
      valueHelp: 'ELEMENTS',
      callback: _checkArgIsPositiveInteger,
      help: "Specify data stack size ${_defaultValue(Configuration.defaultDataStackSize)}"
    )

    /// Argument -f, --float-stack-size
    ..addOption('float-stack-size', abbr: 'f',
      allowMultiple: false,
      valueHelp: 'ELEMENTS',
      callback: _checkArgIsPositiveInteger,
      help: "Specify floating point stack size ${_defaultValue(Configuration.defaultFloatStackSize)}"
    )

    /// Argument -r, --return-stack-size
    ..addOption('return-stack-size', abbr: 'r',
      allowMultiple: false,
      valueHelp: 'ELEMENTS',
      callback: _checkArgIsPositiveInteger,
      help: "Specify return stack size ${_defaultValue(Configuration.defaultReturnStackSize)}"
    )

    /// Argument -D, --data-space-size
    ..addOption('data-space-size', abbr: 'D',
      allowMultiple: false,
      valueHelp: 'BYTES',
      callback: _checkArgIsPositiveInteger, // TODO: accept other values
      help: "Specify data space size ${_defaultValue(Configuration.defaultDataSpaceSize)}"
    )

    ..addSeparator('Terminal options:') // ---

    /// Argument -T, --terminal-type
    ..addOption('terminal-type', abbr: 'T',
      allowMultiple: false,
      valueHelp: TerminalType.values.join("|").replaceAll("TerminalType.", ""),
      help: "Specify the terminal type ${_defaultValue(Configuration.defaultTerminalType.toString().split('.').last)}"
    )

    /// Argument -H, --terminal-history-lines
    ..addOption('terminal-history-lines', abbr: 'H',
      allowMultiple: false,
      valueHelp: 'LINES',
      callback: _checkArgIsPositiveInteger,
      help: "Specify the history lines in 'xterm' ${_defaultValue(Configuration.defaultTerminalHistoryLines)}"
    )

    ..addSeparator('Misc options:') // ---

    /// Argument -v, --version
    ..addFlag('version', abbr: 'v',
      negatable: false,
      help: "Print version and exit",
      callback: (version) {
        if (version) {
          print("Forandar 0.9.X"); // TEMP FIXME
          exit(1);
        }
      }
    )

    /// Argument -h, --help
    ..addFlag('help', abbr: 'h',
      hide: false,
      negatable: false,
      help: "This help",
      callback: (help) {
        if (help) displayUsage(parser);
      }
    );

  try {
    results = parser.parse(args);
  } catch (e) {
    print(e);
    print("\nRead usage with: `forandar --help`");
    //displayUsage(parser);
    exit(1);
  }

  int eCounter = 0;
  int iCounter = 0;

  // Manage the received arguments.
  args.forEach((arg) {

    switch (arg) {

      case '-e':
      case '--evaluate':
        try {
          i.add(InputType.String, results['evaluate'][eCounter++]);
        } catch(e) {
          throw ForthError.unmanaged("-e: $e");
        }
        break;

      case '-i':
      case '--include':
        try {
          i.add(InputType.File, results['include'][iCounter++]);
        } catch(e) {
          throw ForthError.unmanaged("-i: $e");
        }
        break;

      // VirtualMachine

      case '-d':
      case '--data-stack-size':
        try {
          c.setOption('dataStackSize', results['data-stack-size']);
        } catch(e) {
          throw ForthError.unmanaged("-d: $e");
        }
        break;

      case '-f':
      case '--float-stack-size':
        try {
          c.setOption('floatStackSize', results['float-stack-size']);
        } catch(e) {
          throw ForthError.unmanaged("-f: $e");
        }
        break;

      case '-r':
      case '--return-stack-size':
        try {
          c.setOption('returnStackSize', results['return-stack-size']);
        } catch(e) {
          throw ForthError.unmanaged("-r: $e");
        }
        break;

      case '-D':
      case '--data-space-size':
        try {
          c.setOption('dataSpaceSize', results['data-space-size']);
        } catch(e) {
          throw ForthError.unmanaged("-D: $e");
        }
        break;

      case '-T':
      case '--terminal-type':
        try {
          switch (results['terminal-type']) {
            case 'auto':
              c.setOption('terminalType', TerminalType.auto);
              break;
            case 'simple':
              c.setOption('terminalType', TerminalType.simple);
              break;
            case 'xterm':
              c.setOption('terminalType', TerminalType.xterm);
              break;
          }
        } catch(e) {
          throw ForthError.unmanaged("-T: $e");
        }
        break;

      case '-H':
      case '--terminal-history-lines':
        try {
          c.setOption('terminalHistoryLines', results['terminal-history-lines']);
        } catch(e) {
          throw ForthError.unmanaged("-H: $e");
        }
        break;

      }

  });
}

/// Default Value Wrapper
String _defaultValue(dynamic v) {
  return "($v)";
}

_checkArgIsPositiveInteger(arg) {

  bool fail;
  int argInt;

  if (arg != null) {
    try {
      argInt = int.parse(arg);
    } catch(e) {
      fail = true;
    }

    if (fail || argInt < 0) {
      throw new FormatException('The value "$arg" should be a positive integer');
      (1);
    }
  }
}

/// Displays usage and exits.
void displayUsage(ArgParser parser) {
  print(parser.usage);
  exit(0);
}

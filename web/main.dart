import 'dart:html';
import 'dart:js';

import 'package:forandar/forandar_web.dart';

// TEMP
var codeOutput;
var consoleOutput;

main() async {

  var c = new Configuration();
  var i = new InputQueue();

  // TODO https://stackoverflow.com/questions/26848783/wait-for-future-to-complete/26962630#26962630

  /// Loads the configuration.
  ///
  /// Options specified in the JavaScript context will override the defaults.
  await loadConfiguration(c);

  /// Creates the Forth [VirtualMachine].
  var forth = new VirtualMachine(config: c, input: i);

  /// Includes the primitives dependent on the web interface.
  includeWordsWeb(forth, forth.dict);
}

/// Defines and loads the global options.
///
/// Overrides the default values with the fetched data.
loadConfiguration(Configuration c) async {

  if (context.hasProperty('forandar')) {

    JsObject forandar= context['forandar'];

    /// Overrides the properties specified in the JavaScript context.
    c.keys.forEach((key) {

      var newValue = forandar['config'][key];

      c.setOption(key, newValue);
    });


    // TEMP
    codeOutput = querySelector('#codeOutput');
    consoleOutput = querySelector('#consoleOutput');

    /// Fetches the Forth source code
    ///
    /// For now it only supports loading a single file
    String source = forandar['source'].toString();

    if (source != null) {

      try {
        var fCode = await HttpRequest.getString(source);
        codeOutput.querySelector('h3').appendHtml(' <span class="filename">$source</pre>');
        codeOutput.querySelector('code').appendText(fCode);

      } catch (e) {
        // window.console.error('Couldn\'t open $path');
      }

    }
  }
}

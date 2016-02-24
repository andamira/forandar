import 'dart:html';
import 'dart:js';

import 'package:forandar/forandar_web.dart';

// TEMP
var codeOutput;
var consoleOutput;

void main() async {

	var c = new Configuration();
	var i = new InputQueueWeb();

	// TODO https://stackoverflow.com/questions/26848783/wait-for-future-to-complete/26962630#26962630

    /// Initializes the configuration.
    ///   
    /// Overrides any defaults when specified in the JavaScript context.
    await loadConfiguration(c);

    /// Creates the Forth [VirtualMachine].
	var forth = new VirtualMachine(c, i);

	/// Includes the primitives dependent on the web interface.
	includeWordsWeb(forth, forth.dict);
}

/// Defines and loads the global options.
///
/// Overrides the default values with the fetched data.
void loadConfiguration(Configuration c) async {

    if (context.hasProperty('forandar')) {

        JsObject forandar= context['forandar'];

        /// Overrides the properties specified in the JavaScript context.
        c.option.forEach((key, value) {

            var newValue = forandar['config'][key];

            // If it's valid and different from the default
            if (newValue != null && newValue != value) {
                window.console.info("Override c.option['$key'] $value > $newValue");
                c.option[key] = newValue;
            }
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


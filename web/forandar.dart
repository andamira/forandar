import 'package:forandar/forandar.dart';
import 'package:forandar/web.dart';

VirtualMachine forth;
Configuration config;

var codeOutput;
var consoleOutput;

void main() async {

	updateVersion();

	// TODO https://stackoverflow.com/questions/26848783/wait-for-future-to-complete/26962630#26962630

    /// Initializes the configuration.
    ///   
    /// Overrides any defaults when specified in the JavaScript context.
    config = await loadConfiguration();

    /// Creates the Forth [VirtualMachine].
    forth = new VirtualMachine(config);

	/// Includes the primitives dependant on the web interface.
	includeWebPrimitives(forth.dict);
}

/// Updates forandar version in HTML
void updateVersion() async {
	querySelector('.forandar-version').appendText(forandarVersion);
}

/// Defines and loads the global options.
///
/// Overrides the default values with the fetched data.
Configuration loadConfiguration() async {


    if (context.hasProperty('forandar')) {

        JsObject forandar= context['forandar'];

        /// Overrides the properties specified in the JavaScript context.
        config.option.forEach((key, value) {

            var newValue = forandar['config'][key];

            // If it's valid and different from the default
            if (newValue != null && newValue != value) {
                window.console.info("Override config.option['$key'] $value > $newValue");
                config.option[key] = newValue;
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
            //source = "https://www.dartlang.org/f/portmanteaux.json"; // TEMP

            try {
                var fCode = await HttpRequest.getString(source);
                codeOutput.querySelector('h3').appendHtml(' <span class="filename">$source</pre>');
                codeOutput.querySelector('code').appendText(fCode);

            } catch (e) {
                window.console.error('Couldn\'t open $path');
            }

        }
    }

    return c;
}


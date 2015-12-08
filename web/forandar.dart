import 'package:forandar/forandar.dart';
import 'package:forandar/web.dart';

var codeOutput;
var consoleOutput;

void main() async {

	// TODO https://stackoverflow.com/questions/26848783/wait-for-future-to-complete/26962630#26962630

    /// Initializes the configuration.
    ///   
    /// Overrides any configuration specified in the javascript context.
    Configuration config = await loadConfiguration();

    /// Creates the Forth [VirtualMachine]
    VirtualMachine forth = new VirtualMachine(config);
}

/// Defines and loads the global options.
///
/// Overrides the default values with the fetched data.
loadConfiguration() async {

    /// Create the default [Configuration] object
    Configuration c = new Configuration();

    if (context.hasProperty('forandar')) {

        JsObject forandar= context['forandar'];

        /// Overrides the properties specified in
        c.option.forEach((key, value) {

            var newValue = forandar['config'][key];

            // If it's valid and different from the default
            if (newValue != null && newValue != value) {
                window.console.info("Override config.option['$key'] $value > $newValue");
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
            //source = "https://www.dartlang.org/f/portmanteaux.json"; // TEMP

            try {
                var fCode = await HttpRequest.getString(source);
                codeOutput.querySelector('h3').appendHtml(' <span class="filename">$source</pre>');
                codeOutput.querySelector('code').appendText(fCode);

            } catch (e) {
                window.console.error('Couldn\'t open $path');
                //handleError(e);
            }

        }
    }

    return c;
}

/*
handleError(Object error) {
  codeOutput.children.add(new LIElement()..text = 'Request failed.');
}
*/



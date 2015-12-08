library forandar;

// https://developer.mozilla.org/en-US/docs/Web/API/Console
// https://api.dartlang.org/1.13.0/dart-html/Console-class.html

    /// Wraps console print for debug, info warn & error
    /// 
    printD(String s) => window.console.debug(s);
    printI(String s) => window.console.info(s);
    printW(String s) => window.console.warn(s);
    printE(String s) => window.console.error(s);

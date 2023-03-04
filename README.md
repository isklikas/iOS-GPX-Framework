# iOS GPX Framework
---------------------------------

This is a universal module for parsing/generating GPX files.
This module parses the GPX from a URL or String and creates Swift Instances of GPX structure. 

How to install?
---------------------------------

### Installing from Xcode

1. Add a package by selecting `File` → `Add Packages…` in Xcode’s menu bar.

2. Search for the package using the repo's URL:
```console
https://github.com/isklikas/iOS-GPX-Framework.git
```

3. Next, set the **Dependency Rule** to be `Up to Next Minor Version`.

4. Then, select **Add Package**.

### Alternatively, add GPX to a `Package.swift` manifest

To integrate via a `Package.swift` manifest instead of Xcode, you can add GPX to the dependencies array of your package:

```swift
dependencies: [
  .package(
    name: "GPX",
    url: "https://github.com/isklikas/iOS-GPX-Framework.git",
    .upToNextMinor(from: "1.0.0")
  ),

  // Any other dependencies you have...
],
```

How to use?
---------------------------------

1. Import the GPX Module:

    ```swift
    import GPX;
    ```
    
2. To parse a GPX File, call the parse method, with a class that conforms to the `GPXParsing` protocol. For example:

    ```swift
    let urlPath = Bundle.main.url(forResource: "mystic_basin_trail", withExtension: "gpx");
    let parser = GPXParser(urlPath);
    parser.delegate = self;
    parser.start();
    
    func parser(_ parser: GPXParser, didCompleteParsing rootXMLElement: GPXXMLElement) {
        let root = GPXRoot(withXMLElement: rootXMLElement);
        // Use the parsed GPX file as you wish, for an example you can refer to 
        // the test file in the git repo.
    }
    
    func parser(_ parser: GPXParser, didFailParsingWithError error: Error) {
        print(error.localizedDescription);
    }
    ```
    
3. To generate a GPX File

    ```swift
    // Work in progress...
    // Will update in the next few days
    ```
    

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

For every function, the GPX Framework must be imported.

1. Import the GPX Module:

    ```swift
    import GPX;
    ```

### To Parse a GPX file:
    
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

### To Save a GPX file:
    
2. To generate a GPX File, initialise a `GPXLogger` object. There are 3 options:
    
    a. Initialise with an array of coordinates:
    
        ```swift
        // For such an example, you may also refere to the GPXTests file
        let coordinates: [CLLocationCoordinate2D]; // Your Coordinates Array
        let logger = GPXLogger(coordinates);
        ```
    
    b. Initialise with an array of locations:
    
        ```swift
        let locations: [CLLocation]; // Your Locations Array
        let logger = GPXLogger(locations);
        ```
        i. In `GPXLogger` initialisers for coordinates / locations, there is a `savingPreference` optional property. The default option, is `.tracks`:

            i.a: To save the exported route as a route, you can specify in the initialiser, as follows:
            
                ```swift
                let locations: [CLLocation]; // Your Locations Array
                let logger = GPXLogger(locations, savingPreference: .route);
                ```

            i.b: To save the exported route as an array of waypoints, you can specify in the initialiser, as follows:
            
                ```swift
                // GPX Waypoints are normally intended to be used as landmark points and not as a travelled path.
                let coordinates: [CLLocationCoordinate2D]; // Your Coordinates Array
                let logger = GPXLogger(locations, savingPreference: .waypoints);
                ```

            i.c: To save the exported route as a track, you do not need to specify the `savingPreference` property, as this is the default value.
            
        ii. In `GPXLogger` initialisers for coordinates / locations, there is also a `creator` optional property. The default option, is `"iOS-GPX-Framework"`, but you can change it to your application's name:
        
            ```swift
            let locations: [CLLocation]; // Your Coordinates Array
            let logger = GPXLogger(locations, creator: "developer.my-app.com");
            
            // Or, if you wish to also specify the savingPreference property:
            // let logger = GPXLogger(locations, creator: "developer.my-app.com", savingPreference: .route);
            ```
    
    c. Initialise with an already existing `GPXRoot` object, that you have either parsed from a file and edited, or generated in case you want to use more metadata than a coordinates / locations array:
    
        ```swift
        let gpxRoot: GPXRoot; // Your Root Object
        let logger = GPXLogger(gpxRoot);
        ```

3. To get the exported GPX String, call the export method, which exports the GPX File as a String. Saving is then done, in the usual way:

    ```swift
    let exportedGPX = logger.export();
    
    // The Application's Document path, from here, you can also point to a sub-directory of Documents, as long as you have created the folder first
    let documentsFolderURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    // Append directory path components first here, if any (and already created, as mentioned).
    
    // Name the file as you wish
    let filename = documentsFolderURL.appendingPathComponent("gpx-filename.gpx")
    
    // Lastly, save the file
    do {
        try exportedGPX.write(to: filename, atomically: true, encoding: String.Encoding.utf8)
    } catch {
        // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
        print(error.localizedDescription);
    }
    ```
    

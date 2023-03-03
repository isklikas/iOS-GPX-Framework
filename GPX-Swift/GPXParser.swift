//
//  GPXParser.swift
//  GPX
//
//  Created by John Sklikas on 3/3/23.
//

import UIKit

/** Instances of this class parse GPX documents.
 */
class GPXParser: NSObject {
    
    var gpxXMLParser: GPXXMLParser;
    
    
    /// ---------------------------------
    /// @name Parsing
    /// ---------------------------------

    /** Parsing the GPX content referenced by the given URL.
- Parameter url: A URL object specifying a URL. The URL must be fully qualified and refer to a scheme that is supported by the NSURL class.
- Returns: An initialized GPXRoot object or nil if an error occurs.
     */
    init(_ url: URL) {
        self.gpxXMLParser = GPXXMLParser(url: url);
        super.init()
    }

    /** Parsing the GPX content referenced by the given File path.
     @param path The absolute path of the file from which to read GPX data.
     @return An initialized GPXRoot object or nil if an error occurs.
     */
    init?(_ path: String) {
        var url: URL?
        if #available(iOS 16, *) {
            url = URL(filePath: path);
        }
        else {
            url = URL(fileURLWithPath: path)
        }
        guard let url = url else {
            return nil;
        }
        self.gpxXMLParser = GPXXMLParser(url: url);
        super.init();
    }

    /** Parsing the GPX content referenced by the given GPX string.
     @param string The GPX string.
     @return An initialized GPXRoot object or nil if an error occurs.
     */
    init(withString string: String) {
        self.gpxXMLParser = GPXXMLParser(string: string);
        super.init();
    }

    /** Parsing the GPX content referenced by the given data.
     @param data The data from which to read GPX data.
     @return An initialized GPXROot object or nil if an error occurs.
     */
    init(withData data: Data) {
        self.gpxXMLParser = GPXXMLParser(data: data);
        super.init();
    }

}

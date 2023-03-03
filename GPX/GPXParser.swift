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
    
    
    /// ---------------------------------
    /// @name Parsing
    /// ---------------------------------

    /** Parsing the GPX content referenced by the given URL.
- Parameter url: A URL object specifying a URL. The URL must be fully qualified and refer to a scheme that is supported by the NSURL class.
- Returns: An initialized GPXRoot object or nil if an error occurs.
     */
    class func parseGPXAtURL(_ url: URL) -> GPXRoot? {
        let xml = GPXXML(withURL: url);
        if let rootElement = xml.rootXMLElement {
            return GPXRoot(withXMLElement: rootElement)
        }
        return nil;
    }

    /** Parsing the GPX content referenced by the given File path.
     @param path The absolute path of the file from which to read GPX data.
     @return An initialized GPXRoot object or nil if an error occurs.
     */
    class func parseGPXAtPath(_ path: String) -> GPXRoot? {
        var url: URL?
        if #available(iOS 16, *) {
            url = URL(filePath: path);
        }
        else {
            url = URL(fileURLWithPath: path)
        }
        if let url = url {
            return self.parseGPXAtURL(url);
        }
        return nil;
    }

    /** Parsing the GPX content referenced by the given GPX string.
     @param string The GPX string.
     @return An initialized GPXRoot object or nil if an error occurs.
     */
    class func parseGPXWithString(_ string: String) -> GPXRoot? {
        let xml = GPXXML(withXMLString: string);
        if let rootElement = xml.rootXMLElement {
            return GPXRoot(withXMLElement: rootElement)
        }
        return nil;
    }

    /** Parsing the GPX content referenced by the given data.
     @param data The data from which to read GPX data.
     @return An initialized GPXROot object or nil if an error occurs.
     */
    class func parseGPXWithData(_ data: Data) -> GPXRoot? {
        let xml = GPXXML(withXMLData: data);
        if let rootElement = xml.rootXMLElement {
            return GPXRoot(withXMLElement: rootElement)
        }
        return nil;
        
    }

}

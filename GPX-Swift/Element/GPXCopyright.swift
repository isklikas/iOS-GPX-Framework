//
//  GPXCopyright.swift
//  GPX
//
//  Created by John Sklikas on 29/1/23.
//

import UIKit

/** Information about the copyright holder and any license governing use of this file.
    By linking to an appropriate license, you may place your data into the public domain or grant additional usage rights.
 */
class GPXCopyright: GPXElement {
    
    
    /// ---------------------------------
    /// @name Accessing Properties
    /// ---------------------------------

    /** Year of copyright. */
    var year: Date?

    /** Link to external file containing license text. */
    var license: String?

    /** Copyright holder (TopoSoft, Inc.) */
    var author: String = "";
    
    
    /// ---------------------------------
    /// @name Create Copyright
    /// ---------------------------------

    required init(withXMLElement element: GPXXMLElement, parent: GPXElement? = nil) {
        super.init(withXMLElement: element, parent: parent);
        if let yearValue = self.textForSingleChildElementNamed("year", xmlElement: element) {
            self.year = GPXType.dateTime(yearValue)
        }
        self.license = self.textForSingleChildElementNamed("license", xmlElement: element);
        self.author = self.valueOfAttributeNamed("author", xmlElement: element, required: true) ?? "";
    }
    
    required override init(parent: GPXElement? = nil) {
        self.author = "";
        super.init(parent: parent);
    }
    
    /** Creates and returns a new copyright element.
     @param author Copyright holder (TopoSoft, Inc.)
     @return A newly created copyright element.
     */
    class func copyrightWithAuthor(author: String) -> GPXCopyright {
        let copyright = self.init()
        copyright.author = author;
        return copyright;
    }
    
    override class func tagName() -> String? {
        return "copyright";
    }
    
    //MARK: GPX
    override func addOpenTagToGpx(_ gpx: inout String, indentationLevel: Int) {
        var attribute = "";
        attribute = attribute.appendingFormat(" author=\"%@\"", self.author)
        
        let appendedStr = String(format: "%@<%@%@>\r\n",
                            self.indentForIndentationLevel(indentationLevel),
                            type(of: self).tagName()!,
                            attribute)
        gpx.append(appendedStr);
    }
    
    override func addChildTagToGpx(_ gpx: inout String, indentationLevel: Int) {
        super.addChildTagToGpx(&gpx, indentationLevel: indentationLevel)
        var dateStr: String?
        if let year = self.year {
            dateStr = GPXType.valueForDateTime(year);
        }
        self.gpx(&gpx, addPropertyForValue: dateStr, tagName: "year", indentationLevel: indentationLevel);
        self.gpx(&gpx, addPropertyForValue: self.license, tagName: "license", indentationLevel: indentationLevel);
    }
    
}

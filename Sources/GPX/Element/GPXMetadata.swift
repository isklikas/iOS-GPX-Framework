//
//  GPXMetadata.swift
//  GPX
//
//  Created by John Sklikas on 12/2/23.
//

import Foundation

/** Information about the GPX file, author, and copyright restrictions goes in the metadata section.
    Providing rich, meaningful information about your GPX files allows others to search for and use your GPS data.
 */
public class GPXMetadata: GPXElement {
    
    /// ---------------------------------
    /// ** Accessing Properties
    /// ---------------------------------

    /** The name of the GPX file. */
    public var name: String?

    /** A description of the contents of the GPX file. */
    public var desc: String?

    /** The person or organization who created the GPX file. */
    public var author: GPXAuthor?

    /** Copyright and license information governing use of the file. */
    public var copyright: GPXCopyright?

    /** URLs associated with the location described in the file. */
    public var link: GPXLink?

    /** The creation date of the file. */
    public var time: Date? {
        get {
            return GPXType.dateTime(timeValue);
        }
        set {
            if let newValue = newValue {
                timeValue = GPXType.valueForDateTime(newValue)
            }
            else {
                timeValue = "";
            }
        }
    }
    private var timeValue: String = ""

    /** Keywords associated with the file. Search engines or databases can use this information to classify the data. */
    public var keywords: String?

    /** Minimum and maximum coordinates which describe the extent of the coordinates in the file. */
    var bounds: GPXBounds?

    /** You can add extend GPX by adding your own elements from another schema here. */
    var extensions: GPXExtensions?
    
    //MARK: Instance
    required init(withXMLElement element: GPXXMLElement, parent: GPXElement? = nil) {
        super.init(withXMLElement: element, parent: parent);
        name = self.textForSingleChildElementNamed("name", xmlElement: element);
        desc = self.textForSingleChildElementNamed("desc", xmlElement: element);
        author = self.childElementOfClass(GPXAuthor.self, xmlElement: element) as? GPXAuthor;
        copyright = self.childElementOfClass(GPXCopyright.self, xmlElement: element) as? GPXCopyright;
        link = self.childElementOfClass(GPXLink.self, xmlElement: element) as? GPXLink;
        timeValue = self.textForSingleChildElementNamed("time", xmlElement: element) ?? ""
        keywords = self.textForSingleChildElementNamed("keywords", xmlElement: element);
        bounds = self.childElementOfClass(GPXBounds.self, xmlElement: element) as? GPXBounds;
        extensions = self.childElementOfClass(GPXExtensions.self, xmlElement: element) as? GPXExtensions;
    }
    
    //MARK: Tag
    
    override class func tagName() -> String? {
        return "metadata";
    }
    
    //MARK: GPX
    override func addChildTagToGpx(_ gpx: inout String, indentationLevel: Int) {
        super.addChildTagToGpx(&gpx, indentationLevel: indentationLevel)
        
        self.gpx(&gpx, addPropertyForValue: name, tagName: "name", indentationLevel: indentationLevel);
        self.gpx(&gpx, addPropertyForValue: desc, tagName: "desc", indentationLevel: indentationLevel);
        
        if let author = self.author {
            author.gpx(&gpx, indentationLevel: indentationLevel);
        }
        
        if let copyright = self.copyright {
            copyright.gpx(&gpx, indentationLevel: indentationLevel);
        }
        
        if let link = self.link {
            link.gpx(&gpx, indentationLevel: indentationLevel);
        }
        
        self.gpx(&gpx, addPropertyForValue: self.timeValue, defaultValue: "0", tagName: "time", indentationLevel: indentationLevel);
        self.gpx(&gpx, addPropertyForValue: keywords, tagName: "keywords", indentationLevel: indentationLevel);
        
        if let bounds = self.bounds {
            bounds.gpx(&gpx, indentationLevel: indentationLevel);
        }
        
        if let extensions = self.extensions {
            extensions.gpx(&gpx, indentationLevel: indentationLevel);
        }
    }
}

//
//  GPXLink.swift
//  GPX
//
//  Created by John Sklikas on 29/1/23.
//

import Foundation

/** A link to an external resource (Web page, digital photo, video clip, etc) with additional information.
 */
public class GPXLink: GPXElement {

    /// ---------------------------------
    /// @name Accessing Properties
    /// ---------------------------------

    /** Text of hyperlink. */
    public var text:String?

    /** Mime type of content (image/jpeg) */
    public var mimetype:String?

    /** URL of hyperlink. */
    public var href:String = "";


    /// ---------------------------------
    /// @name Create Link
    /// ---------------------------------

    //MARK: Instance
    required init(withXMLElement element: GPXXMLElement, parent: GPXElement? = nil) {
        super.init(withXMLElement: element, parent: parent);
        self.text = self.textForSingleChildElementNamed("text", xmlElement: element);
        self.mimetype = self.textForSingleChildElementNamed("type", xmlElement: element);
        self.href = self.valueOfAttributeNamed("href", xmlElement: element, required: true) ?? "";
    }
    
    required override public init(parent: GPXElement? = nil) {
        super.init(parent: parent);
    }
    
    
    /** Creates and returns a new link element.
     @param href URL of hyperlink
     @return A newly created link element.
     */
    public init(withHref href: String) {
        self.href = href;
        super.init()
    }
    
    //MARK: Tag
    override class func tagName() -> String? {
        return "link"
    }
    
    //MARK: GPX
    override func addOpenTagToGpx(_ gpx: inout String, indentationLevel: Int) {
        var attribute = "";
        let appendedHref = String(format: " href=\"%@\"", href);
        attribute.append(appendedHref);
        let appendedStr = String(format: "%@<%@%@>\r\n",
                                 self.indentForIndentationLevel(indentationLevel),
                                 type(of: self).tagName()!,
                                 attribute);
        gpx.append(appendedStr);
    }
    
    override func addChildTagToGpx(_ gpx: inout String, indentationLevel: Int) {
        super.addChildTagToGpx(&gpx, indentationLevel: indentationLevel);
        self.gpx(&gpx, addPropertyForValue: text, tagName: "text", indentationLevel: indentationLevel);
        self.gpx(&gpx, addPropertyForValue: mimetype, tagName: "type", indentationLevel: indentationLevel);
    }
}

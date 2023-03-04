//
//  GPXPerson.swift
//  GPX
//
//  Created by John Sklikas on 29/1/23.
//

import Foundation

/** A person or organization.
 */
public class GPXPerson: GPXElement {
    /// ---------------------------------
    /// @name Accessing Properties
    /// ---------------------------------
    /** Name of person or organization. */
    public var name: String?

    /** Email address. */
    public var email: GPXEmail?

    /** Link to Web site or other external information about person. */
    public var link: GPXLink?
    
    //MARK: Instance
    required init(withXMLElement element: GPXXMLElement, parent: GPXElement? = nil) {
        super.init(withXMLElement: element, parent: parent);
        self.name = self.textForSingleChildElementNamed("name", xmlElement: element);
        self.email = self.childElementOfClass(GPXEmail.self, xmlElement: element) as? GPXEmail
        self.link = self.childElementOfClass(GPXLink.self, xmlElement: element) as? GPXLink
        
    }
    
    //MARK: Tag
    override class func tagName() -> String? {
        return "person";
    }
    
    //MARK: GPX
    override func addChildTagToGpx(_ gpx: inout String, indentationLevel: Int) {
        super.addChildTagToGpx(&gpx, indentationLevel: indentationLevel);
        self.gpx(&gpx, addPropertyForValue: self.name, tagName: "name", indentationLevel: indentationLevel)
        
        if let email = self.email {
            email.gpx(&gpx, indentationLevel: indentationLevel);
        }
        if let link = self.link {
            link.gpx(&gpx, indentationLevel: indentationLevel);
        }
    }
}

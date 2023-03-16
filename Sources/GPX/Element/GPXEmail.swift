//
//  GPXEmail.swift
//  GPX
//
//  Created by John Sklikas on 29/1/23.
//

import Foundation

/** An email address. Broken into two parts (id and domain) to help prevent email harvesting.
 */
public class GPXEmail: GPXElement {

    /// ---------------------------------
    /// ** Accessing Properties
    /// ---------------------------------

    /** id half of email address (billgates2004) */
    var emailID: String?

    /** domain half of email address (hotmail.com) */
    var domain: String?


    /// ---------------------------------
    /// ** Create Email
    /// ---------------------------------
    
    required init(withXMLElement element: GPXXMLElement, parent: GPXElement? = nil) {
        super.init(withXMLElement: element, parent: parent)
        let emailIDStr = self.valueOfAttributeNamed("id", xmlElement: element, required: true);
        let domainStr = self.valueOfAttributeNamed("domain", xmlElement: element, required: true);
        self.emailID = emailIDStr
        self.domain = domainStr
    }
    
    required override init(parent: GPXElement? = nil) {
        super.init(parent: parent);
    }

    /**
     Creates and returns a new email element.
     - Parameters:
        - id: half of email address (billgates2004)
        - domain: half of email address (hotmail.com)
     - Returns: A newly created email element.
     */
    class public func emailWithID(_ emailID: String, domain: String) -> GPXEmail {
        let email = self.init()
        email.emailID = emailID;
        email.domain = domain;
        return email;
    }
    
    //MARK: Tag
    override class func tagName() -> String? {
        return "email";
    }
    
    //MARK: GPX
    override func addOpenTagToGpx(_ gpx: inout String, indentationLevel: Int) {
        var attribute = "";
        if let emailID = emailID {
            let appendedStr = String(format: " id=\"%@\"", emailID);
            attribute.append(appendedStr);
        }
        if let domain = domain {
            let appendedStr = String(format: " domain=\"%@\"", domain);
            attribute.append(appendedStr);
        }
        let appendedStr = String(format: "%@<%@%@>\r\n", self.indentForIndentationLevel(indentationLevel),
                                 type(of: self).tagName()!,
                                 attribute);
        gpx.append(appendedStr);
    }
    
}

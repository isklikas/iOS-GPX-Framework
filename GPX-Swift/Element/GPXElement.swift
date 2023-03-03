//
//  GPXElement.swift
//  GPX
//
//  Created by John Sklikas on 24/1/23.
//

import UIKit

/** GPXElement is the root class of GPX element hierarchies.
 */
class GPXElement: NSObject {
    
    //Element Properties
    
    /// ---------------------------------
    /// @name Accessing Element Properties
    /// ---------------------------------

    /** A parent GPXElement of the receiver.
     */
    var parent: GPXElement?
    
    //MARK: Tag
    class func tagName() -> String? {
        return nil;
    }
    
    class func implementClasses() -> [AnyObject]? {
        return nil;
    }
    
    //MARK: Instance
    
    required init(withXMLElement element: GPXXMLElement, parent: GPXElement? = nil) {
        self.parent = parent
        super.init();
    }
    
    init(parent: GPXElement? = nil) {
        self.parent = parent
        super.init();
    }
    
    //MARK: Elements
    func valueOfAttributeNamed(_ name: String, xmlElement: GPXXMLElement) -> String? {
        return self.valueOfAttributeNamed(name, xmlElement: xmlElement, required: false);
    }
    
    func valueOfAttributeNamed(_ name: String, xmlElement: GPXXMLElement, required: Bool) -> String? {
        let value = xmlElement.valueOfAttributeNamed(name);
        if (value == nil && required) {
            let description = "\(type(of: self).tagName() ?? "") element requires \(name) element."
            let notification = Notification(name: Notification.Name(kGPXInvalidGPXFormatNotification), object: self, userInfo: [kGPXDescriptionKey: description]);
            NotificationCenter.default.post(notification);
        }
        return value;
    }
    
    func textForSingleChildElementNamed(_ name: String, xmlElement element: GPXXMLElement) -> String? {
        return self.textForSingleChildElementNamed(name, xmlElement: element, required: false);
    }
    
    func textForSingleChildElementNamed(_ name: String, xmlElement element: GPXXMLElement, required: Bool) -> String? {
        if let childElement = element.childElementNamed(name) {
            return childElement.text
        }
        else {
            if (required) {
                let description = "\(type(of: self).tagName() ?? "") element requires \(name) attribute."
                let notification = Notification(name: Notification.Name(kGPXInvalidGPXFormatNotification), object: self, userInfo: [kGPXDescriptionKey: description]);
                NotificationCenter.default.post(notification);
            }
        }
        return nil;
    }
    
    func childElementOfClass(_ classRef: GPXElement.Type, xmlElement element: GPXXMLElement) -> GPXElement? {
        return self.childElementOfClass(classRef, xmlElement: element, required: false);
    }
    
    func childElementOfClass(_ classRef: GPXElement.Type, xmlElement element: GPXXMLElement, required: Bool) -> GPXElement? {
        var firstElement: GPXElement?
        if let tagName = classRef.tagName(),
           let childElement = element.childElementNamed(tagName) {
            firstElement = classRef.init(withXMLElement: childElement, parent: self)
            if childElement.nextSiblingNamed(tagName) != nil {
                let description = "\(type(of: self).tagName() ?? "") element has more than two \(tagName) elements."
                let notification = Notification(name: Notification.Name(kGPXInvalidGPXFormatNotification), object: self, userInfo: [kGPXDescriptionKey: description]);
                NotificationCenter.default.post(notification);
            }
        }
        
        if (required) {
            if (firstElement == nil) {
                let description = "\(type(of: self).tagName() ?? "") element requires \(classRef.tagName() ?? "") element."
                let notification = Notification(name: Notification.Name(kGPXInvalidGPXFormatNotification), object: self, userInfo: [kGPXDescriptionKey: description]);
                NotificationCenter.default.post(notification);
            }
        }
        
        return firstElement;
    }
    
    func childElementNamed(_ name: String, classRef: GPXElement.Type, xmlElement element: GPXXMLElement) -> GPXElement? {
        return self.childElementNamed(name, classRef: classRef, xmlElement: element, required: false);
    }
    
    func childElementNamed(_ name: String, classRef: GPXElement.Type, xmlElement element: GPXXMLElement, required: Bool) -> GPXElement? {
        var firstElement: GPXElement?
        if let childElement = element.childElementNamed(name) {
            firstElement = classRef.init(withXMLElement: childElement, parent: self);
            if childElement.nextSiblingNamed(name) != nil {
                let description = "\(type(of: self).tagName() ?? "") element has more than two \(classRef.tagName() ?? "") elements."
                let notification = Notification(name: Notification.Name(kGPXInvalidGPXFormatNotification), object: self, userInfo: [kGPXDescriptionKey: description]);
                NotificationCenter.default.post(notification);
            }
        }
        
        if (required) {
            if (firstElement == nil) {
                let description = "\(type(of: self).tagName() ?? "") element requires \(classRef.tagName() ?? "") element."
                let notification = Notification(name: Notification.Name(kGPXInvalidGPXFormatNotification), object: self, userInfo: [kGPXDescriptionKey: description]);
                NotificationCenter.default.post(notification);
            }
        }
        
        return firstElement;
    }
    
    func childElementsOfClass(_ classRef: GPXElement.Type, xmlElement element: GPXXMLElement) -> [GPXElement] {
        guard let elementChildren = element.children else {
            return [];
        }
        
        var childElements: [GPXElement] = [];
        if let tagName = classRef.tagName() {
            for childElement in elementChildren {
                if childElement.name == tagName {
                    let childGPXElement = classRef.init(withXMLElement: childElement, parent: self)
                    childElements.append(childGPXElement);
                }
            }
        }
        return childElements;
    }
    
    //MARK: GPX
    
    //Return the gpx generated by the receiver
    func gpx() -> String {
        var gpx = "";
        self.gpx(&gpx, indentationLevel: 0);
        return gpx;
    }
    
    func gpx(_ gpx: inout String, indentationLevel: Int) {
        self.addOpenTagToGpx(&gpx, indentationLevel: indentationLevel);
        self.addChildTagToGpx(&gpx, indentationLevel: indentationLevel);
        self.addCloseTagToGpx(&gpx, indentationLevel: indentationLevel);
    }
    
    func addOpenTagToGpx(_ gpx: inout String, indentationLevel: Int) {
        let appendedString = String(format: "%@<%@>\r\n",
                                    self.indentForIndentationLevel(indentationLevel),
                                    type(of: self).tagName() ?? "")
        gpx.append(appendedString);
    }
    
    func addChildTagToGpx(_ gpx: inout String, indentationLevel: Int) {
        // Override to subclasses
    }
    
    func addCloseTagToGpx(_ gpx: inout String, indentationLevel: Int) {
        let appendedString = String(format: "%@</%@>\r\n",
                                    self.indentForIndentationLevel(indentationLevel),
                                    type(of: self).tagName() ?? "")
        gpx.append(appendedString);
    }
    
    func gpx(_ gpx: inout String, addPropertyForValue value: String?, defaultValue: String? = nil, tagName: String, attribute: String? = nil, indentationLevel: Int) {
        if (value == nil || value == "") {
            return;
        }
        if (defaultValue != nil && value! == defaultValue) {
            return;
        }
        
        var outputCDMA = false;
        let match = value!.range(of: "[^a-zA-Z0-9.,+-/*!='\"()\\[\\]{}!$%@?_;: #\t\r\n]", options: .regularExpression);
        if (match != nil) {
            outputCDMA = true;
        }
        
        if outputCDMA {
            let updatedValue = value!.replacingOccurrences(of: "]]>", with: "]]&gt;")
            var returnedAttribute = "";
            if let attribute = attribute {
                returnedAttribute = " " + attribute;
            }
            let appendedString = String(format: "%@<%@%@><![CDATA[%@]]></%@>\r\n",
                                        self.indentForIndentationLevel(indentationLevel),
                                        tagName,
                                        returnedAttribute,
                                        updatedValue,
                                        tagName);
            gpx.append(appendedString)
        }
        else {
            var returnedAttribute = "";
            if let attribute = attribute {
                returnedAttribute = " " + attribute;
            }
            let appendedString = String(format: "%@<%@%@>%@</%@>\r\n",
                                        self.indentForIndentationLevel(indentationLevel),
                                        tagName,
                                        returnedAttribute,
                                        value!,
                                        tagName)
            gpx.append(appendedString)
        }
    }
    
    func indentForIndentationLevel(_ indentationLevel: Int) -> String {
        var result = "";
        for _ in 0..<indentationLevel {
            result = result + "\t";
        }
        return result;
    }

}

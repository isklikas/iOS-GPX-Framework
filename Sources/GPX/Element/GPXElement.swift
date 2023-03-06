//
//  GPXElement.swift
//  GPX
//
//  Created by John Sklikas on 24/1/23.
//

import Foundation
import CoreLocation

/** GPXElement is the root class of GPX element hierarchies.
 */
public class GPXElement: NSObject {
    
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
    
    required public init(withXMLElement element: GPXXMLElement, parent: GPXElement? = nil) {
        self.parent = parent
        super.init();
    }
    
    public init(parent: GPXElement? = nil) {
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
    
    //MARK: Calculations
    
    /**
     Used to calculate the course angle, in methods where CLLocation arrays are generated
     - Parameters:
        - lat1: The original point's latitude
        - lon1: The original point's longitude
        - lat2: The next point's latitude
        - lon2: The next point's longitude
     - Returns: The course angle (Double)
     */
    func getBearing(lat1: Double, lon1: Double, lat2: Double, lon2: Double) -> Double {
        let latitude1 = lat1.degToRadians();
        let latitude2 = lat2.degToRadians();
        let longDiff = (lon2 - lon1).degToRadians();
        let yParam = sin(longDiff) * cos(latitude2);
        let xParam = cos(latitude1) * sin(latitude2) - sin(latitude1) * cos(latitude2) * cos(longDiff);
        
        let bearingDegAngle = atan2(yParam, xParam).radToDegrees()
        let bearingAngle = (bearingDegAngle + 360).truncatingRemainder(dividingBy: 360);

        return bearingAngle
    }
    
    /**
     Used to calculate the speed, in methods where CLLocation arrays are generated
     - Parameters:
        - coordinates1: The original point's coordinates
        - time1: The original point's date
        - coordinates2: The next point's coordinates
        - time2: The next point's date
     - Returns: The course angle (Double)
     */
    func getSpeed(coordinates1: CLLocationCoordinate2D, time1: Date, coordinates2: CLLocationCoordinate2D, time2: Date) -> Double {
        
        // The location objects
        let location1 = CLLocation(latitude: coordinates1.latitude, longitude: coordinates1.longitude);
        let location2 = CLLocation(latitude: coordinates2.latitude, longitude: coordinates2.longitude);
        
        // In meters
        let distance = location2.distance(from: location1);
        
        // The times (in seconds)
        let seconds1 = time1.timeIntervalSince1970;
        let seconds2 = time2.timeIntervalSince1970;
        let timeDifference = seconds2 - seconds1;
        
        // The speed (in m/s)
        let speed = distance / timeDifference;
        return speed;
    }

}

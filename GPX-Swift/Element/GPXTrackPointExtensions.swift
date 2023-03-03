//
//  GPXTrackPointExtensions.swift
//  GPX
//
//  Created by John Sklikas on 12/2/23.
//

import UIKit

class GPXTrackPointExtensions: GPXElement {
    
    /* see: http://www8.garmin.com/xmlschemas/TrackPointExtensionv2.xsd */
    var heartRate: Int? {
        get {
            if let heartRateString = self.heartRateString {
                return GPXType.nonNegativeInteger(heartRateString);
            }
            return nil;
        }
        set(newValue) {
            if let newValue = newValue {
                self.heartRateString = String(newValue);
            }
            else {
                self.heartRateString = nil;
            }
        }
    }
    private var heartRateString: String?
    var cadence: Int? {
        get {
            if let cadenceString = self.cadenceString {
                return GPXType.nonNegativeInteger(cadenceString);
            }
            return nil;
        }
        set(newValue) {
            if let newValue = newValue {
                self.cadenceString = String(newValue);
            }
            else {
                self.cadenceString = nil;
            }
        }
    }
    private var cadenceString: String?
    var speed: Double? {
        get {
            if let speedString = self.speedString {
                return GPXType.decimal(speedString);
            }
            return nil;
        }
        set(newValue) {
            if let newValue = newValue {
                self.speedString = String(newValue);
            }
            else {
                self.speedString = nil;
            }
        }
    }
    private var speedString: String?
    var course: Double? {
        get {
            if let courseString = self.courseString {
                return GPXType.decimal(courseString);
            }
            return nil;
        }
        set(newValue) {
            if let newValue = newValue {
                self.courseString = String(newValue);
            }
            else {
                self.courseString = nil;
            }
        }
    }
    private var courseString: String?
    
    required init(withXMLElement element: GPXXMLElement, parent: GPXElement? = nil) {
        super.init(withXMLElement: element, parent: parent);
        self.heartRateString = self.textForSingleChildElementNamed("gpxtpx:hr", xmlElement: element);
        self.cadenceString = self.textForSingleChildElementNamed("gpxtpx:cad", xmlElement: element);
        self.speedString = self.textForSingleChildElementNamed("gpxtpx:speed", xmlElement: element);
        self.courseString = self.textForSingleChildElementNamed("gpxtpx:course", xmlElement: element)
    }
    
    //MARK: Tag
    
    override class func tagName() -> String? {
        return "gpxtpx:TrackPointExtension";
    }
    
    //MARK: GPX
    
    override func addChildTagToGpx(_ gpx: inout String, indentationLevel: Int) {
        super.addChildTagToGpx(&gpx, indentationLevel: indentationLevel);
        self.gpx(&gpx, addPropertyForValue: heartRateString, tagName: "gpxtpx:hr", indentationLevel: indentationLevel);
        self.gpx(&gpx, addPropertyForValue: cadenceString, tagName: "gpxtpx:cad", indentationLevel: indentationLevel);
        self.gpx(&gpx, addPropertyForValue: speedString, tagName: "gpxtpx:speed", indentationLevel: indentationLevel);
        self.gpx(&gpx, addPropertyForValue: courseString, tagName: "gpxtpx:course", indentationLevel: indentationLevel);
    }
}

//
//  GPXTrailsTrackPointExtensions.swift
//  GPX
//
//  Created by John Sklikas on 1/3/23.
//

import Foundation

public class GPXTrailsTrackPointExtensions: GPXElement {
    
    //Class Vars
    private let kElementHorizontalAcc = "trailsio:hacc";
    private let kElementVerticalAcc = "trailsio:vacc";
    private let kElementSteps = "trailsio:steps";
    private static let kTrackPointExtensionsTagName = "trailsio:TrackPointExtension";
    
    /* see: https://trails.io/GPX/1/0/trails_1.0.xsd */
    var horizontalAccuracy: Double? {
        get {
            if let horizontalAccuracyString = self.horizontalAccuracyString {
                return GPXType.decimal(horizontalAccuracyString);
            }
            return nil;
        }
        set (newValue) {
            if let newValue = newValue {
                self.horizontalAccuracyString = String(newValue);
            }
            else {
                self.horizontalAccuracyString = nil;
            }
        }
    }
    private var horizontalAccuracyString: String?
    var verticalAccuracy: Double? {
        get {
            if let verticalAccuracyString = self.verticalAccuracyString {
                return GPXType.decimal(verticalAccuracyString);
            }
            return nil;
        }
        set (newValue) {
            if let newValue = newValue {
                self.verticalAccuracyString = String(newValue);
            }
            else {
                self.verticalAccuracyString = nil;
            }
        }
    }
    private var verticalAccuracyString: String?
    var stepCount: Int? {
        get {
            if let stepCountString = self.stepCountString {
                return GPXType.nonNegativeInteger(stepCountString);
            }
            return nil;
        }
        set(newValue) {
            if let newValue = newValue {
                self.stepCountString = String(newValue);
            }
            else {
                self.stepCountString = nil;
            }
        }
    }
    private var stepCountString: String?

    required init(withXMLElement element: GPXXMLElement, parent: GPXElement? = nil) {
        super.init(withXMLElement: element, parent: parent);
        self.horizontalAccuracyString = self.textForSingleChildElementNamed(kElementHorizontalAcc, xmlElement: element);
        self.verticalAccuracyString = self.textForSingleChildElementNamed(kElementVerticalAcc, xmlElement: element);
        self.stepCountString = self.textForSingleChildElementNamed(kElementSteps, xmlElement: element);
    }
    
    //MARK: Tag
    override class func tagName() -> String? {
        return kTrackPointExtensionsTagName;
    }
    
    //MARK: GPX
    override func addChildTagToGpx(_ gpx: inout String, indentationLevel: Int) {
        super.addChildTagToGpx(&gpx, indentationLevel: indentationLevel);
        self.gpx(&gpx, addPropertyForValue: horizontalAccuracyString, tagName: kElementHorizontalAcc, indentationLevel: indentationLevel);
        self.gpx(&gpx, addPropertyForValue: verticalAccuracyString, tagName: kElementVerticalAcc, indentationLevel: indentationLevel);
        self.gpx(&gpx, addPropertyForValue: stepCountString, tagName: kElementSteps, indentationLevel: indentationLevel);
    }
}

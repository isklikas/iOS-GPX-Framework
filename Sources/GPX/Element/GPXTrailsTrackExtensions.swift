//
//  GPXTrailsTrackExtensions.swift
//  GPX
//
//  Created by John Sklikas on 1/3/23.
//

import Foundation

public class GPXTrailsTrackExtensions: GPXElement {
    
    /* see: https://trails.io/GPX/1/0/trails_1.0.xsd */
    private let kElementActivity = "trailsio:activity";
    
    var activityTypeString: String?
    
    required init(withXMLElement element: GPXXMLElement, parent: GPXElement? = nil) {
        super.init(withXMLElement: element, parent: parent);
        self.activityTypeString = self.textForSingleChildElementNamed(kElementActivity, xmlElement: element);
    }
    
    //MARK: Tag
    override class func tagName() -> String? {
        return "trailsio:TrackExtension";
    }
    
    //MARK: GPX
    override func addChildTagToGpx(_ gpx: inout String, indentationLevel: Int) {
        super.addChildTagToGpx(&gpx, indentationLevel: indentationLevel);
        self.gpx(&gpx, addPropertyForValue: activityTypeString, tagName: kElementActivity, indentationLevel: indentationLevel);
    }

}

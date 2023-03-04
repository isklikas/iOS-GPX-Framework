//
//  GPXExtensions.swift
//  GPX
//
//  Created by John Sklikas on 1/3/23.
//

import Foundation

/** You can add extend GPX by adding your own elements from another schema here.
 */
public class GPXExtensions: GPXElement {
    
    var garminExtensions: GPXTrackPointExtensions?
    var trailsTrackExtensions: GPXTrailsTrackExtensions?
    var trailsTrackPointExtensions: GPXTrailsTrackPointExtensions?
    
    //MARK: Instance
    required init(withXMLElement element: GPXXMLElement, parent: GPXElement? = nil) {
        super.init(withXMLElement: element, parent: parent);
        self.garminExtensions = self.childElementOfClass(GPXTrackPointExtensions.self, xmlElement: element) as? GPXTrackPointExtensions
        self.trailsTrackExtensions = self.childElementOfClass(GPXTrailsTrackExtensions.self, xmlElement: element) as? GPXTrailsTrackExtensions
        self.trailsTrackPointExtensions = self.childElementOfClass(GPXTrailsTrackPointExtensions.self, xmlElement: element) as? GPXTrailsTrackPointExtensions
    }
    
    //MARK: Tag
    override class func tagName() -> String? {
        return "extensions";
    }
    
    //MARK: GPX
    override func addChildTagToGpx(_ gpx: inout String, indentationLevel: Int) {
        super.addChildTagToGpx(&gpx, indentationLevel: indentationLevel);
    }

}

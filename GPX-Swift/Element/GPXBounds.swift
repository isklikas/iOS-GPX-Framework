//
//  GPXBounds.swift
//  GPX
//
//  Created by John Sklikas on 11/2/23.
//

import UIKit
import CoreLocation

/** Two lat/lon pairs defining the extent of an element.
 */
class GPXBounds: GPXElement {
    /// ---------------------------------
    /// @name Accessing Properties
    /// ---------------------------------

    /** The minimum latitude. */
    var minLatitude: CLLocationDegrees?

    /** The minimum longitude. */
    var minLongitude: CLLocationDegrees?

    /** The maximum latitude. */
    var maxLatitude: CLLocationDegrees?

    /** The maximum longitude. */
    var maxLongitude: CLLocationDegrees?
    
    //MARK: Instance

    /// ---------------------------------
    /// @name Create Bounds
    /// ---------------------------------

    /** Creates and returns a new bounds element.
     @param minLatitude The minimum latitude.
     @param minLongitude The minimum longitude.
     @param maxLatitude The maximum latitude.
     @param maxLongitude The maximum longitude.
     @return A newly created bounds element.
     */
    init(minLatitude: CLLocationDegrees? = nil, minLongitude: CLLocationDegrees? = nil, maxLatitude: CLLocationDegrees? = nil, maxLongitude: CLLocationDegrees? = nil) {
        self.minLatitude = minLatitude
        self.minLongitude = minLongitude
        self.maxLatitude = maxLatitude
        self.maxLongitude = maxLongitude
        super.init()
    }
    
    required init(withXMLElement element: GPXXMLElement, parent: GPXElement? = nil) {
        super.init(withXMLElement: element, parent: parent)
        if let minLatitudeValue = self.valueOfAttributeNamed("minlat", xmlElement: element, required: true) {
            minLatitude = GPXType.latitude(minLatitudeValue)
        }
        if let minLongitudeValue = self.valueOfAttributeNamed("minlon", xmlElement: element, required: true) {
            minLongitude = GPXType.longitude(minLongitudeValue)
        }
        if let maxLatitudeValue = self.valueOfAttributeNamed("maxlat", xmlElement: element, required: true) {
            maxLatitude = GPXType.latitude(maxLatitudeValue)
        }
        if let maxLongitudeValue = self.valueOfAttributeNamed("maxlon", xmlElement: element, required: true) {
            maxLongitude = GPXType.longitude(maxLongitudeValue)
        }
    }
    
    //MARK: Tag
    override class func tagName() -> String? {
        return "bounds"
    }
    
    //MARK: GPX
    override func addOpenTagToGpx(_ gpx: inout String, indentationLevel: Int) {
        var attribute = "";
        if minLatitude != nil {
            let minLatitudeValue = GPXType.valueForLatitude(minLatitude!)
            let appendedStr = String(format: " minlat=\"%@\"", minLatitudeValue);
            attribute.append(appendedStr);
        }
        if minLongitude != nil {
            let minLongitudeValue = GPXType.valueForLongitude(minLongitude!)
            let appendedStr = String(format: " minlon=\"%@\"", minLongitudeValue);
            attribute.append(appendedStr);
        }
        if maxLatitude != nil {
            let maxLatitudeValue = GPXType.valueForLatitude(maxLatitude!)
            let appendedStr = String(format: " maxlat=\"%@\"", maxLatitudeValue);
            attribute.append(appendedStr);
        }
        if maxLongitude != nil {
            let maxLongitudeValue = GPXType.valueForLongitude(maxLongitude!)
            let appendedStr = String(format: " maxlon=\"%@\"", maxLongitudeValue);
            attribute.append(appendedStr);
        }
        let appendedStr = String(format: "%@<%@%@>\r\n",
                                 self.indentForIndentationLevel(indentationLevel),
                                 type(of: self).tagName()!,
                                 attribute);
        gpx.append(appendedStr);
    }
}

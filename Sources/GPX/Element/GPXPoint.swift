//
//  GPXPoint.swift
//  GPX
//
//  Created by John Sklikas on 29/1/23.
//

import Foundation
import CoreLocation

/** A geographic point with optional elevation and time. Available for use by other schemas.
 */
public class GPXPoint: GPXElement {
    /// ---------------------------------
    /// ** Accessing Properties
    /// ---------------------------------

    /** The elevation (in meters) of the point. */
    var elevation: CLLocationDistance?

    /** The time that the point was recorded. */
    var time: Date?

    /** The latitude of the point. Decimal degrees, WGS84 datum */
    var latitude: CLLocationDegrees?

    /** The longitude of the point. Decimal degrees, WGS84 datum. */
    var longitude: CLLocationDegrees?
    
    //MARK: Instance
    
    /// ---------------------------------
    /// ** Create Point
    /// ---------------------------------
    
    required init(withXMLElement element: GPXXMLElement, parent: GPXElement? = nil) {
        super.init(withXMLElement: element, parent: parent);
        if let elevationValue = self.textForSingleChildElementNamed("ele", xmlElement: element) {
            self.elevation = GPXType.decimal(elevationValue);
        }
        if let timeValue = self.textForSingleChildElementNamed("time", xmlElement: element) {
            self.time = GPXType.dateTime(timeValue);
        }
        if let latitudeValue = self.valueOfAttributeNamed("lat", xmlElement: element, required: true) {
            self.latitude = GPXType.latitude(latitudeValue);
        }
        if let longitudeValue = self.valueOfAttributeNamed("lon", xmlElement: element, required: true) {
            self.longitude = GPXType.longitude(longitudeValue);
        }
    }
    
    override required public init(parent: GPXElement? = nil) {
        super.init(parent: parent);
    }

    /**
     Creates and returns a new point element.
     - Parameters:
        - latitude: The latitude of the point.
        - longitude: The longitude of the point.
     - Returns: A newly created point element.
     */
    public init(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        self.latitude = latitude;
        self.longitude = longitude;
        super.init()
    }
    
    /** Creates and returns a new waypoint element.
     - Parameter location: The location of the object.
     - Returns: A newly created waypoint element.
     */
    public init(location: CLLocation) {
        let latitude = location.coordinate.latitude;
        let longitude = location.coordinate.longitude;
        let altitude = location.altitude;
        let date = location.timestamp;
        super.init();
        self.latitude = latitude;
        self.longitude = longitude;
        self.elevation = altitude;
        self.time = date;
    }
    
    /// The location parsed by the properties of the Waypoint
    public func location() -> CLLocation? {
        //Obviously these two are needed for the location to exist.
        guard let longitude = self.longitude,
              let latitude = self.latitude else {
                  return nil;
        }
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude);
        guard let altitude = self.elevation else {
            return CLLocation(latitude: latitude, longitude: longitude);
        }
        guard let timeStamp = self.time else {
            return CLLocation(coordinate: coordinate, altitude: altitude, horizontalAccuracy: kCLLocationAccuracyBestForNavigation, verticalAccuracy: kCLLocationAccuracyBestForNavigation, timestamp: Date())
        }
        return CLLocation(coordinate: coordinate, altitude: altitude, horizontalAccuracy: kCLLocationAccuracyBestForNavigation, verticalAccuracy: kCLLocationAccuracyBestForNavigation, timestamp: timeStamp);
    }
    
    /// The coordinates parsed by the properties of the Waypoint
    public func coordinates() -> CLLocationCoordinate2D? {
        //Obviously these two are needed for the coordinates to exist.
        guard let longitude = self.longitude,
              let latitude = self.latitude else {
                  return nil;
        }
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude);
        return coordinate;
    }
    
    //MARK: Tag
    override class func tagName() -> String? {
        return "pt";
    }
    
    //MARK: GPX
    override func addOpenTagToGpx(_ gpx: inout String, indentationLevel: Int) {
        var attribute = "";
        if let latitude = self.latitude {
            let latitudeValue = GPXType.valueForLatitude(latitude)
            let appendedStr = String(format: " lat=\"%@\"", latitudeValue);
            attribute.append(appendedStr);
        }
        if let longitude = self.longitude {
            let longitudeValue = GPXType.valueForLongitude(longitude)
            let appendedStr = String(format: " lon=\"%@\"", longitudeValue);
            attribute.append(appendedStr);
        }
        let appendedStr = String(format: "%@<%@%@>\r\n",
                                 self.indentForIndentationLevel(indentationLevel),
                                 type(of: self).tagName()!,
                                 attribute);
        gpx.append(appendedStr);
    }
    
    override func addChildTagToGpx(_ gpx: inout String, indentationLevel: Int) {
        super.addChildTagToGpx(&gpx, indentationLevel: indentationLevel);
        var elevationValue: String?
        var timeValue: String?
        if let elevation = self.elevation {
            elevationValue = GPXType.valueForDecimal(elevation)
        }
        if let time = self.time {
            timeValue = GPXType.valueForDateTime(time);
        }
        self.gpx(&gpx, addPropertyForValue: elevationValue, tagName: "ele", indentationLevel: indentationLevel)
        self.gpx(&gpx, addPropertyForValue: timeValue, tagName: "time", indentationLevel: indentationLevel)
    }
    
}

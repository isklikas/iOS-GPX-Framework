//
//  GPXPointSegment.swift
//  GPX
//
//  Created by John Sklikas on 11/2/23.
//

import Foundation
import CoreLocation

/** An ordered sequence of points. (for polygons or polylines, e.g.)
 */
public class GPXPointSegment: GPXElement {
    /// ---------------------------------
    /// @name Accessing Properties
    /// ---------------------------------

    /** Ordered list of geographic points. */
    var points: [GPXPoint] = [];
    
    //MARK: Instance
    required override init(parent: GPXElement? = nil) {
        super.init()
    }
    
    required init(withXMLElement element: GPXXMLElement, parent: GPXElement? = nil) {
        super.init(withXMLElement: element, parent: parent)
        let childElements = self.childElementsOfClass(GPXPoint.self, xmlElement: element) as! [GPXPoint]
        points = childElements;
    }
    
    //MARK: Public methods
    
    /// ---------------------------------
    /// @name Creating Point
    /// ---------------------------------

    /** Creates and returns a new point element.
     @param latitude The latitude of the point.
     @param longitude The longitude of the point.
     @return A newly created point element.
     */
    func newPoint(withLatitude latitude: CGFloat, longitude: CGFloat) -> GPXPoint {
        let point = GPXPoint(latitude: latitude, longitude: longitude);
        self.addPoint(point)
        return point
    }
    
    /** Creates and returns a new point element.
     @param location The location of the point.
     @return A newly created point element.
     */
    func newPoint(withLocation location: CLLocation) -> GPXPoint {
        let point = GPXPoint(location: location);
        self.addPoint(point)
        return point
    }
    
    
    /// ---------------------------------
    /// @name Adding Point
    /// ---------------------------------

    /** Inserts a given GPXPoint object at the end of the point array.
     @param point The GPXPoint to add to the end of the point array.
     */
    func addPoint(_ point: GPXPoint?) {
        if let point = point,
           points.firstIndex(of: point) == nil {
            point.parent = self;
            points.append(point)
        }
    }
    
    /** Adds the GPXPoint objects contained in another given array to the end of the point array.
     @param array An array of GPXPoint objects to add to the end of the point array.
     */
    func addPoints(_ array: [GPXPoint]) {
        for point in array {
            self.addPoint(point);
        }
    }
    
    
    /// ---------------------------------
    /// @name Removing Point
    /// ---------------------------------
    
    /** Removes all occurrences in the point array of a given GPXPoint object.
     @param point The GPXPoint object to remove from the point array.
     */
    func removePoint(_ point: GPXPoint) {
        if let index = points.firstIndex(of: point) {
            point.parent = nil;
            points.remove(at: index)
        }
    }
    
    /// ---------------------------------
    /// @name Returning Transformed Data
    /// ---------------------------------
    
    /** Returns an array of locations from the points array.
     ** Important: This is in cases where altitude and time are both set and needed.
     */
    public func locations() -> [CLLocation] {
        var locations: [CLLocation] = [];
        for point in points {
            if let latitude = point.latitude,
               let longitude = point.longitude,
               let altitde = point.elevation,
               let date = point.time
            {
                let location = CLLocation(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), altitude: altitde, horizontalAccuracy: kCLLocationAccuracyBestForNavigation, verticalAccuracy: kCLLocationAccuracyBestForNavigation, timestamp: date);
                locations.append(location);
            }
        }
        return locations;
    }
    
    /** Returns an array of coordinates from the points array.
     */
    public func coordinates() -> [CLLocationCoordinate2D] {
        var locations: [CLLocationCoordinate2D] = [];
        for point in points {
            if let latitude = point.latitude,
               let longitude = point.longitude
            {
                let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                locations.append(location);
            }
        }
        return locations;
    }
    
    //MARK: Tag
    override class func tagName() -> String? {
        return "ptseg";
    }
    
    //MARK: GPX
    
    override func addChildTagToGpx(_ gpx: inout String, indentationLevel: Int) {
        super.addChildTagToGpx(&gpx, indentationLevel: indentationLevel)
        
        for point in points {
            point.gpx(&gpx, indentationLevel: indentationLevel)
        }
    }

}

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
    required override public init(parent: GPXElement? = nil) {
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
    public func newPoint(withLatitude latitude: CGFloat, longitude: CGFloat) -> GPXPoint {
        let point = GPXPoint(latitude: latitude, longitude: longitude);
        self.addPoint(point)
        return point
    }
    
    /** Creates and returns a new point element.
     @param location The location of the point.
     @return A newly created point element.
     */
    public func newPoint(withLocation location: CLLocation) -> GPXPoint {
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
    public func addPoint(_ point: GPXPoint?) {
        if let point = point,
           points.firstIndex(of: point) == nil {
            point.parent = self;
            points.append(point)
        }
    }
    
    /** Adds the GPXPoint objects contained in another given array to the end of the point array.
     @param array An array of GPXPoint objects to add to the end of the point array.
     */
    public func addPoints(_ array: [GPXPoint]) {
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
    public func removePoint(_ point: GPXPoint) {
        if let index = points.firstIndex(of: point) {
            point.parent = nil;
            points.remove(at: index)
        }
    }
    
    /// ---------------------------------
    /// @name Returning Transformed Data
    /// ---------------------------------
    
    /** Returns an array of locations from the points array.
     */
    public func locations() -> [CLLocation] {
        var locations: [CLLocation] = [];
        for k in 0 ..< points.count {
            let point = points[k];
            
            // Latitude and Longitude parsing
            guard let latitude = point.latitude,
                  let longitude = point.longitude else {
                continue;
            }
            // The coordinates parsed
            let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude);
            
            // With latitude and longitude set, it is possible to calculate
            // the course angle by iterating through the next object
            var courseAngle: Double = 0;
            let l = k + 1;
            var hasNextObject = false;
            
            if (l < points.count) {
                // There is a next object
                hasNextObject = true;
                let point2 = points[l];
                if let latitude2 = point2.latitude,
                   let longitude2 = point2.longitude {
                    courseAngle = self.getBearing(lat1: latitude, lon1: longitude, lat2: latitude2, lon2: longitude2)
                }
            }
            else {
                // This is the last object
                let previousPoint = locations[k-1];
                courseAngle = previousPoint.course;
            }
            
            // Altitude variable
            var altitude: Double = 0;
            
            if let elevation = point.elevation {
                altitude = elevation;
            }
            
            guard let currentTime = point.time else {
                let location = CLLocation(coordinate: coordinates, altitude: altitude, horizontalAccuracy: kCLLocationAccuracyBestForNavigation, verticalAccuracy: kCLLocationAccuracyBestForNavigation, course: courseAngle, speed: 0, timestamp: Date())
                locations.append(location);
                continue;
            }
            
            if !hasNextObject {
                // This is the last object
                let previousPoint = locations[k-1];
                let previousSpeed = previousPoint.speed;
                
                // Location object
                let location = CLLocation(coordinate: coordinates, altitude: altitude, horizontalAccuracy: kCLLocationAccuracyBestForNavigation, verticalAccuracy: kCLLocationAccuracyBestForNavigation, course: courseAngle, speed: previousSpeed, timestamp: currentTime);
                locations.append(location);
            }
            else {
                // Speed in m/s
                var speed: Double = 0;
                
                let nextPoint = points[l];
                if let nextLatitude = nextPoint.latitude,
                   let nextLongitude = nextPoint.longitude,
                   let nextTime = nextPoint.time {
                    let nextCoordinates = CLLocationCoordinate2D(latitude: nextLatitude, longitude: nextLongitude);
                    
                    speed = self.getSpeed(coordinates1: coordinates, time1: currentTime, coordinates2: nextCoordinates, time2: nextTime);
                }
                
                let location = CLLocation(coordinate: coordinates, altitude: altitude, horizontalAccuracy: kCLLocationAccuracyBestForNavigation, verticalAccuracy: kCLLocationAccuracyBestForNavigation, course: courseAngle, speed: speed, timestamp: currentTime);
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

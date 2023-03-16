//
//  GPXTrackSegment.swift
//  GPX
//
//  Created by John Sklikas on 2/3/23.
//

import Foundation
import CoreLocation

/** A Track Segment holds a list of Track Points which are logically connected in order.
    To represent a single GPS track where GPS reception was lost, or the GPS receiver was turned off, start a new Track Segment for each continuous span of track data.
 */
public class GPXTrackSegment: GPXElement {
    
    /// ---------------------------------
    /// ** Accessing Properties
    /// ---------------------------------

    /** A Track Point holds the coordinates, elevation, timestamp, and metadata for a single point in a track. */
    var trackpoints: [GPXTrackPoint] = [];

    /** You can add extend GPX by adding your own elements from another schema here. */
    public var extensions: GPXExtensions?
    
    //MARK: Instance
    
    override public init(parent: GPXElement? = nil) {
        super.init(parent: parent);
    }
    
    required init(withXMLElement element: GPXXMLElement, parent: GPXElement? = nil) {
        super.init(withXMLElement: element, parent: parent)
        extensions = self.childElementOfClass(GPXExtensions.self, xmlElement: element) as? GPXExtensions
        trackpoints = self.childElementsOfClass(GPXTrackPoint.self, xmlElement: element) as! [GPXTrackPoint];
    }


    /// ---------------------------------
    /// ** Creating Trackpoint
    /// ---------------------------------

    /**
     Creates and returns a new trackpoint element.
     - Parameters:
        - latitude: The latitude of the point.
        - longitude: The longitude of the point.
     - Returns: A newly created trackpoint element.
     */
    public func newTrackpoint(withLatitude latitude: Double, longitude: Double) -> GPXTrackPoint {
        let trackpoint = GPXTrackPoint(latitude: latitude, longitude: longitude);
        self.addTrackpoint(trackpoint);
        return trackpoint;
    }
    
    /**
     Creates and returns a new trackpoint element.
     - Parameter location: The location of the point.
     - Returns: A newly created trackpoint element.
     */
    public func newTrackpoint(withLocation location: CLLocation) -> GPXTrackPoint {
        let trackpoint = GPXTrackPoint(location: location);
        self.addTrackpoint(trackpoint);
        return trackpoint;
    }


    /// ---------------------------------
    /// ** Adding Trackpoint
    /// ---------------------------------

    /**
     Inserts a given GPXTrackPoint object at the end of the trackpoint array.
     - Parameter trackpoint: The GPXTrackPoint to add to the end of the trackpoint array.
     */
    public func addTrackpoint(_ trackpoint: GPXTrackPoint) {
        if (trackpoints.firstIndex(of: trackpoint) == nil) {
            trackpoint.parent = self;
            trackpoints.append(trackpoint);
        }
    }

    /**
     Adds the GPXTrackPoint objects contained in another given array to the end of the trackpoint array.
     - Parameter array: An array of GPXTrackPoint objects to add to the end of the trackpoint array.
     */
    public func addTrackpoints(_ trackpoints: [GPXTrackPoint]) {
        for trackpoint in trackpoints {
            self.addTrackpoint(trackpoint);
        }
    }

    /// ---------------------------------
    /// ** Removing Trackpoint
    /// ---------------------------------

    /**
     Removes all occurrences in the trackpoint array of a given GPXTrackPoint object.
     - Parameter trackpoint: The GPXTrackPoint object to remove from the trackpoint array.
     */
    public func removeTrackpoint(_ trackpoint: GPXTrackPoint) {
        if let tIndex = trackpoints.firstIndex(of: trackpoint) {
            trackpoint.parent = nil;
            trackpoints.remove(at: tIndex);
        }
    }
    
    /// ---------------------------------
    /// ** Returning Transformed Data
    /// ---------------------------------
    
    /** Returns an array of locations from the points array.
     */
    
   public func locations() -> [CLLocation] {
       var locations: [CLLocation] = [];
       for k in 0 ..< trackpoints.count {
           let point = trackpoints[k];
           
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
           
           if (l < trackpoints.count) {
               // There is a next object
               hasNextObject = true;
               let point2 = trackpoints[l];
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
               
               let nextPoint = trackpoints[l];
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
        for point in trackpoints {
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
        return "trkseg";
    }
    
    //MARK: GPX
    override func addChildTagToGpx(_ gpx: inout String, indentationLevel: Int) {
        super.addChildTagToGpx(&gpx, indentationLevel: indentationLevel);
        
        self.extensions?.gpx(&gpx, indentationLevel: indentationLevel);
        for trackpoint in trackpoints {
            trackpoint.gpx(&gpx, indentationLevel: indentationLevel)
        }
    }
}

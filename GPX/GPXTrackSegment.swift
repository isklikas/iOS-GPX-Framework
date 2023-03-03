//
//  GPXTrackSegment.swift
//  GPX
//
//  Created by John Sklikas on 2/3/23.
//

import UIKit

/** A Track Segment holds a list of Track Points which are logically connected in order.
    To represent a single GPS track where GPS reception was lost, or the GPS receiver was turned off, start a new Track Segment for each continuous span of track data.
 */
class GPXTrackSegment: GPXElement {
    
    /// ---------------------------------
    /// @name Accessing Properties
    /// ---------------------------------

    /** A Track Point holds the coordinates, elevation, timestamp, and metadata for a single point in a track. */
    var trackpoints: [GPXTrackPoint] = [];

    /** You can add extend GPX by adding your own elements from another schema here. */
    var extensions: GPXExtensions?
    
    //MARK: Instance
    
    override init(parent: GPXElement? = nil) {
        super.init(parent: parent);
    }
    
    required init(withXMLElement element: GPXXMLElement, parent: GPXElement? = nil) {
        super.init(withXMLElement: element, parent: parent)
        extensions = self.childElementOfClass(GPXExtensions.self, xmlElement: element) as? GPXExtensions
        trackpoints = self.childElementsOfClass(GPXTrackPoint.self, xmlElement: element) as! [GPXTrackPoint];
    }


    /// ---------------------------------
    /// @name Creating Trackpoint
    /// ---------------------------------

    /** Creates and returns a new trackpoint element.
     @param latitude The latitude of the point.
     @param longitude The longitude of the point.
     @return A newly created trackpoint element.
     */
    func newTrackpoint(withLatitude latitude: Double, longitude: Double) -> GPXTrackPoint {
        let trackpoint = GPXTrackPoint(latitude: latitude, longitude: longitude);
        self.addTrackpoint(trackpoint);
        return trackpoint;
    }


    /// ---------------------------------
    /// @name Adding Trackpoint
    /// ---------------------------------

    /** Inserts a given GPXTrackPoint object at the end of the trackpoint array.
     @param trackpoint The GPXTrackPoint to add to the end of the trackpoint array.
     */
    func addTrackpoint(_ trackpoint: GPXTrackPoint) {
        if (trackpoints.firstIndex(of: trackpoint) == nil) {
            trackpoint.parent = self;
            trackpoints.append(trackpoint);
        }
    }

    /** Adds the GPXTrackPoint objects contained in another given array to the end of the trackpoint array.
     @param array An array of GPXTrackPoint objects to add to the end of the trackpoint array.
     */
    func addTrackpoints(_ trackpoints: [GPXTrackPoint]) {
        for trackpoint in trackpoints {
            self.addTrackpoint(trackpoint);
        }
    }

    /// ---------------------------------
    /// @name Removing Trackpoint
    /// ---------------------------------

    /** Removes all occurrences in the trackpoint array of a given GPXTrackPoint object.
     @param trackpoint The GPXTrackPoint object to remove from the trackpoint array.
     */
    func removeTrackpoint(_ trackpoint: GPXTrackPoint) {
        if let tIndex = trackpoints.firstIndex(of: trackpoint) {
            trackpoint.parent = nil;
            trackpoints.remove(at: tIndex);
        }
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

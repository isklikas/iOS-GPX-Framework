//
//  GPXTrack.swift
//  GPX
//
//  Created by John Sklikas on 2/3/23.
//

import Foundation

/** trk represents a track - an ordered list of points describing a path.
 */
public class GPXTrack: GPXElement {
    
    /// ---------------------------------
    /// @name Accessing Properties
    /// ---------------------------------

    /** GPS name of track. */
    var name: String?

    /** GPS comment for track. */
    var comment: String?

    /** User description of track. */
    var desc: String?

    /** Source of data. Included to give user some idea of reliability and accuracy of data. */
    var source: String?

    /** Links to external information about track. */
    var links: [GPXLink] = [];

    /** GPS track number. */
    var number: Int? {
        get {
            if let numberValue = numberValue {
                return GPXType.nonNegativeInteger(numberValue)
            }
            return nil;
        }
        set {
            if let newValue = newValue {
                numberValue = GPXType.valueForNonNegativeInteger(newValue);
            }
            else {
                numberValue = nil;
            }
        }
    }
    private var numberValue: String?

    /** Type (classification) of track. */
    var type: String?

    /** You can add extend GPX by adding your own elements from another schema here. */
    var extensions: GPXExtensions?

    /** A Track Segment holds a list of Track Points which are logically connected in order.
        To represent a single GPS track where GPS reception was lost, or the GPS receiver was turned off,
        start a new Track Segment for each continuous span of track data. */
    var tracksegments: [GPXTrackSegment] = [];
    
    //MARK: Instance
    required init(withXMLElement element: GPXXMLElement, parent: GPXElement? = nil) {
        super.init(withXMLElement: element, parent: parent);
        name = self.textForSingleChildElementNamed("name", xmlElement: element);
        comment = self.textForSingleChildElementNamed("cmt", xmlElement: element);
        desc = self.textForSingleChildElementNamed("desc", xmlElement: element);
        source = self.textForSingleChildElementNamed("src", xmlElement: element);
        
        links = self.childElementsOfClass(GPXLink.self, xmlElement: element) as! [GPXLink];
        
        numberValue = self.textForSingleChildElementNamed("number", xmlElement: element);
        type = self.textForSingleChildElementNamed("type", xmlElement: element);
        extensions = self.childElementOfClass(GPXExtensions.self, xmlElement: element) as? GPXExtensions
        
        tracksegments = self.childElementsOfClass(GPXTrackSegment.self, xmlElement: element) as! [GPXTrackSegment]
    }
    
    override init(parent: GPXElement? = nil) {
        super.init(parent: parent);
    }
    
    /// ---------------------------------
    /// @name Creating Link
    /// ---------------------------------

    /** Creates and returns a new link element.
     @param href URL of hyperlink
     @return A newly created link element.
     */
    func newLink(withHref href: String) -> GPXLink {
        let link = GPXLink(withHref: href);
        self.addLink(link);
        return link;
    }
    
    /// ---------------------------------
    /// @name Adding Link
    /// ---------------------------------

    /** Inserts a given GPXLink object at the end of the link array.
     @param link The GPXLink to add to the end of the link array.
     */
    func addLink(_ link: GPXLink) {
        let index = links.firstIndex(of: link);
        if (index == nil) {
            link.parent = self;
            links.append(link);
        }
    }
    
    /** Adds the GPXLink objects contained in another given array to the end of the link array.
     @param array An array of GPXLink objects to add to the end of the link array.
     */
    func addLinks(_ links: [GPXLink]) {
        for link in links {
            self.addLink(link);
        }
    }
    
    /// ---------------------------------
    /// @name Removing Link
    /// ---------------------------------

    /** Removes all occurrences in the link array of a given GPXLink object.
     @param link The GPXLink object to remove from the link array.
     */
    func removeLink(_ link: GPXLink) {
        if let index = links.firstIndex(of: link) {
            link.parent = nil;
            links.remove(at: index);
        }
    }
    
    /// ---------------------------------
    /// @name Creating Tracksegment
    /// ---------------------------------

    /** Creates and returns a new tracksegment element.
     @return A newly created tracksegment element.
     */
    func newTrackSegment() -> GPXTrackSegment {
        let trackSegment = GPXTrackSegment();
        self.addTracksegment(trackSegment);
        return trackSegment;
    }
    
    /// ---------------------------------
    /// @name Adding Tracksegment
    /// ---------------------------------

    /** Inserts a given GPXTrackSegment object at the end of the tracksegment array.
     @param tracksegment The GPXTrackSegment to add to the end of the tracksegment array.
     */
    func addTracksegment(_ tracksegment: GPXTrackSegment) {
        let index = tracksegments.firstIndex(of: tracksegment);
        if (index == nil) {
            tracksegment.parent = self;
            tracksegments.append(tracksegment);
        }
    }
    
    /** Adds the GPXTrackSegment objects contained in another given array to the end of the tracksegment array.
     @param array An array of GPXTrackSegment objects to add to the end of the tracksegment array.
     */
    func addTracksegments(_ tracksegments: [GPXTrackSegment]) {
        for tracksegment in tracksegments {
            self.addTracksegment(tracksegment);
        }
    }
    
    /// ---------------------------------
    /// @name Removing Tracksegment
    /// ---------------------------------

    /** Removes all occurrences in the tracksegment array of a given GPXTrackSegment object.
     @param tracksegment The GPXTrackSegment object to remove from the tracksegment array.
     */
    func removeTracksegment(_ tracksegment: GPXTrackSegment) {
        if let index = tracksegments.firstIndex(of: tracksegment) {
            tracksegment.parent = nil;
            tracksegments.remove(at: index);
        }
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
        
        var newTrackSegment: GPXTrackSegment?
        
        // create a new segment if needed
        if (tracksegments.count == 0) {
            newTrackSegment = self.newTrackSegment();
        }
        else {
            newTrackSegment = tracksegments.last;
        }
        
        return newTrackSegment!.newTrackpoint(withLatitude: latitude, longitude: longitude);
    }
    
    //MARK: Tag
    override class func tagName() -> String? {
        return "trk";
    }
    
    //MARK: GPX
    override func addChildTagToGpx(_ gpx: inout String, indentationLevel: Int) {
        super.addChildTagToGpx(&gpx, indentationLevel: indentationLevel)
        
        self.gpx(&gpx, addPropertyForValue: name, tagName: "name", indentationLevel: indentationLevel);
        self.gpx(&gpx, addPropertyForValue: comment, tagName: "cmt", indentationLevel: indentationLevel);
        self.gpx(&gpx, addPropertyForValue: desc, tagName: "desc", indentationLevel: indentationLevel);
        self.gpx(&gpx, addPropertyForValue: source, tagName: "src", indentationLevel: indentationLevel);
        
        for link in self.links {
            link.gpx(&gpx, indentationLevel: indentationLevel);
        }
        
        self.gpx(&gpx, addPropertyForValue: numberValue, tagName: "number", indentationLevel: indentationLevel);
        self.gpx(&gpx, addPropertyForValue: type, tagName: "type", indentationLevel: indentationLevel);
        
        if let extensions = self.extensions {
            extensions.gpx(&gpx, indentationLevel: indentationLevel);
        }
        
        for trackSegment in self.tracksegments {
            trackSegment.gpx(&gpx, indentationLevel: indentationLevel);
        }
    }
    
}

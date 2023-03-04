//
//  GPXRoot.swift
//  GPX
//
//  Created by John Sklikas on 29/1/23.
//

import Foundation

/** GPX is the root element in the XML file.
    GPX documents contain a metadata header, followed by waypoints, routes, and tracks.
    You can add your own elements to the extensions section of the GPX document.
 */
public class GPXRoot: GPXElement {
    
    /// ---------------------------------
    /// @name Accessing Properties
    /// ---------------------------------

    /** The namespace for external XML schemas. */
    let schema = "http://www.topografix.com/GPX/1/1"

    /** You must include the version number in your GPX document. */
    var version: String = "1.1"

    /** You must include the name or URL of the software that created your GPX document.
        This allows others to inform the creator of a GPX instance document that fails to validate. */
    public var creator: String = "isklikas"

    /** Metadata about the file. */
    public var metadata: GPXMetadata?

    /** Keywords for indexing the GPX file with search engines. Will be comma separated. */
    public var keywords: [String]?

    /** A list of waypoints. */
    public var waypoints: [GPXWaypoint] = [];

    /** A list of routes. */
    public var routes: [GPXRoute] = [];

    /** A list of tracks. */
    public var tracks: [GPXTrack] = [];

    /** You can extend GPX by adding your own elements from another schema here. */
    public var extensions: GPXExtensions?
    
    //MARK: Instance
    
    /// ---------------------------------
    /// @name Create Root Element
    /// ---------------------------------

    /** Creates and returns a new root element.
     @param creator The name or URL of the software.
     @return A newly created root element.
     */
    public init(withCreator creator: String) {
        super.init();
        self.creator = creator;
    }
    
    required public init(withXMLElement element: GPXXMLElement, parent: GPXElement? = nil) {
        super.init(withXMLElement: element, parent: parent);
        version = self.valueOfAttributeNamed("version", xmlElement: element, required: true) ?? self.version;
        creator = self.valueOfAttributeNamed("creator", xmlElement: element, required: true) ?? self.creator;
        metadata = self.childElementOfClass(GPXMetadata.self, xmlElement: element) as? GPXMetadata;
        
        let keywordsStr = self.textForSingleChildElementNamed("keywords", xmlElement: element);
        keywords = GPXRoot.keywordsArray(fromString: keywordsStr);
        if (keywords?.count == nil && metadata?.keywords?.count != nil) {
            keywords = GPXRoot.keywordsArray(fromString: metadata?.keywords);
        }
        
        waypoints = self.childElementsOfClass(GPXWaypoint.self, xmlElement: element) as! [GPXWaypoint];
        routes = self.childElementsOfClass(GPXRoute.self, xmlElement: element) as! [GPXRoute];
        tracks = self.childElementsOfClass(GPXTrack.self, xmlElement: element) as! [GPXTrack];
        
        extensions = self.childElementOfClass(GPXExtensions.self, xmlElement: element) as? GPXExtensions;
    }
    
    private class func keywordsArray(fromString keywordString: String?) -> [String]? {
        guard let keywordString = keywordString else {
            // return nil only for nil strings, to differentiate between empty and nil keywords
            return nil;
        }
        let keywords = keywordString.components(separatedBy: ",");
        if keywords.count == 0 {
            return [];
        }
        var sanitizedKeyWords: [String] = [];
        let whitespaces = NSCharacterSet.whitespacesAndNewlines;
        for keyStr in keywords {
            sanitizedKeyWords.append(keyStr.trimmingCharacters(in: whitespaces));
        }
        return sanitizedKeyWords;
    }
    
    /// ---------------------------------
    /// @name Creating Waypoint
    /// ---------------------------------

    /** Creates and returns a new waypoint element.
     @param latitude The latitude of the point.
     @param longitude The longitude of the point.
     @return A newly created waypoint element.
     */
    public func newWaypoint(withLatitude latitude: Double, longitude: Double) -> GPXWaypoint {
        let waypoint = GPXWaypoint(latitude: latitude, longitude: longitude);
        self.addWaypoint(waypoint);
        return waypoint;
    }
    
    /// ---------------------------------
    /// @name Adding Waypoint
    /// ---------------------------------

    /** Inserts a given GPXWaypoint object at the end of the waypoint array.
     @param waypoint The GPXWaypoint to add to the end of the waypoint array.
     */
    public func addWaypoint(_ waypoint: GPXWaypoint) {
        let index = waypoints.firstIndex(of: waypoint);
        if (index == nil) {
            waypoint.parent = self;
            self.waypoints.append(waypoint);
        }
    }
    
    /** Adds the GPXWaypoint objects contained in another given array to the end of the waypoint array.
     @param waypoints An array of GPXWaypoint objects to add to the end of the waypoint array.
     */
    public func addWaypoints(_ waypoints: [GPXWaypoint]) {
        for waypoint in waypoints {
            self.addWaypoint(waypoint);
        }
    }
    
    /// ---------------------------------
    /// @name Removing Waypoint
    /// ---------------------------------

    /** Removes all occurrences in the waypoint array of a given GPXWaypoint object.
     @param waypoint The GPXWaypoint object to remove from the waypoint array.
     */
    public func removeWaypoint(_ waypoint: GPXWaypoint) {
        if let index = self.waypoints.firstIndex(of: waypoint) {
            waypoint.parent = nil;
            self.waypoints.remove(at: index);
        }
    }
    
    /// ---------------------------------
    /// @name Creating Route
    /// ---------------------------------

    /** Creates and returns a new route element.
     @return A newly created route element.
     */
    public func newRoute() -> GPXRoute {
        let route = GPXRoute();
        self.addRoute(route);
        return route;
    }
    
    /// ---------------------------------
    /// @name Adding Route
    /// ---------------------------------

    /** Inserts a given GPXRoute object at the end of the route array.
     @param route The GPXRoute to add to the end of the route array.
     */
    public func addRoute(_ route: GPXRoute) {
        let index = routes.firstIndex(of: route);
        if (index == nil) {
            route.parent = self;
            self.routes.append(route);
        }
    }

    /** Adds the GPXRoute objects contained in another given array to the end of the route array.
     @param routes An array of GPXRoute objects to add to the end of the route array.
     */
    public func addRoutes(_ routes: [GPXRoute]) {
        for route in routes {
            self.addRoute(route);
        }
    }


    /// ---------------------------------
    /// @name Removing Route
    /// ---------------------------------

    /** Removes all occurrences in the route array of a given GPXRoute object.
     @param route The GPXRoute object to remove from the route array.
     */
    public func removeRoute(_ route: GPXRoute) {
        if let index = self.routes.firstIndex(of: route) {
            route.parent = nil;
            self.routes.remove(at: index);
        }
    }


    /// ---------------------------------
    /// @name Creating Track
    /// ---------------------------------

    /** Creates and returns a new track element.
     @return A newly created track element.
     */
    public func newTrack() -> GPXTrack {
        let track = GPXTrack();
        self.addTrack(track);
        return track;
    }


    /// ---------------------------------
    /// @name Adding Track
    /// ---------------------------------

    /** Inserts a given GPXTrack object at the end of the track array.
     @param track The GPXTrack to add to the end of the track array.
     */
    public func addTrack(_ track: GPXTrack) {
        let index = tracks.firstIndex(of: track);
        if (index == nil) {
            track.parent = self;
            self.tracks.append(track);
        }
    }

    /** Adds the GPXTrack objects contained in another given array to the end of the track array.
     @param tracks An array of GPXTrack objects to add to the end of the track array.
     */
    public func addTracks(_ tracks: [GPXTrack]) {
        for track in tracks {
            self.addTrack(track);
        }
    }

    /// ---------------------------------
    /// @name Removing Track
    /// ---------------------------------

    /** Removes all occurrences in the track array of a given GPXTrack object.
     @param track The GPXTrack object to remove from the track array.
     */
    public func removeTrack(_ track: GPXTrack) {
        if let index = self.tracks.firstIndex(of: track) {
            track.parent = nil;
            self.tracks.remove(at: index);
        }
    }
    
    //MARK: Tag
    
    override class func tagName() -> String? {
        return "gpx";
    }
    
    //MARK: GPX
    
    override func addOpenTagToGpx(_ gpx: inout String, indentationLevel: Int) {
        var attribute = "";
        
        let schemaAppend = String(format: " xmlns=\"%@\"", self.schema);
        attribute.append(schemaAppend);
        
        let versionAppend = String(format: " version=\"%@\"", self.version);
        attribute.append(versionAppend);
        
        let creatorAppend = String(format: " creator=\"%@\"", self.creator);
        attribute.append(creatorAppend);
        
        gpx.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\r\n");
        let appendedStr = String(format: "%@<%@%@>\r\n",
                                 self.indentForIndentationLevel(indentationLevel),
                                 type(of: self).tagName()!,
                                 attribute)
        gpx.append(appendedStr);
    }
    
    override func addChildTagToGpx(_ gpx: inout String, indentationLevel: Int) {
        super.addChildTagToGpx(&gpx, indentationLevel: indentationLevel);
        
        if let metadata = self.metadata {
            metadata.gpx(&gpx, indentationLevel: indentationLevel);
        }
        for waypoint in self.waypoints {
            waypoint.gpx(&gpx, indentationLevel: indentationLevel);
        }
        for route in self.routes {
            route.gpx(&gpx, indentationLevel: indentationLevel);
        }
        for track in self.tracks {
            track.gpx(&gpx, indentationLevel: indentationLevel);
        }
        if let extensions = self.extensions {
            extensions.gpx(&gpx, indentationLevel: indentationLevel);
        }
    }
}

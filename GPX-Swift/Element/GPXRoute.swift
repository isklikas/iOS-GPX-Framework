//
//  GPXRoute.swift
//  GPX
//
//  Created by John Sklikas on 2/3/23.
//

import UIKit

/** rte represents route - an ordered list of waypoints representing a series of turn points leading to a destination.
 */
class GPXRoute: GPXElement {
    
    /// ---------------------------------
    /// @name Accessing Properties
    /// ---------------------------------

    /** GPS name of route. */
    var name: String?

    /** GPS comment for route. */
    var comment: String?

    /** User description of route. */
    var desc: String?

    /** Source of data. Included to give user some idea of reliability and accuracy of data. */
    var source: String?

    /** Links to external information about the route. */
    var links: [GPXLink] = [];

    /** GPS route number. */
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

    /** Type (classification) of route. */
    var type: String?

    /** You can add extend GPX by adding your own elements from another schema here. */
    var extensions: GPXExtensions?

    /** A list of route points. */
    var routePoints: [GPXRoutePoint] = [];
    
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
        
        routePoints = self.childElementsOfClass(GPXRoutePoint.self, xmlElement: element) as! [GPXRoutePoint]
    }
    
    override init(parent: GPXElement? = nil) {
        super.init(parent: parent);
    }
    
    //MARK: Public Methods
    
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
     @param links An array of GPXLink objects to add to the end of the link array.
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
    /// @name Creating Routepoint
    /// ---------------------------------

    /** Creates and returns a new routepoint element.
     @param latitude The latitude of the point.
     @param longitude The longitude of the point.
     @return A newly created routepoint element.
     */
    func newRoutePoint(withLatitude latitude: Double, longitude: Double) -> GPXRoutePoint {
        let routePoint = GPXRoutePoint(latitude: latitude, longitude: longitude);
        self.addRoutePoint(routePoint);
        return routePoint;
    }

    /// ---------------------------------
    /// @name Adding Routepoint
    /// ---------------------------------

    /** Inserts a given GPXRoutePoint object at the end of the routepoint array.
     @param routePoint The GPXRoutePoint to add to the end of the routepoint array.
     */
    func addRoutePoint(_ routePoint: GPXRoutePoint) {
        let index = routePoints.firstIndex(of: routePoint);
        if (index == nil) {
            routePoint.parent = self;
            routePoints.append(routePoint);
        }
    }

    /** Adds the GPXRoutePoint objects contained in another given array to the end of the routepoint array.
     @param routePoints An array of GPXRoutePoint objects to add to the end of the routepoint array.
     */
    func addRoutePoints(_ routePoints: [GPXRoutePoint]) {
        for routePoint in routePoints {
            self.addRoutePoint(routePoint);
        }
    }

    /// ---------------------------------
    /// @name Removing Routepoint
    /// ---------------------------------

    /** Removes all occurrences in the routepoint array of a given GPXRoutePoint object.
     @param routePoint The GPXRoutePoint object to remove from the routepoint array.
     */
    func removeRoutePoint(_ routePoint: GPXRoutePoint) {
        if let index = routePoints.firstIndex(of: routePoint) {
            routePoint.parent = nil;
            routePoints.remove(at: index);
        }
    }
    
    //MARK: Tag
    override class func tagName() -> String? {
        return "rte";
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
        
        for routePoint in self.routePoints {
            routePoint.gpx(&gpx, indentationLevel: indentationLevel);
        }
    }
}

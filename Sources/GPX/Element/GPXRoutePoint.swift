//
//  GPXRoutePoint.swift
//  GPX
//
//  Created by John Sklikas on 2/3/23.
//

import Foundation
import CoreLocation

public class GPXRoutePoint: GPXWaypoint {
    
    //MARK: Instance
    
    /// ---------------------------------
    /// ** Create RoutePoint
    /// ---------------------------------

    /**
     Creates and returns a new routepoint element.
     - Parameters:
        - latitude: The latitude of the point.
        - longitude: The longitude of the point.
     - Returns: A newly created routepoint element.
     */
    override public init(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        super.init(latitude: latitude, longitude: longitude);
    }
    
    /**
     Creates and returns a new waypoint element.
     - Parameter location: The location of the object.
     - Returns: A newly created waypoint element.
     */
    override public init(location: CLLocation) {
        super.init(location: location);
    }
    
    required init(withXMLElement element: GPXXMLElement, parent: GPXElement? = nil) {
        super.init(withXMLElement: element, parent: parent);
    }
    
    //MARK: Tag
    override class func tagName() -> String? {
        return "rtept";
    }

}

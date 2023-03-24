//
//  GPXLogger.swift
//  
//
//  Created by John Sklikas on 16/3/23.
//

import Foundation
import CoreLocation

public enum GPXSavingPreference {
    case route
    case tracks
    case waypoints
}

/** Instances of this class create GPX documents.
 */
public class GPXLogger: NSObject {
    
    /// The XML / GPX Root object that will be saved
    let rootDocument: GPXRoot;
    
    /// Saving Preference
    private var savingPreference: GPXSavingPreference?
    
    // MARK: Location Initialisers
    /// ** Creates new GPX files, from an array of locations
    
    public init(_ locations: [CLLocation], creator: String? = nil, savingPreference: GPXSavingPreference? = nil) {
        let gpxCreator = creator ?? "iOS-GPX-Framework";
        self.rootDocument = GPXRoot(withCreator: gpxCreator);
        self.savingPreference = savingPreference ?? .tracks;
        super.init();
        
        // Add the relevant data
        self.storeLocationsToRoot(locations: locations)
    }
    
    public init(_ coordinates: [CLLocationCoordinate2D], creator: String? = nil, savingPreference: GPXSavingPreference? = nil) {
        let gpxCreator = creator ?? "iOS-GPX-Framework";
        self.rootDocument = GPXRoot(withCreator: gpxCreator);
        self.savingPreference = savingPreference ?? .tracks;
        super.init();
        
        // Add the relevant data
        self.storeLocationsToRoot(coordinates: coordinates);
    }
    
    /// Adds the location or coordinate array to the GPX Root object.
    private func storeLocationsToRoot(locations: [CLLocation]? = nil, coordinates: [CLLocationCoordinate2D]? = nil) {
        //Depending on the preference, set the Root Element with the desired output
        switch self.savingPreference {
        case .route:
            let route = GPXRoute();
            if let locations = locations {
                for location in locations {
                    let routePoint = GPXRoutePoint(location: location);
                    route.addRoutePoint(routePoint);
                }
            }
            else if let coordinates = coordinates {
                for coordinate in coordinates {
                    let routePoint = GPXRoutePoint(latitude: coordinate.latitude, longitude: coordinate.longitude);
                    route.addRoutePoint(routePoint);
                }
            }
            else {
                // We do not want an empty element, in case none is valid
                return;
            }
            rootDocument.addRoute(route);
        case .waypoints:
            var waypoints: [GPXWaypoint] = [];
            if let locations = locations {
                for location in locations {
                    let waypoint = GPXWaypoint(location: location);
                    waypoints.append(waypoint);
                }
            }
            else if let coordinates = coordinates {
                for coordinate in coordinates {
                    let waypoint = GPXWaypoint(latitude: coordinate.latitude, longitude: coordinate.longitude);
                    waypoints.append(waypoint);
                }
            }
            else {
                // We do not want an empty element, in case none is valid
                return;
            }
            rootDocument.addWaypoints(waypoints);
        case .tracks:
            fallthrough;
        default:
            let trackSegment = GPXTrackSegment();
            if let locations = locations {
                for location in locations {
                    let trackPoint = GPXTrackPoint(location: location);
                    trackSegment.addTrackpoint(trackPoint);
                }
            }
            else if let coordinates = coordinates {
                for coordinate in coordinates {
                    let trackPoint = GPXTrackPoint(latitude: coordinate.latitude, longitude: coordinate.longitude);
                    trackSegment.addTrackpoint(trackPoint);
                }
            }
            else {
                // We do not want an empty element, in case none is valid
                return;
            }
            let track = GPXTrack();
            track.addTracksegment(trackSegment);
            rootDocument.addTrack(track);
        }
    }
    
    //MARK: Root Initialiser
    /// ** Creates new GPX file, from an existing one, or updates the existing one.
    
    public init(_ rootGPX: GPXRoot) {
        self.rootDocument = rootGPX;
        super.init();
    }
    
    //MARK: Saving function
    
    /// Save the GPX Root Object to a file
    public func export() -> String {
        var gpxText = "";
        self.rootDocument.addOpenTagToGpx(&gpxText, indentationLevel: 0);
        self.rootDocument.addChildTagToGpx(&gpxText, indentationLevel: 0);
        self.rootDocument.addCloseTagToGpx(&gpxText, indentationLevel: 0);
        return gpxText;
    }
}

//
//  GPX_SwiftTests.swift
//  GPX-SwiftTests
//
//  Created by John Sklikas on 3/3/23.
//

import XCTest
@testable import GPX

class GPX_SwiftTests: XCTestCase, GPXParsing {
    
    func parser(_ parser: GPXXMLParser, didCompleteParsing rootXMLElement: GPXXMLElement) {
        let root = GPXRoot(withXMLElement: rootXMLElement);
        
        // gpx
        XCTAssertNotNil(root);
        XCTAssertEqual(root.creator, "ExpertGPS 1.1b1 - http://www.topografix.com")
        
        // gpx > metadata
        let metadata = root.metadata;
        XCTAssertNotNil(metadata);
        XCTAssertTrue(metadata!.name == "Mystic River Basin Trails");
        XCTAssertTrue(metadata!.desc == "Both banks of the lower Mystic River have paved trails, allowing for a short and a long loop along the water.  The short loop is a two mile trail with no road crossings.  The long loop adds side-trips out to Draw Seven Park and the MBTA yard at Wellington Station, but crosses the six lanes of Route 28 twice.");
        
        let author = metadata!.author;
        XCTAssertNotNil(author);
        XCTAssertEqual(author!.name, "Dan Foster");
        let authorEmail = author!.email;
        XCTAssertNotNil(authorEmail);
        XCTAssertEqual(authorEmail!.emailID, "trails");
        XCTAssertEqual(authorEmail!.domain, "topografix.com");
        let authorLink = author!.link;
        XCTAssertNotNil(authorLink);
        XCTAssertEqual(authorLink!.href, "http://www.tufts.edu/mystic/amra/pamphlet.html");
        XCTAssertEqual(authorLink!.text, "Lower Mystic Basin Trails");
        
        let copyright = metadata!.copyright;
        XCTAssertNotNil(copyright);
        XCTAssertEqual(copyright!.author, "Dan Foster");
        XCTAssertEqual(copyright!.license, "http://creativecommons.org/licenses/by/2.0/");
        
        let link = metadata!.link;
        XCTAssertNotNil(link);
        XCTAssertEqual(link!.href, "http://www.topografix.com/gpx.asp");
        XCTAssertEqual(link!.text, "GPX site");
        XCTAssertEqual(link!.mimetype, "text/html");
        
        // gpx > wpt
        XCTAssertEqual(root.waypoints.count, 23);
        
        var waypoint = root.waypoints[0];
        XCTAssertEqual(waypoint.latitude, 42.398167);
        XCTAssertEqual(waypoint.longitude, -71.083339);
        XCTAssertEqual(waypoint.name, "205A");
        XCTAssertEqual(waypoint.desc, "Concrete platform looking out onto the Mystic.\nWhile you take in the view, try not to think about the fact that you're standing on top of MWRA Wet Water Discharge Outflow #205A");
        
        // check timestamp
        let t2002_03_12T18_36_28Z = Date(timeIntervalSince1970: 1015958188);
        XCTAssertTrue(waypoint.time == t2002_03_12T18_36_28Z);
        
        waypoint = root.waypoints[2];
        XCTAssertEqual(waypoint.latitude, 42.398467);
        XCTAssertEqual(waypoint.longitude, -71.090467);
        XCTAssertEqual(waypoint.name, "BLESSING");
        XCTAssertEqual(waypoint.desc, "The Blessing of the Bay Boathouse, now run by the Somerville Boys and Girls Club.\nA dock with small boats for the children of Somerville.  Check out the Mystic River mural at the intersection of Shore Drive and Rt 16!");
        XCTAssertEqual(waypoint.links!.count, 1);
        let waypointLink = waypoint.links![0] as! GPXLink;
        XCTAssertEqual(waypointLink.href, "http://www.everydaydesign.com/ourtown/bay.html");
        XCTAssertEqual(waypointLink.text, "Boat-building on the Mystic River");
        
        waypoint = root.waypoints[22];
        XCTAssertEqual(waypoint.latitude, 42.395889);
        XCTAssertEqual(waypoint.longitude, -71.077949);
        XCTAssertEqual(waypoint.name, "YACHT CLUB");
        XCTAssertEqual(waypoint.desc, "Winter Hill Yacht Club");
        
        // gpx > rte
        XCTAssertEqual(root.routes.count, 2);
        
        var route:GPXRoute?
        var routepoint: GPXRoutePoint?
        
        route = root.routes[0];
        XCTAssertEqual(route!.name, "LONG LOOP");
        XCTAssertTrue(route!.desc == "The long loop around the Mystic River, with stops at Draw Seven Park and the MBTA yard at Wellington Station (Orange Line).  Crosses Route 28 twice");
        XCTAssertEqual(route!.number, 1);
        XCTAssertEqual(route!.routePoints.count, 18);
        
        
        routepoint = route!.routePoints[0];
        XCTAssertEqual(routepoint!.latitude, 42.405495);
        XCTAssertEqual(routepoint!.longitude, -71.098364);
        XCTAssertEqual(routepoint!.name, "LOOP");
        XCTAssertEqual(routepoint!.desc, "Starting point for the Mystic River loop trails.");
        
        routepoint = route!.routePoints[9];
        XCTAssertEqual(routepoint!.latitude, 42.400554);
        XCTAssertEqual(routepoint!.longitude, -71.079901);
        XCTAssertEqual(routepoint!.name, "WELL YACHT");
        XCTAssertEqual(routepoint!.desc, "Mystic Wellington Yacht Club");
        
        routepoint = route!.routePoints[17];
        XCTAssertEqual(routepoint!.latitude, 42.405495);
        XCTAssertEqual(routepoint!.longitude, -71.098364);
        XCTAssertEqual(routepoint!.name, "LOOP");
        XCTAssertEqual(routepoint!.desc, "Starting point for the Mystic River loop trails.");
        
        route = root.routes[1];
        XCTAssertEqual(route!.name, "SHORT LOOP");
        XCTAssertEqual(route!.desc, "Short Mystic River loop.\nThis loop circles the portion of the Mystic River enclosed by Routes 93, 16, and 28.  It's short, but you can do the entire loop without crossing any roads.");
        XCTAssertEqual(route!.number, 3);
        XCTAssertEqual(route!.routePoints.count, 8);
        
        routepoint = route!.routePoints[0];
        XCTAssertEqual(routepoint!.latitude, 42.405495);
        XCTAssertEqual(routepoint!.longitude, -71.098364);
        XCTAssertEqual(routepoint!.name, "LOOP");
        XCTAssertEqual(routepoint!.desc, "Starting point for the Mystic River loop trails.");
        
        routepoint = route!.routePoints[3];
        XCTAssertEqual(routepoint!.latitude, 42.399733);
        XCTAssertEqual(routepoint!.longitude, -71.083567);
        XCTAssertEqual(routepoint!.name, "RT 28");
        XCTAssertEqual(routepoint!.desc, "Wellington Bridge\nRoute 28 crosses the Mystic River on this 6 lane bridge.  Pedestrian walkways on both sides.  Access to the Assembly Square mall is at the south end of the bridge.");
        
        routepoint = route!.routePoints[7];
        XCTAssertEqual(routepoint!.latitude, 42.405495);
        XCTAssertEqual(routepoint!.longitude, -71.098364);
        XCTAssertEqual(routepoint!.name, "LOOP");
        XCTAssertEqual(routepoint!.desc, "Starting point for the Mystic River loop trails.");
        
        // gpx > trk
        XCTAssertEqual(root.tracks.count, 3);
        
        var track: GPXTrack?
        var tracksegment: GPXTrackSegment?
        var trackpoint: GPXTrackPoint?
        
        track = root.tracks[0];
        XCTAssertEqual(track!.name, "LONG TRACK");
        XCTAssertEqual(track!.desc, "Tracklog from Long Loop");
        XCTAssertEqual(track!.number, 2);
        XCTAssertEqual(track!.tracksegments.count, 1);
        tracksegment = track!.tracksegments[0];
        XCTAssertEqual(tracksegment!.trackpoints.count, 166);
        trackpoint = tracksegment!.trackpoints[0];
        XCTAssertEqual(trackpoint!.latitude, 42.405488);
        XCTAssertEqual(trackpoint!.longitude, -71.098173);

        // check timestamp
        let t2002_03_11T20_28_26Z = Date(timeIntervalSince1970: 1015878506);
        XCTAssertTrue(trackpoint!.time == t2002_03_11T20_28_26Z);
        
        trackpoint = tracksegment!.trackpoints[82];
        XCTAssertEqual(trackpoint!.latitude, 42.399266);
        XCTAssertEqual(trackpoint!.longitude, -71.083581);
        trackpoint = tracksegment!.trackpoints[165];
        XCTAssertEqual(trackpoint!.latitude, 42.405703);
        XCTAssertEqual(trackpoint!.longitude, -71.098065);
        
        track = root.tracks[1];
        XCTAssertEqual(track!.name, "SHORT TRACK");
        XCTAssertTrue(track!.desc == "Bike path along the Mystic River in Medford.\nThe trail runs along Interstate 93 to Shore Road.  It then crosses the Mystic on the Route 38 bridge near the Assembly Square mall.  After the bridge, the trail cuts through the high meadow grass behind the State Police barracks, and enters Torbert McDonald Park.  Leaving the park, the trail passes the Meadow Glen mall before crossing back over the Mystic on the Rt 16 bridge.");
        XCTAssertEqual(track!.number, 4);
        XCTAssertEqual(track!.tracksegments.count, 1);
        tracksegment = track!.tracksegments[0];
        XCTAssertEqual(tracksegment!.trackpoints.count, 95);
        trackpoint = tracksegment!.trackpoints[0];
        XCTAssertEqual(trackpoint!.latitude, 42.405381);
        XCTAssertEqual(trackpoint!.longitude, -71.098108);
        trackpoint = tracksegment!.trackpoints[48];
        XCTAssertEqual(trackpoint!.latitude, 42.403944);
        XCTAssertEqual(trackpoint!.longitude, -71.085405);
        trackpoint = tracksegment!.trackpoints[94];
        XCTAssertEqual(trackpoint!.latitude, 42.405660);
        XCTAssertEqual(trackpoint!.longitude, -71.098280);
        
        
        track = root.tracks[2];
        XCTAssertEqual(track!.name, "TUFTS CONNECT");
        XCTAssertEqual(track!.desc, "Connecting route from Tufts Park to beginning of Mystic Basin loop trail.");
        XCTAssertEqual(track!.number, 5);
        XCTAssertEqual(track!.tracksegments.count, 1);
        tracksegment = track!.tracksegments[0];
        XCTAssertEqual(tracksegment!.trackpoints.count, 24);
        trackpoint = tracksegment!.trackpoints[0];
        XCTAssertEqual(trackpoint!.latitude, 42.402356);
        XCTAssertEqual(trackpoint!.longitude, -71.107807);
        trackpoint = tracksegment!.trackpoints[11];
        XCTAssertEqual(trackpoint!.latitude, 42.405317);
        XCTAssertEqual(trackpoint!.longitude, -71.103923);
        trackpoint = tracksegment!.trackpoints[23];
        XCTAssertEqual(trackpoint!.latitude, 42.405424);
        XCTAssertEqual(trackpoint!.longitude, -71.098173);
    }
    
    func parser(_ parser: GPXXMLParser, didFailParsingWithError error: Error) {
        print(error.localizedDescription);
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        let path = Bundle.module.path(forResource: "mystic_basin_trail", ofType: "gpx")!
        
        let parser = GPXParser(path);
        parser?.gpxXMLParser.delegate = self;
        parser?.gpxXMLParser.startParsing();
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

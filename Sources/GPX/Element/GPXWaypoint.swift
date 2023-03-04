//
//  GPXWaypoint.swift
//  GPX
//
//  Created by John Sklikas on 1/3/23.
//

import Foundation
import CoreLocation

/** wpt represents a waypoint, point of interest, or named feature on a map.
 */
public class GPXWaypoint: GPXElement {
    
    /// ---------------------------------
    /// ### Accessing Properties
    /// ---------------------------------

    /** Elevation (in meters) of the point. */
    var elevation: CLLocationDistance? {
        get {
            if let elevationValue = elevationValue {
                return GPXType.decimal(elevationValue)
            }
            return nil;
        }
        set {
            if let newValue = newValue {
                elevationValue = GPXType.valueForDecimal(newValue)
            }
        }
    }
    private var elevationValue: String?

    /// Returns nil if elevation is not present in waypoint information.
    var elevationBoxed: Double? {
        get {
            return self.elevation;
        }
    }

    /** Creation/modification timestamp for element.
        Date and time in are in Univeral Coordinated Time (UTC), not local time!
        Conforms to ISO 8601 specification for date/time representation.
        Fractional seconds are allowed for millisecond timing in tracklogs */
    var time: Date? {
        get {
            if let timeValue = timeValue {
                return GPXType.dateTime(timeValue)
            }
            return nil;
        }
        set {
            if let newValue = newValue {
                timeValue = GPXType.valueForDateTime(newValue)
            }
        }
    }
    private var timeValue: String?

    /** Magnetic variation (in degrees) at the point */
    var magneticVariation: Double? {
        get {
            if let magneticVariationValue = magneticVariationValue {
                return GPXType.degress(magneticVariationValue)
            }
            return nil;
        }
        set {
            if let newValue = newValue {
                magneticVariationValue = GPXType.valueForDegress(newValue)
            }
        }
    }
    private var magneticVariationValue: String?

    /** Height (in meters) of geoid (mean sea level) above WGS84 earth ellipsoid. As defined in NMEA GGA message. */
    var geoidHeight: CLLocationDistance? {
        get {
            if let geoidHeightValue = geoidHeightValue {
                return GPXType.decimal(geoidHeightValue)
            }
            return nil;
        }
        set {
            if let newValue = newValue {
                geoidHeightValue = GPXType.valueForDecimal(newValue)
            }
        }
    }
    private var geoidHeightValue: String?

    /** The GPS name of the waypoint. This field will be transferred to and from the GPS.
        GPX does not place restrictions on the length of this field or the characters contained in it.
        It is up to the receiving application to validate the field before sending it to the GPS. */
    var name: String?

    /** GPS waypoint comment. Sent to GPS as comment. */
    var comment: String?

    /** A text description of the element. Holds additional information about the element intended for the user, not the GPS. */
    var desc: String?

    /** Source of data. Included to give user some idea of reliability and accuracy of data.
        "Garmin eTrex", "USGS quad Boston North", e.g. */
    var source: String?

    /** Link to additional information about the waypoint. */
    var links: [GPXElement]?

    /** Text of GPS symbol name. For interchange with other programs, use the exact spelling of the symbol as displayed on the GPS.
        If the GPS abbreviates words, spell them out. */
    var symbol: String?

    /** Type (classification) of the waypoint. */
    var type: String?

    /** Instantaneous speed at the point in m/s. */
    var speed: Double? {
        get {
            if let speedValue = speedValue {
                return Double(speedValue)
            }
            return nil;
        }
        set {
            if let newValue = newValue {
                speedValue = String(newValue)
            }
        }
    }
    private var speedValue: String?

    /** Instantaneous course at the point. */
    var course: Double? {
        get {
            if let courseValue = courseValue {
                return Double(courseValue)
            }
            return nil;
        }
        set {
            if let newValue = newValue {
                courseValue = String(newValue)
            }
        }
    }
    private var courseValue: String?

    /** Type of GPX fix. */
    var fix: GPXFix? {
        get {
            if let fixValue = fixValue {
                return GPXType.fix(fixValue)
            }
            return nil;
        }
        set {
            if let newValue = newValue {
                fixValue = GPXType.valueForFix(newValue)
            }
        }
    }
    private var fixValue: String?

    /** Number of satellites used to calculate the GPX fix. */
    var satellites: Int? {
        get {
            if let satellitesValue = satellitesValue {
                return GPXType.nonNegativeInteger(satellitesValue)
            }
            return nil;
        }
        set {
            if let newValue = newValue {
                satellitesValue = GPXType.valueForNonNegativeInteger(newValue)
            }
        }
    }
    private var satellitesValue: String?

    /** Horizontal dilution of precision. */
    var horizontalDilution: Double? {
        get {
            if let horizontalDilutionValue = horizontalDilutionValue {
                return GPXType.decimal(horizontalDilutionValue)
            }
            return nil;
        }
        set {
            if let newValue = newValue {
                horizontalDilutionValue = GPXType.valueForDecimal(newValue)
            }
        }
    }
    private var horizontalDilutionValue: String?

    /** Vertical dilution of precision. */
    var verticalDilution: Double? {
        get {
            if let verticalDilutionValue = verticalDilutionValue {
                return GPXType.decimal(verticalDilutionValue)
            }
            return nil;
        }
        set {
            if let newValue = newValue {
                verticalDilutionValue = GPXType.valueForDecimal(newValue)
            }
        }
    }
    private var verticalDilutionValue: String?

    /** Position dilution of precision. */
    var positionDilution: Double? {
        get {
            if let positionDilutionValue = positionDilutionValue {
                return GPXType.decimal(positionDilutionValue)
            }
            return nil;
        }
        set {
            if let newValue = newValue {
                positionDilutionValue = GPXType.valueForDecimal(newValue)
            }
        }
    }
    private var positionDilutionValue: String?

    /** Number of seconds since last DGPS update. */
    var ageOfDGPSData: Double? {
        get {
            if let ageOfDGPSDataValue = ageOfDGPSDataValue {
                return GPXType.decimal(ageOfDGPSDataValue)
            }
            return nil;
        }
        set {
            if let newValue = newValue {
                ageOfDGPSDataValue = GPXType.valueForDecimal(newValue)
            }
        }
    }
    private var ageOfDGPSDataValue: String?

    /** ID of DGPS station used in differential correction. */
    var DGPSid: Int? {
        get {
            if let DGPSidValue = DGPSidValue {
                return GPXType.dgpsStation(DGPSidValue)
            }
            return nil;
        }
        set {
            if let newValue = newValue {
                DGPSidValue = GPXType.valueForDgpsStation(newValue)
            }
        }
    }
    private var DGPSidValue: String?

    /** You can add extend GPX by adding your own elements from another schema here. */
    var extensions: GPXExtensions?

    /** The latitude of the point. Decimal degrees, WGS84 datum. */
    var latitude: CLLocationDegrees? {
        get {
            if let latitudeValue = latitudeValue {
                return GPXType.latitude(latitudeValue)
            }
            return nil;
        }
        set {
            if let newValue = newValue {
                latitudeValue = GPXType.valueForLatitude(newValue)
            }
        }
    }
    private var latitudeValue: String?

    /** The longitude of the point. Decimal degrees, WGS84 datum. */
    var longitude: CLLocationDegrees? {
        get {
            if let longitudeValue = longitudeValue {
                return GPXType.longitude(longitudeValue)
            }
            return nil;
        }
        set {
            if let newValue = newValue {
                longitudeValue = GPXType.valueForLongitude(newValue)
            }
        }
    }
    private var longitudeValue: String?
    
    //MARK: Instance
    
    /// ---------------------------------
    /// ###  Create Waypoint
    /// ---------------------------------

    /** Creates and returns a new waypoint element.
     - Parameter latitude: The latitude of the point.
     - Parameter longitude: The longitude of the point.
     - Returns: A newly created waypoint element.
     */
    init(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        super.init()
        self.latitude = latitude;
        self.longitude = longitude;
    }
    
    required init(withXMLElement element: GPXXMLElement, parent: GPXElement? = nil) {
        super.init(withXMLElement: element, parent: parent);
        
        //Properties
        elevationValue = self.textForSingleChildElementNamed("ele", xmlElement: element);
        timeValue = self.textForSingleChildElementNamed("time", xmlElement:element);
        magneticVariationValue = self.textForSingleChildElementNamed("magvar", xmlElement:element);
        geoidHeightValue = self.textForSingleChildElementNamed("geoidheight", xmlElement:element);
        name = self.textForSingleChildElementNamed("name", xmlElement:element);
        comment = self.textForSingleChildElementNamed("cmt", xmlElement:element);
        desc = self.textForSingleChildElementNamed("desc", xmlElement:element);
        source = self.textForSingleChildElementNamed("src", xmlElement:element);
        
        // speed and course may be direct child tags of waypoints according to http://www.topografix.com/gpx_manual.asp
        courseValue = self.textForSingleChildElementNamed("course", xmlElement:element);
        speedValue = self.textForSingleChildElementNamed("speed", xmlElement:element);
        
        links = self.childElementsOfClass(GPXLink.self, xmlElement: element);
        
        symbol = self.textForSingleChildElementNamed("sym", xmlElement:element);
        type = self.textForSingleChildElementNamed("type", xmlElement:element);
        fixValue = self.textForSingleChildElementNamed("fix", xmlElement:element);
        satellitesValue = self.textForSingleChildElementNamed("sat", xmlElement:element);
        horizontalDilutionValue = self.textForSingleChildElementNamed("hdop", xmlElement:element);
        verticalDilutionValue = self.textForSingleChildElementNamed("vdop", xmlElement:element);
        positionDilutionValue = self.textForSingleChildElementNamed("pdop", xmlElement:element);
        ageOfDGPSDataValue = self.textForSingleChildElementNamed("ageofdgpsdata", xmlElement:element);
        DGPSidValue = self.textForSingleChildElementNamed("dgpsid", xmlElement:element);
        extensions = self.childElementOfClass(GPXExtensions.self, xmlElement: element) as? GPXExtensions

        latitudeValue = self.valueOfAttributeNamed("lat", xmlElement: element, required: true);
        longitudeValue = self.valueOfAttributeNamed("lon", xmlElement: element, required: true);
    }
    
    /// ---------------------------------
    /// ### Creating Link
    /// ---------------------------------

    /** Creates and returns a new link element.
     - Parameter href: URL of hyperlink
     - Returns: A newly created link element.
     */
    func newLinkWithHref(_ href: String) -> GPXLink {
        let link = GPXLink(withHref: href);
        self.addLink(link);
        return link;
    }
    
    /// ---------------------------------
    /// ### Adding Link
    /// ---------------------------------

    /** Inserts a given GPXLink object at the end of the link array.
     - Parameter link: The GPXLink to add to the end of the link array.
     */
    func addLink(_ link: GPXLink) {
        if links?.firstIndex(of: link) == nil {
            link.parent = self;
            links?.append(link);
        }
    }

    /** Adds the GPXLink objects contained in another given array to the end of the link array.
     - Parameter array: An array of GPXLink objects to add to the end of the link array.
     */
    func addLinks(_ array: [GPXLink]) {
        for link in array {
            self.addLink(link);
        }
    }


    /// ---------------------------------
    ///  ### Removing Link
    /// ---------------------------------

    /** Removes all occurrences in the link array of a given GPXLink object.
     - Parameter link: The GPXLink object to remove from the link array.
     */
    func removeLink(_ link: GPXLink) {
        if let index = links?.firstIndex(of: link) {
            link.parent = nil;
            links?.remove(at: index);
        }
    }
    
    //MARK: Tag
    override class func tagName() -> String? {
        return "wpt";
    }
    
    //MARK: GPX
    override func addOpenTagToGpx(_ gpx: inout String, indentationLevel: Int) {
        var attribute = "";
        if let latitudeValue = latitudeValue {
            let appendedStr = String(format: " lat=\"%@\"", latitudeValue);
            attribute.append(appendedStr);
        }
        if let longitudeValue = longitudeValue {
            let appendedStr = String(format: " lon=\"%@\"", longitudeValue);
            attribute.append(appendedStr);
        }
        let appendedStr = String(format: "%@<%@%@>\r\n",
                                 self.indentForIndentationLevel(indentationLevel),
                                 Swift.type(of: self).tagName()!,
                                 attribute);
        gpx.append(appendedStr);
    }
    
    override func addChildTagToGpx(_ gpx: inout String, indentationLevel: Int) {
        super.addChildTagToGpx(&gpx, indentationLevel: indentationLevel);
        
        self.gpx(&gpx, addPropertyForValue: elevationValue, tagName: "ele", indentationLevel: indentationLevel);
        self.gpx(&gpx, addPropertyForValue: timeValue, tagName: "time", indentationLevel: indentationLevel);
        self.gpx(&gpx, addPropertyForValue: magneticVariationValue, tagName: "magvar", indentationLevel: indentationLevel);
        self.gpx(&gpx, addPropertyForValue: geoidHeightValue, tagName: "geoidheight", indentationLevel: indentationLevel);
        self.gpx(&gpx, addPropertyForValue: name, tagName: "name", indentationLevel: indentationLevel);
        self.gpx(&gpx, addPropertyForValue: comment, tagName: "cmt", indentationLevel: indentationLevel);
        self.gpx(&gpx, addPropertyForValue: desc, tagName: "desc", indentationLevel: indentationLevel);
        self.gpx(&gpx, addPropertyForValue: source, tagName: "src", indentationLevel: indentationLevel);
        
        for link in self.links ?? [] {
            link.gpx(&gpx, indentationLevel: indentationLevel)
        }

        self.gpx(&gpx, addPropertyForValue: symbol, tagName: "sym", indentationLevel: indentationLevel);
        self.gpx(&gpx, addPropertyForValue: type, tagName: "type", indentationLevel: indentationLevel);
        self.gpx(&gpx, addPropertyForValue: fixValue, tagName: "fix", indentationLevel: indentationLevel);
        self.gpx(&gpx, addPropertyForValue: satellitesValue, tagName: "sat", indentationLevel: indentationLevel);
        self.gpx(&gpx, addPropertyForValue: horizontalDilutionValue, tagName: "hdop", indentationLevel: indentationLevel);
        self.gpx(&gpx, addPropertyForValue: verticalDilutionValue, tagName: "vdop", indentationLevel: indentationLevel);
        self.gpx(&gpx, addPropertyForValue: positionDilutionValue, tagName: "pdop", indentationLevel: indentationLevel);
        self.gpx(&gpx, addPropertyForValue: ageOfDGPSDataValue, tagName: "ageofdgpsdata", indentationLevel: indentationLevel);
        self.gpx(&gpx, addPropertyForValue: DGPSidValue, tagName: "dgpsid", indentationLevel: indentationLevel);

        if let extensions = self.extensions {
            extensions.gpx(&gpx, indentationLevel: indentationLevel)
        }
    }

}

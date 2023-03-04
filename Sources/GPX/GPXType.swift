//
//  GPXType.swift
//  GPX
//
//  Created by John Sklikas on 28/1/23.
//

import Foundation
import CoreLocation

enum GPXFix: Int {
    case GPXFixNone = 0,
         GPXFix2D,
         GPXFix3D,
         GPXFixDgps,
         GPXFixPps
}

/** Convinience methods for GPX Value types.
 */
class GPXType: NSObject {
    static let pred = NSUUID().uuidString
    static var dateFormatter_ssZ: DateFormatter?
    static let pred_ss_SSSZ = NSUUID().uuidString
    static var dateFormatter_ss_SSSZ: DateFormatter?
    static let pred_sszzzz = NSUUID().uuidString
    static var dateFormatter_sszzzz: DateFormatter?
    

    /** Return the CLLocationDegrees object from a given string.
     @param value The string which to convert CLLocationDegrees. A value ≥−90 and ≤90.
     @return A CLLocationDegrees from a value.
     */
    class func latitude(_ value: String) -> CLLocationDegrees? {
        let f = Double(value);
        return f;
    }

    /** Return the NSString object from a given CLLocationDegrees.
     @param latitude The CLLocationDegrees which to convert NSString. A value ≥−90 and ≤90.
     @return A NSString from a latitude.
     */
    class func valueForLatitude(_ latitude: CLLocationDegrees) -> String {
        if (latitude >= -90 && latitude <= 90) {
            return String(latitude)
        }
        return "0";
    }

    /** Return the CLLocationDegrees object from a given string.
     @param value The string which to convert CGFloat. A value ≥−180 and ≤180.
     @return A CLLocationDegrees from a value.
     */
   class func longitude(_ value: String) -> CLLocationDegrees? {
       let f = Double(value);
       return f;
   }

    /** Return the NSString object from a given CLLocationDegrees.
     @param longitude The CLLocationDegrees which to convert NSString. A value ≥−180 and ≤180.
     @return A NSString from a longitude.
     */
    class func valueForLongitude(_ longitude: CLLocationDegrees) -> String {
        if (longitude >= -180 && longitude <= 180) {
            return String(longitude)
        }
        return "0";
    }

    /** Return the CLLocationDegrees object from a given string.
     @param value The string which to convert CLLocationDegrees. A value ≥0 and ≤360.
     @return A CLLocationDegrees from a value.
     */
    class func degress(_ value: String) -> CLLocationDegrees? {
        let f = Double(value);
        return f;
    }

    /** Return the NSString object from a given CLLocationDegrees.
     @param degress The CLLocationDegrees which to convert NSString. A value ≥0 and ≤360.
     @return A NSString from a degress.
     */
    class func valueForDegress(_ degress: CLLocationDegrees) -> String {
        if (degress >= 0 && degress <= 360) {
            return String(degress)
        }
        return "0";
    }

    /** Return the GPXFix from a given string.
     @param value The string which to convert GPXFix.
     @return A GPXFix from a value.
     */
    class func fix(_ value: String?) -> GPXFix {
        if let value = value {
            if value == "2d" {
                return .GPXFix2D
            }
            else if value == "3d" {
                return .GPXFix3D
            }
            else if value == "dgps" {
                return .GPXFixDgps
            }
            else if value == "pps" {
                return .GPXFixPps
            }
        }
        return .GPXFixNone;
    }

    /** Return the NSString object from a given GPXFix.
     @param fix The GPXFix which to convert NSString.
     @return A NSString from a fix.
     */
    class func valueForFix(_ fix: GPXFix) -> String {
        switch fix {
        case .GPXFixPps:
            return "pps";
        case .GPXFixDgps:
            return "dgps";
        case .GPXFix3D:
            return "3d";
        case .GPXFix2D:
            return "2d";
        case .GPXFixNone:
            fallthrough;
        default:
            return "none"
            
        }
    }

    /** Return the NSInteger object from a given string.
     @param value The string which to convert NSInteger. A value ≥0 and ≤1023.
     @return A NSInteger from a value.
     */
    class func dgpsStation(_ value: String) -> Int {
        if let i = Int(value),
           i >= 0,
           i <= 1023 {
            return i;
        }
        return 0;
    }

    /** Return the NSString object from a given NSInteger.
     @param dgpsStation The NSInteger which to convert NSString. A value ≥0 and ≤1023.
     @return A NSString from a dgpsStation.
     */
    class func valueForDgpsStation(_ dgpsStation: Int) -> String {
        if (dgpsStation >= 0 && dgpsStation <= 1023) {
            return String(dgpsStation);
        }
        return "0";
    }

    /** Return the double value from a given string.
     @param value The string which to convert CGFloat.
     @return A double from a value.
     */
    class func decimal(_ value: String) -> Double? {
        let f = Double(value);
        return f;
    }

    /** Return the NSString object from a given double.
     @param decimal The double which to convert NSString.
     @return A NSString from a decimal.
     */
    class func valueForDecimal(_ decimal: Double) -> String? {
        return String(decimal)
    }

    /** Return the NSDate object from a given string.
     
     pecifies a single moment in time. The value is a dateTime, which can be one of the following:
     
     - *gYear* gives year resolution
     - *gYearMonth* gives month resolution
     - *date gives* day resolution
     - *dateTime* gives second resolution
     
     
     *gYear (YYYY)*
     
     <TimeStamp>
     <when>1997</when>
     </TimeStamp>
     
     *gYearMonth (YYYY-MM)*
     
     <TimeStamp>
     <when>1997-07</when>
     </TimeStamp>
     
     *date (YYYY-MM-DD)*
     
     <TimeStamp>
     <when>1997-07-16</when>
     </TimeStamp>
     
     *dateTime (YYYY-MM-DDThh:mm:ssZ)*
     
     Here, T is the separator between the calendar and the hourly notation of time, and Z indicates UTC. (Seconds are required.)
     
     <TimeStamp>
     <when>1997-07-16T07:30:15Z</when>
     </TimeStamp>
     
     *dateTime (YYYY-MM-DDThh:mm:sszzzzzz)*
     
     This example gives the local time and then the ± conversion to UTC.
     
     <TimeStamp>
     <when>1997-07-16T10:30:15+03:00</when>
     </TimeStamp>
     
     @param value The string which to convert NSDate.
     @return A NSDate from a value.
     */
    private class func newDateFormatterWithFormat(_ format: String?) -> DateFormatter? {
        guard let format = format else {
            return nil;
        }
        let dateFormatter = DateFormatter()
        let locale = Locale(identifier: "en_US_POSIX");
        
        dateFormatter.calendar = Calendar(identifier: .gregorian);
        dateFormatter.locale = locale;
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.dateFormat = format;
        return dateFormatter
    }
    
    class func dateTime(_ value: String) -> Date? {
        var date: Date?
        
        DispatchQueue.once(token: pred) {
            dateFormatter_ssZ = self.newDateFormatterWithFormat("yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'")
        }
        
        // dateTime（YYYY-MM-DDThh:mm:ssZ）
        date = dateFormatter_ssZ!.date(from: value)
        if (date != nil) {
            return date;
        }
        
        DispatchQueue.once(token: pred_ss_SSSZ) {
            dateFormatter_ss_SSSZ = self.newDateFormatterWithFormat("yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSS'Z'")
        }
        
        // dateTime（YYYY-MM-DDThh:mm:ss.SSSZ）
        date = dateFormatter_ss_SSSZ!.date(from: value)
        if (date != nil) {
            return date;
        }
        
        // dateTime（YYYY-MM-DDThh:mm:sszzzzzz
        let maxLength = 22;
        if value.count > maxLength {
            DispatchQueue.once(token: pred_sszzzz) {
                dateFormatter_sszzzz = self.newDateFormatterWithFormat("yyyy'-'MM'-'dd'T'HH':'mm':'sszzzz")
            }
            
            let remaining = value.count - maxLength;
            let remainingRange = NSRange(location: maxLength, length: remaining);
            let strRange = Range(remainingRange, in: value);
            let v = value.replacingOccurrences(of: ":", with: "", range: strRange)
            date = dateFormatter_sszzzz!.date(from: v)
            if (date != nil) {
                return date;
            }
        }
        
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: 0);
        
        // date
        formatter.dateFormat = "yyyy'-'MM'-'dd'";
        date = formatter.date(from: value);
        if (date != nil) {
            return date;
        }
        
        // gYearMonth
        formatter.dateFormat = "yyyy'-'MM'";
        date = formatter.date(from: value);
        if (date != nil) {
            return date;
        }
        
        // gYear
        formatter.dateFormat = "yyyy'";
        date = formatter.date(from: value);
        if (date != nil) {
            return date;
        }

        return nil;
    }

    /** Return the NSString object from a given NSDate.
     @param date The NSDate which to convert NSString.
     @return A dateTime (YYYY-MM-DDThh:mm:ssZ) value from a date.
     */
    class func valueForDateTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: 0);
        
        // dateTime（YYYY-MM-DDThh:mm:ssZ）
        formatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'";
        
        return formatter.string(from: date);
        
    }

    /** Return the NSInteger object from a given string.
     @param value The string which to convert NSInteger. A value ≥0
     @return A NSInteger from a value.
     */
    class func nonNegativeInteger(_ value: String) -> Int {
        if let i = Int(value),
           i > 0 {
            return i;
        }
        return 0;
    }

    /** Return the NSString object from a given NSInteger.
     @param integer The NSInteger which to convert NSString. A value ≥0
     @return A NSString from a integer.
     */
    class func valueForNonNegativeInteger(_ integer: Int) -> String {
        if integer > 0 {
            return String(integer);
        }
        return "0";
    }
    
    
}

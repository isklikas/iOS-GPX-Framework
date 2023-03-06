//
//  GPX-Extensions.swift
//  GPX
//
//  Created by John Sklikas on 26/1/23.
//

import Foundation

let kGPXInvalidGPXFormatNotification = "kGPXInvalidGPXFormatNotification";
let kGPXDescriptionKey = "kGPXDescriptionKey";

public extension DispatchQueue {

    private static var _onceTracker = [String]()

    /**
     Executes a block of code, associated with a unique token, only once.  The code is thread safe and will
     only execute the code once even in the presence of multithreaded calls.

     - parameter token: A unique reverse DNS style name such as com.vectorform.<name> or a GUID
     - parameter block: Block to execute once
     */
    class func once(token: String, block:()->Void) {
        objc_sync_enter(self); defer { objc_sync_exit(self) }

        if _onceTracker.contains(token) {
            return
        }

        _onceTracker.append(token)
        block()
    }
}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
    /// Converts Degress to Radians
    func degToRadians() -> Double {
        return self * .pi / 180
    }
    
    /// Converts Radians to Degrees
    func radToDegrees() -> Double {
        return self * 180 / .pi
    }
}

extension StringProtocol {
    func index<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> Index? {
        range(of: string, options: options)?.lowerBound
    }
    func index<S: StringProtocol>(of string: S, lowestValue: Int, options: String.CompareOptions = []) -> Index? {
        let lowestIndex = index(startIndex, offsetBy: lowestValue)
        let subStringFromLeastPoint = suffix(from: lowestIndex)
        if let subIndex = subStringFromLeastPoint.range(of: string, options: options)?.lowerBound {
            let subIndexInt = subIndex.utf16Offset(in: subStringFromLeastPoint);
            let appearingIndexInt = subIndexInt + lowestValue;
            let appearingIndex = index(startIndex, offsetBy: appearingIndexInt);
            return appearingIndex;
        }
        return nil;
    }
    func index<S: StringProtocol>(of string: S, lowestValue: Int, options: String.CompareOptions = []) -> Int? {
        let lowestIndex = index(startIndex, offsetBy: lowestValue)
        let subStringFromLeastPoint = suffix(from: lowestIndex)
        if let subIndex = subStringFromLeastPoint.range(of: string, options: options)?.lowerBound {
            let subIndexInt = subIndex.utf16Offset(in: subStringFromLeastPoint);
            let appearingIndexInt = subIndexInt + lowestValue;
            return appearingIndexInt;
        }
        return nil;
    }
    func endIndex<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> Index? {
        range(of: string, options: options)?.upperBound
    }
    func indices<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> [Index] {
        ranges(of: string, options: options).map(\.lowerBound)
    }
    func ranges<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> [Range<Index>] {
        var result: [Range<Index>] = []
        var startIndex = self.startIndex
        while startIndex < endIndex,
            let range = self[startIndex...]
                .range(of: string, options: options) {
                result.append(range)
                startIndex = range.lowerBound < range.upperBound ? range.upperBound :
                    index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return result
    }
}

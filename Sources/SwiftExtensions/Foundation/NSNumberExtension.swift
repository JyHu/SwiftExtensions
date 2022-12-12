//
//  File.swift
//  
//
//  Created by Jo on 2022/10/31.
//

#if canImport(Foundation)

import Foundation

public extension NSNumber {
    
    /// Compare two numbers
    /// - Parameters:
    ///   - lhs: <#lhs description#>
    ///   - rhs: Compared number
    /// - Returns: <#description#>
    static func < (lhs: NSNumber, rhs: NSNumber) -> Bool {
        return lhs.compare(rhs) == .orderedAscending
    }
    
    static func <= (lhs: NSNumber, rhs: NSNumber) -> Bool {
        return lhs.compare(rhs) != .orderedDescending
    }
    
    static func >= (lhs: NSNumber, rhs: NSNumber) -> Bool {
        return lhs.compare(rhs) != .orderedAscending
    }
    
    static func > (lhs: NSNumber, rhs: NSNumber) -> Bool {
        return lhs.compare(rhs) == .orderedDescending
    }
    
    static func == (lhs: NSNumber, rhs: NSNumber) -> Bool {
        return lhs.isEqual(to: rhs)
    }
    
    static func != (lhs : NSNumber, rhs: NSNumber) -> Bool {
        return !lhs.isEqual(to: rhs)
    }
    
    static func + (lhs: NSNumber, rhs: NSNumber) -> NSDecimalNumber {
        return NSDecimalNumber(decimal: lhs.decimalValue)
            .adding(NSDecimalNumber(decimal: rhs.decimalValue))
    }
    
    static func - (lhs: NSNumber, rhs: NSNumber) -> NSDecimalNumber {
        return NSDecimalNumber(decimal: lhs.decimalValue)
            .subtracting(NSDecimalNumber(decimal: rhs.decimalValue))
    }
    
    static func * (lhs: NSNumber, rhs: NSNumber) -> NSDecimalNumber {
        return NSDecimalNumber(decimal: lhs.decimalValue)
            .multiplying(by: NSDecimalNumber(decimal: rhs.decimalValue))
    }
    
    static func / (lhs: NSNumber, rhs: NSNumber) -> NSDecimalNumber? {
        guard rhs.compare(NSNumber(value: 0)) != .orderedSame else {
            return nil
        }
        
        return NSDecimalNumber(decimal: lhs.decimalValue)
            .dividing(by: NSDecimalNumber(decimal: rhs.decimalValue))
    }
    
    static func % (lhs: NSNumber, rhs: NSNumber) -> NSDecimalNumber {
        let truncatingVal = lhs.doubleValue.truncatingRemainder(dividingBy: rhs.doubleValue)
        return NSDecimalNumber(decimal: NSNumber(value: truncatingVal).decimalValue)
    }
}

#endif

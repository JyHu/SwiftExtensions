//
//  File.swift
//  
//
//  Created by Jo on 2022/10/29.
//

import Foundation

public extension Array where Element: Equatable {

    /// Remove the first given object of current array.
    /// - Parameter element: The removed object
    /// - Returns: Removed index
    @discardableResult
    mutating func removeFirst(_ element: Element) -> Index? {
        guard let index = firstIndex(of: element) else { return nil }
        remove(at: index)
        return index
    }
    
    /// Remove the given object
    /// - Parameter object: The removed object
    /// - Returns: Removed index
    @discardableResult
    mutating func removeObject<T: Equatable>(object: T) -> Index? {
        var index: Int?
        for (idx, objectToCompare) in enumerated() {
            if let to = objectToCompare as? T, object == to {
                index = idx
                break
            }
        }
        
        if index != nil {
            remove(at: index!)
        }
        
        return index
    }
}

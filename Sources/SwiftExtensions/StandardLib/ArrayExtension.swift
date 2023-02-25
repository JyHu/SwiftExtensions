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
    
    func grouping<T>(completion: (([Element], Bool) -> T?)) -> [T] {
        var results: [T] = []
        var tmpGroup: [Element] = []
        for index in self.indices {
            tmpGroup.append(self[index])
            if let tmpRes = completion(tmpGroup, index == count - 1) {
                results.append(tmpRes)
                tmpGroup = []
            }
        }
        return results
    }
}

public extension Array where Element: Hashable {
    func toSet() -> Set<Element> {
        return Set(self)
    }
}

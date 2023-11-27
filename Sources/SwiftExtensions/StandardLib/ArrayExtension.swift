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
    mutating func remove<T: Equatable>(object: T) -> Index? {
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

public extension Array {
    /// 获取给定索引的数据
    /// - Parameter indexes: 索引列表
    /// - Returns: 对应的数据列表
    func objects(at indexes: IndexSet) -> [Element] {
        var results: [Element] = []
        for (index, element) in enumerated() {
            if indexes.contains(index) {
                results.append(element)
            }
        }

        return results
    }
}

public extension Array where Element: Any {
    func toAttributedString(attributes: [NSAttributedString.Key: Any] = [:], imageOffsetCreator: ((NSUIImage, Int) -> CGPoint)? = nil) -> NSMutableAttributedString? {
        return NSMutableAttributedString(sources: self, attributes: attributes, imageOffsetCreator: imageOffsetCreator)
    }
}

public extension Array where Element: Hashable {
    func toSet() -> Set<Element> {
        return Set(self)
    }
}

public extension Array where Element: Comparable {
    func differenceSet(from other: [Element]) -> (newest: [Element], oldest: [Element], intersection: [Element]) {
        var mutableSelf = self
        var mutableOther = other
        var intersections: [Element] = []
        
        for ele in mutableSelf {
            if other.contains(ele) {
                mutableSelf.remove(object: ele)
                mutableOther.remove(object: ele)
                intersections.append(ele)
            }
        }
        
        return (mutableOther, mutableSelf, intersections)
    }
}

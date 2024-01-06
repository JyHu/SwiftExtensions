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
    func toAttributedString(
        attributes: [NSAttributedString.Key: Any] = [:],
        imageOffsetCreator: NSAttributedString.AttributedImageCreator? = nil
    ) -> NSMutableAttributedString? {
        return NSMutableAttributedString(
            sources: self,
            attributes: attributes,
            imageOffsetCreator: imageOffsetCreator
        )
    }
}

public extension Array where Element: Comparable {
    
    /// 比较当前数组与给定数组的差异性，并返回比对结果
    /// - Description:
    ///     - 两个数组中都有的为交集数据
    ///     - 只有当前数组中才有的为旧的数据
    ///     - 只有other数组中才有的为新的数据
    /// - Parameter other: 需要比较的数组
    /// - Returns: 比较结果
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

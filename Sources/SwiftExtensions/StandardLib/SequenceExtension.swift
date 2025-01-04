//
//  File.swift
//  
//
//  Created by Jo on 2023/4/20.
//

import Foundation

public extension Sequence where Element: Equatable {
    /// Counts the number of elements in the sequence that satisfy the given condition.
    /// - Parameter isIncluded: A closure that takes an element of the sequence and returns a boolean value indicating whether the element satisfies the condition.
    /// - Returns: The number of elements that satisfy the condition.
    func count(where isIncluded: (Element) -> Bool) -> Int {
        return filter(isIncluded).count
    }
}

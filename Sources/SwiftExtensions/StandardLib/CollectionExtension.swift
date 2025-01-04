//
//  File.swift
//  
//
//  Created by Jo on 2022/10/29.
//

import Foundation

import Foundation

// MARK: - Collection Extension
public extension Collection {
    /// Safely retrieves an element at the specified index without causing out-of-bounds errors.
    ///
    /// - Parameter index: The index of the element to retrieve.
    /// - Returns: The element at the given index if it is within bounds; otherwise, `nil`.
    ///
    /// Example usage:
    /// ```swift
    /// let array = [10, 20, 30]
    /// let safeElement = array[safe: 1]   // Output: 20
    /// let outOfBounds = array[safe: 3]  // Output: nil
    /// ```
    subscript(safe index: Index) -> Element? {
        startIndex <= index && index < endIndex ? self[index] : nil
    }
    
    /// Checks if the collection is not empty.
    ///
    /// - Returns: `true` if the collection contains at least one element; otherwise, `false`.
    ///
    /// This is a convenience property for quickly determining if a collection has elements.
    ///
    /// Example usage:
    /// ```swift
    /// let array: [Int] = [1, 2, 3]
    /// print(array.isNotEmpty)  // Output: true
    ///
    /// let emptyArray: [Int] = []
    /// print(emptyArray.isNotEmpty)  // Output: false
    /// ```
    var isNotEmpty: Bool {
        return !isEmpty
    }
}

// MARK: - StringProtocol Extension
public extension StringProtocol {
    /// Finds the distance (as an integer) of a specific element within the string.
    ///
    /// - Parameter element: The character to locate.
    /// - Returns: The distance (index) of the character from the start of the string, or `nil` if not found.
    ///
    /// Example usage:
    /// ```swift
    /// let text = "Hello, World!"
    /// let distance = text.distance(of: "W")  // Output: 7
    /// ```
    func distance(of element: Element) -> Int? {
        firstIndex(of: element)?.distance(in: self)
    }
    
    /// Finds the distance (as an integer) of a specific substring within the string.
    ///
    /// - Parameter string: The substring to locate.
    /// - Returns: The distance (index) of the substring's start position from the beginning of the string, or `nil` if not found.
    ///
    /// Example usage:
    /// ```swift
    /// let text = "Hello, World!"
    /// let distance = text.distance(of: "World")  // Output: 7
    /// ```
    func distance<S: StringProtocol>(of string: S) -> Int? {
        range(of: string)?.lowerBound.distance(in: self)
    }
}

// MARK: - Collection Extension for Index Distance
public extension Collection {
    /// Calculates the distance (as an integer) from the collection's start index to the specified index.
    ///
    /// - Parameter index: The target index.
    /// - Returns: The distance from the start index to the target index.
    ///
    /// Example usage:
    /// ```swift
    /// let array = ["a", "b", "c", "d"]
    /// let distance = array.distance(to: array.index(array.startIndex, offsetBy: 2))
    /// print(distance)  // Output: 2
    /// ```
    func distance(to index: Index) -> Int {
        distance(from: startIndex, to: index)
    }
}

// MARK: - String.Index Extension
public extension String.Index {
    /// Calculates the distance (as an integer) of the current index within the given string.
    ///
    /// - Parameter string: The string in which the index is located.
    /// - Returns: The distance of the index from the string's start index.
    ///
    /// Example usage:
    /// ```swift
    /// let text = "Hello, World!"
    /// if let index = text.firstIndex(of: "W") {
    ///     let distance = index.distance(in: text)
    ///     print(distance)  // Output: 7
    /// }
    /// ```
    func distance<S: StringProtocol>(in string: S) -> Int {
        string.distance(to: self)
    }
}

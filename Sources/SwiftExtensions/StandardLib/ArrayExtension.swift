//
//  File.swift
//  
//
//  Created by Jo on 2022/10/29.
//

import Foundation

public extension Array where Element: Equatable {
    /// Removes the first occurrence of the specified element from the array.
    ///
    /// - Parameter element: The element to be removed.
    /// - Returns: The index of the removed element, or `nil` if the element was not found in the array.
    ///
    /// This method searches the array for the first occurrence of the given element, removes it,
    /// and then returns the index of the removed element. If the element is not found, it returns `nil`.
    ///
    /// Example usage:
    /// ```swift
    /// var array = [1, 2, 3, 4, 5]
    /// let removedIndex = array.removeFirst(3)
    /// print(array)         // Output: [1, 2, 4, 5]
    /// print(removedIndex)  // Output: 2
    /// ```
    @discardableResult
    mutating func removeFirst(_ element: Element) -> Index? {
        guard let index = firstIndex(of: element) else { return nil }
        remove(at: index)
        return index
    }

    /// Removes the first occurrence of the specified object from the array.
    ///
    /// - Parameter object: The object to be removed. The object must conform to the `Equatable` protocol.
    /// - Returns: The index of the removed object, or `nil` if the object was not found in the array.
    ///
    /// This method searches the array for the first occurrence of the given object, removes it,
    /// and then returns the index of the removed object. The object is compared using the `Equatable` protocol.
    ///
    /// Example usage:
    /// ```swift
    /// var array: [Any] = [1, "hello", 3.14, "world"]
    /// let removedIndex = array.remove(object: "hello")
    /// print(array)         // Output: [1, 3.14, "world"]
    /// print(removedIndex)  // Output: 1
    /// ```
    ///
    /// This method is particularly useful for heterogeneous arrays (`[Any]`) where you may need to
    /// remove objects of specific types.
    @discardableResult
    mutating func remove<T: Equatable>(object: T) -> Index? {
        var index: Int?
        
        // Iterate through the array to find the first occurrence of the specified object.
        for (idx, objectToCompare) in enumerated() {
            if let to = objectToCompare as? T, object == to {
                index = idx
                break
            }
        }
        
        // If the object was found, remove it from the array.
        if let validIndex = index {
            remove(at: validIndex)
        }
        
        return index
    }
}

public extension Array {
    /// Retrieves the elements at the specified indexes.
    ///
    /// - Parameter indexes: An `IndexSet` representing the list of indexes for the elements to retrieve.
    /// - Returns: An array containing the elements corresponding to the provided indexes.
    ///
    /// This method iterates through the array and checks if each element's index exists in the `indexes` set.
    /// If the index exists, the corresponding element is added to the results array.
    ///
    /// Example usage:
    /// ```swift
    /// let array = ["a", "b", "c", "d"]
    /// let indexes: IndexSet = [1, 3]
    /// let result = array.objects(at: indexes)
    /// print(result) // Output: ["b", "d"]
    /// ```
    func objects(at indexes: IndexSet) -> [Element] {
        var results: [Element] = []
        for (index, element) in enumerated() {
            if indexes.contains(index) {
                results.append(element)
            }
        }
        return results
    }

    /// Processes the array in groups of a specified size and applies a transformation to each group.
    ///
    /// - Parameters:
    ///   - groupCount: The number of elements in each group. Must be greater than zero.
    ///   - block: A closure that takes a subsequence of the array (a slice) and returns a transformed value of type `T?`.
    ///            If the closure returns `nil`, the result is not added to the output array.
    /// - Returns: An array of transformed values resulting from applying the closure to each group of elements.
    ///
    /// This method divides the array into groups of size `groupCount` and applies the provided closure to each group.
    /// If the array's size is not a multiple of `groupCount`, the final group may contain fewer elements.
    ///
    /// Example usage:
    /// ```swift
    /// let inputArray = ["1", "2", "3", "4", "5", "6", "7"]
    /// let result = inputArray.compactMap(groupCount: 2) { sub in
    ///     // Process each group: Convert each element to Int, add 1, and join them into a string.
    ///     return sub.compactMap({ String(describing: Int($0)! + 1) }).joined(separator: ", ")
    /// }.joined(separator: "\n")
    ///
    /// print(result)
    /// // Output:
    /// // 2, 3
    /// // 4, 5
    /// // 6, 7
    /// // 8
    /// ```
    func compactMap<T>(groupCount: Int, using block: (Array.SubSequence) -> T?) -> [T] {
        var result: [T] = []
        var start = 0
        
        // Validate that groupCount is greater than zero to avoid infinite loops.
        guard groupCount > 0 else { return result }
        
        // Iterate through the array, forming groups of `groupCount` elements.
        while start < count {
            let end = Swift.min(start + groupCount, count) // Ensure we don't exceed the array bounds.
            if let value = block(self[start..<end]) {
                result.append(value)
            }
            start = end // Move the start index to the next group.
        }
        
        return result
    }
    
    /// Returns a new array by appending the given element to the end of the array.
    ///
    /// This method does not modify the original array. It creates and returns a new array
    /// that includes all elements of the original array followed by the specified element.
    ///
    /// - Parameter element: The element to append to the array.
    /// - Returns: A new array with the appended element.
    ///
    /// # Example
    /// ```
    /// let numbers = [1, 2, 3]
    /// let newNumbers = numbers.appending(4)
    /// print(newNumbers) // Output: [1, 2, 3, 4]
    /// print(numbers)    // Output: [1, 2, 3] (original array is unchanged)
    /// ```
    func appending(_ element: Element) -> [Element] {
        return self + [element]
    }
    
    /// Groups the elements of the array into a dictionary based on a specified key generated by the provided closure.
    ///
    /// This method iterates over the array and applies the given closure to each element
    /// to determine the key for grouping. The result is a dictionary where the keys
    /// are the grouping keys, and the values are arrays of elements that share the same key.
    ///
    /// - Parameter converter: A closure that takes an element of the array as input and returns the key for grouping.
    /// - Returns: A dictionary where each key is a grouping key and the value is an array of elements belonging to that group.
    ///
    /// # Example
    /// ```
    /// let numbers = [1, 2, 3, 4, 5, 6]
    /// let groupedNumbers = numbers.grouped { $0 % 2 == 0 ? "Even" : "Odd" }
    /// print(groupedNumbers) // Output: ["Odd": [1, 3, 5], "Even": [2, 4, 6]]
    /// ```
    func grouped<GroupKey: Hashable>(converter: (Element) -> GroupKey) -> [GroupKey: [Element]] {
        return Dictionary(grouping: self, by: converter)
    }
    
    /// Groups and maps the elements of the array into a dictionary based on a specified key-value pair generated by the provided closure.
    ///
    /// This method iterates over the array and applies the given closure to each element
    /// to determine both the grouping key and the associated value for the group.
    /// If the closure returns `nil` for an element, that element is ignored. If the associated
    /// value is `nil`, it is also skipped.
    ///
    /// - Parameter converter: A closure that takes an element of the array as input
    ///   and returns an optional tuple `(GroupKey, GroupedValue?)?`, where:
    ///   - `GroupKey`: The key for grouping.
    ///   - `GroupedValue`: The value to include in the group.
    ///   - If the closure returns `nil`, the element is skipped.
    ///   - If the associated value is `nil`, that value is not added to the group.
    /// - Returns: A dictionary where each key is a grouping key and the value is an array
    ///   of associated grouped values.
    ///
    /// # Example
    /// ```
    /// let numbers = [1, 2, 3, 4, 5, 6]
    /// let groupedNumbers = numbers.groupMap { num in
    ///     guard num % 2 == 0 else { return nil } // Skip odd numbers
    ///     return ("Even", "\(num)")             // Group even numbers as strings
    /// }
    /// print(groupedNumbers) // Output: ["Even": ["2", "4", "6"]]
    /// ```
    ///
    /// # Example 2: Complex Grouping
    /// ```
    /// struct Item {
    ///     let category: String
    ///     let value: Int
    /// }
    ///
    /// let items = [
    ///     Item(category: "A", value: 10),
    ///     Item(category: "B", value: 20),
    ///     Item(category: "A", value: 30)
    /// ]
    ///
    /// let groupedItems = items.groupMap { item in
    ///     (item.category, item.value > 15 ? item.value : nil) // Skip values <= 15
    /// }
    /// print(groupedItems) // Output: ["B": [20], "A": [30]]
    /// ```
    func compactGrouped<GroupKey: Hashable, GroupedValue>(converter: (Element) -> (GroupKey, GroupedValue?)?) -> [GroupKey: [GroupedValue]] {
        var result: [GroupKey: [GroupedValue]] = [:]
        for element in self {
            guard let (key, value) = converter(element) else { continue }
            guard let value else { continue }
            result[key] = result[key, default: []].appending(value)
        }
        return result
    }
}

public extension Array where Element: Comparable {
    
    /// Compares the current array with another array and returns their differences and intersection.
    ///
    /// - Description:
    ///     - **Intersection**: Elements that exist in both arrays.
    ///     - **Old elements**: Elements that exist only in the current array.
    ///     - **New elements**: Elements that exist only in the `other` array.
    ///
    /// This method compares two arrays and categorizes their elements into three sets:
    /// - Elements common to both arrays (intersection).
    /// - Elements unique to the current array (oldest).
    /// - Elements unique to the `other` array (newest).
    ///
    /// - Parameter other: The array to compare with.
    /// - Returns: A tuple containing three arrays:
    ///     - `newest`: Elements found only in the `other` array.
    ///     - `oldest`: Elements found only in the current array.
    ///     - `intersection`: Elements found in both arrays.
    ///
    /// Example usage:
    /// ```swift
    /// let currentArray = [1, 2, 3, 4]
    /// let otherArray = [3, 4, 5, 6]
    /// let result = currentArray.differenceSet(from: otherArray)
    /// print("Newest: \(result.newest)")       // Output: [5, 6]
    /// print("Oldest: \(result.oldest)")       // Output: [1, 2]
    /// print("Intersection: \(result.intersection)") // Output: [3, 4]
    /// ```
    func differenceSet(from other: [Element]) -> (newest: [Element], oldest: [Element], intersection: [Element]) {
        var mutableSelf = self                  // Create a mutable copy of the current array.
        var mutableOther = other                // Create a mutable copy of the `other` array.
        var intersections: [Element] = []       // Array to store intersection elements.
        
        // Iterate through each element in the current array.
        for element in mutableSelf {
            if other.contains(element) {        // Check if the element exists in the `other` array.
                // Remove the element from both arrays as it belongs to the intersection.
                mutableSelf.remove(object: element)
                mutableOther.remove(object: element)
                intersections.append(element)
            }
        }
        
        // Return the categorized elements as a tuple.
        return (newest: mutableOther, oldest: mutableSelf, intersection: intersections)
    }
}

public extension Array where Element: Any {
    /// Converts the array's elements into an `NSMutableAttributedString`.
    ///
    /// - Parameters:
    ///   - attributes: The default attributes to apply to the resulting attributed string.
    ///   - imageOffsetCreator: An optional closure for determining the offset of any images in the array.
    ///
    /// - Returns: An `NSMutableAttributedString` containing all elements of the array, or `nil` if the array is empty.
    ///
    /// - Example:
    ///   ```swift
    ///   let array: [Any] = ["Text", UIImage(named: "icon")!, "More Text"]
    ///   let attributedString = array.toAttributedString(
    ///       attributes: [.font: UIFont.systemFont(ofSize: 16)],
    ///       imageOffsetCreator: { _, _ in CGPoint(x: 0, y: -5) }
    ///   )
    ///   ```
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
    
    /// Joins the array's elements into a single `NSMutableAttributedString`, separated by a specified plain string.
    ///
    /// - Parameters:
    ///   - separator: A plain string used as a separator between elements in the resulting attributed string.
    ///   - attributes: The default attributes to apply to the resulting attributed string.
    ///   - imageOffsetCreator: An optional closure for determining the offset of any images in the array.
    ///
    /// - Returns: An `NSMutableAttributedString` containing all elements of the array
    ///       joined by the separator, or `nil` if the array is empty.
    ///
    /// - Example:
    ///   ```swift
    ///   let array: [Any] = ["Hello", UIImage(named: "icon")!, "World"]
    ///   let attributedString = array.attributedJoined(
    ///       ", ",
    ///       attributes: [.foregroundColor: UIColor.red],
    ///       imageOffsetCreator: { _, _ in CGPoint(x: 0, y: -10) }
    ///   )
    ///   ```
    func attributedStringByJoined(
        _ separator: String,
        attributes: [NSAttributedString.Key: Any] = [:],
        imageOffsetCreator: NSAttributedString.AttributedImageCreator? = nil
    ) -> NSMutableAttributedString? {
        return NSMutableAttributedString(
            sources: self,
            separator: separator,
            attributes: attributes,
            imageOffsetCreator: imageOffsetCreator
        )
    }
    
    /// Joins the array's elements into a single `NSMutableAttributedString`, separated by an `NSAttributedString`.
    ///
    /// - Parameters:
    ///   - separator: An attributed string used as a separator between elements in the resulting attributed string.
    ///   - attributes: The default attributes to apply to the resulting attributed string.
    ///   - imageOffsetCreator: An optional closure for determining the offset of any images in the array.
    ///
    /// - Returns: An `NSMutableAttributedString` containing all elements of the array
    ///       joined by the separator, or `nil` if the array is empty.
    ///
    /// - Example:
    ///   ```swift
    ///   let separator = NSAttributedString(string: " | ", attributes: [.foregroundColor: UIColor.blue])
    ///   let array: [Any] = ["Part 1", UIImage(named: "icon")!, "Part 2"]
    ///   let attributedString = array.attributedJoined(
    ///       separator,
    ///       attributes: [.font: UIFont.boldSystemFont(ofSize: 18)],
    ///       imageOffsetCreator: nil
    ///   )
    ///   ```
    func attributedStringByJoined(
        _ separator: NSAttributedString,
        attributes: [NSAttributedString.Key: Any] = [:],
        imageOffsetCreator: NSAttributedString.AttributedImageCreator? = nil
    ) -> NSMutableAttributedString? {
        return NSMutableAttributedString(
            sources: self,
            separator: separator,
            attributes: attributes,
            imageOffsetCreator: imageOffsetCreator
        )
    }
}

public extension Array where Element: Any {
    func componentsJoined(by separator: String) -> String {
        return map { String(describing: $0) }.joined(separator: separator)
    }
}

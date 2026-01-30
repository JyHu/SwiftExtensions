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

public extension Collection {
    /// 将数组转换为字典，使用指定的闭包生成 Key
    ///
    /// **使用场景**：
    /// - 将数组按某个属性分组，方便后续通过 Key 快速查找
    /// - 避免重复遍历数组进行查找（O(n) → O(1)）
    ///
    /// **典型用法**：
    /// ```swift
    /// let users = [User(id: "1", name: "Alice"), User(id: "2", name: "Bob")]
    /// let userMap = users.toMap { $0.id }
    /// // 结果：["1": User(id: "1", ...), "2": User(id: "2", ...)]
    ///
    /// // 快速查找
    /// if let user = userMap["1"] {
    ///     print(user.name)  // "Alice"
    /// }
    /// ```
    ///
    /// **在框架中的使用**：
    /// - 将 CloudKit Records 按 recordID 分组
    /// - 将本地数据按 id 分组，方便冲突比较
    /// - 将 Zones/Subscriptions 按 name/id 分组
    ///
    /// **注意**：
    /// - 如果有重复的 Key，后面的元素会覆盖前面的元素
    /// - 确保 Key 的唯一性，或者使用 Dictionary(grouping:) 代替
    ///
    /// - Parameter block: 从数组元素生成字典 Key 的闭包
    /// - Returns: 转换后的字典 [Key: Element]
    func toMap<K>(_ block: (Element) -> K) -> [K: Element] {
        var map: [K: Element] = [:]
        for element in self {
            map[block(element)] = element
        }
        return map
    }
}

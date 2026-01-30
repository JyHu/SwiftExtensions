//
//  File.swift
//  
//
//  Created by Jo on 2022/10/29.
//

#if canImport(Foundation)
import Foundation
#endif

public extension Dictionary {
    
    /// Check whether the dictionary contains the given key.
    ///
    /// - Description:
    ///     - This method checks if the dictionary contains a value for the specified key.
    ///     - It returns `true` if the dictionary has the key, and `false` otherwise.
    ///
    /// - Parameter key: The key to check for in the dictionary.
    /// - Returns: `true` if the dictionary contains the key, `false` otherwise.
    ///
    /// Example usage:
    /// ```swift
    /// let dict = ["a": 1, "b": 2]
    /// let result = dict.has(key: "a") // Result: true
    /// ```
    func has(key: Key) -> Bool {
        return index(forKey: key) != nil
    }
    
    /// Get all keys in a dictionary.
    ///
    /// - Description:
    ///     - This property retrieves all the keys in the dictionary as an array.
    ///     - It returns an array containing all the keys from the dictionary.
    ///
    /// - Returns: An array of all keys in the dictionary.
    ///
    /// Example usage:
    /// ```swift
    /// let dict = ["a": 1, "b": 2]
    /// let keys = dict.allKeys // Result: ["a", "b"]
    /// ```
    var allKeys: [Key] {
        return keys.map { $0 }
    }
    
    /// Remove all values of the given keys.
    ///
    /// - Description:
    ///     - This method removes the values associated with the specified keys from the dictionary.
    ///     - It takes a sequence of keys and removes the corresponding entries in the dictionary.
    ///
    /// - Parameter keys: A sequence of keys whose associated values should be removed.
    /// - Returns: None
    ///
    /// Example usage:
    /// ```swift
    /// var dict = ["a": 1, "b": 2, "c": 3]
    /// dict.removeAll(keys: ["a", "c"])
    /// // Resulting dictionary: ["b": 2]
    /// ```
    mutating func removeAll<S: Sequence>(keys: S) where S.Element == Key {
        keys.forEach { removeValue(forKey: $0) }
    }
}

public extension Dictionary {
    
    /// Accesses a deeply nested value using an array of keys representing the path.
    ///
    /// - Description:
    ///     - This subscript allows you to access values in deeply nested dictionaries using an array of keys.
    ///     - It iterates through the dictionary for each key in the path and returns the final value at the last key.
    ///     - If any key along the path is missing or doesn't match, `nil` is returned.
    ///
    /// - Parameters:
    ///   - pathItems: An array of keys representing the path to access the nested value.
    /// - Returns: The value found at the end of the path, or `nil` if the path is invalid.
    ///
    /// Example usage:
    /// ```swift
    /// let dict = [
    ///     "key1": [
    ///         "key2": [
    ///             "key3": "value"
    ///         ]
    ///     ]
    /// ]
    ///
    /// let value = dict[path: ["key1", "key2", "key3"]]
    /// // Result: "value"
    /// ```
    subscript(path pathItems: [Key]) -> Any? {
        get {
            guard !pathItems.isEmpty else { return nil }
            
            var result: Any? = self
            for key in pathItems {
                // Check if the current value is a dictionary and retrieve the value for the current key
                guard let element = (result as? [Key: Any])?[key] else {
                    return nil // Return nil if the key doesn't exist or the value is not a dictionary
                }
                
                result = element // Move to the next level in the path
            }
            
            return result // Return the final value if the path is valid
        }
        set {
            guard let currentKey = pathItems.first else {
                return // Do nothing if the path is empty
            }
            
            if pathItems.count == 1, let new = newValue as? Value {
                // If there is only one key in the path, set the value at that key
                return self[currentKey] = new
            }
            
            if var children = self[currentKey] as? [Key: Any] {
                // If there are more keys in the path, recursively set the nested value
                children[path: Array(pathItems.dropFirst())] = newValue
                // Update the value at the current key with the modified nested dictionary
                return self[currentKey] = children as? Value
            }
        }
    }
    
    /// Accesses a deeply nested value using a slash-separated string path.
    ///
    /// - Description:
    ///     - This subscript allows you to access deeply nested values using a string path where keys are separated by a custom separator (default is "/").
    ///     - The string path is split into an array of keys using the separator, and then the `path` subscript is used to retrieve the value.
    ///
    /// - Parameters:
    ///   - route: A string representing the path, with keys separated by a separator (default is "/").
    ///   - separator: The separator used to split the path string (default is "/").
    /// - Returns: The value found at the end of the path, or `nil` if the path is invalid.
    ///
    /// Example usage:
    /// ```swift
    /// let dict = [
    ///     "k1": [
    ///         "k2": [
    ///             "k3": [
    ///                 "k4": "value"
    ///             ]
    ///         ]
    ///     ]
    /// ]
    ///
    /// let value = dict[path: "k1/k2/k3/k4"]
    /// // Result: "value"
    /// ```
    subscript(path route: String, separator: String = "/") -> Any? {
        // Split the string path into components using the separator
        guard let components = route.components(separatedBy: separator).map({ String($0) }) as? [Key] else { return nil }
        return self[path: components] // Call the path subscript with the array of components
    }
}

public extension Dictionary {

    /// Merges two dictionaries (`lhs` and `rhs`) into one.
    ///
    /// - Description:
    ///     - This method merges two dictionaries by combining their key-value pairs.
    ///     - If both dictionaries have the same key, the value from the `rhs` dictionary will overwrite the value in the `lhs` dictionary.
    ///
    /// - Parameters:
    ///   - lhs: The first dictionary.
    ///   - rhs: The second dictionary to be merged with the first.
    /// - Returns: A new dictionary containing the merged key-value pairs from both dictionaries.
    ///
    /// Example usage:
    /// ```swift
    /// let dict1 = ["a": 1, "b": 2]
    /// let dict2 = ["b": 3, "c": 4]
    ///
    /// let mergedDict = dict1 + dict2
    /// // Result: ["a": 1, "b": 3, "c": 4]
    /// ```
    static func + (lhs: [Key: Value], rhs: [Key: Value]) -> [Key: Value] {
        var result = lhs
        rhs.forEach { result[$0] = $1 }  // Add or overwrite keys from rhs to lhs
        return result  // Return the merged dictionary
    }

    /// Merges the `rhs` dictionary into the `lhs` dictionary, modifying `lhs` in place.
    ///
    /// - Description:
    ///     - This method merges two dictionaries by adding the key-value pairs from `rhs` into `lhs`.
    ///     - If both dictionaries have the same key, the value from `rhs` will overwrite the value in `lhs`.
    ///
    /// - Parameters:
    ///   - lhs: The dictionary to be modified.
    ///   - rhs: The dictionary whose key-value pairs will be added to `lhs`.
    ///
    /// Example usage:
    /// ```swift
    /// var dict1 = ["a": 1, "b": 2]
    /// let dict2 = ["b": 3, "c": 4]
    ///
    /// dict1 += dict2
    /// // Result: dict1 = ["a": 1, "b": 3, "c": 4]
    /// ```
    static func += (lhs: inout [Key: Value], rhs: [Key: Value]) {
        rhs.forEach { lhs[$0] = $1 }  // Add or overwrite keys from rhs to lhs in place
    }

    /// Removes the key-value pairs from the dictionary (`lhs`) based on the provided keys (`keys`).
    ///
    /// - Description:
    ///     - This method removes the key-value pairs in `lhs` where the key exists in the `keys` sequence.
    ///
    /// - Parameters:
    ///   - lhs: The dictionary from which key-value pairs will be removed.
    ///   - keys: A sequence of keys to remove from the dictionary.
    /// - Returns: A new dictionary with the specified keys removed.
    ///
    /// Example usage:
    /// ```swift
    /// let dict = ["a": 1, "b": 2, "c": 3]
    /// let keysToRemove = ["a", "c"]
    ///
    /// let newDict = dict - keysToRemove
    /// // Result: ["b": 2]
    /// ```
    static func - <S: Sequence>(lhs: [Key: Value], keys: S) -> [Key: Value] where S.Element == Key {
        var result = lhs
        result.removeAll(keys: keys)  // Remove the keys specified in the sequence
        return result  // Return the modified dictionary
    }

    /// Removes the key-value pairs from the dictionary (`lhs`) based on the provided keys (`keys`), modifying `lhs` in place.
    ///
    /// - Description:
    ///     - This method removes the key-value pairs in `lhs` where the key exists in the `keys` sequence.
    ///
    /// - Parameters:
    ///   - lhs: The dictionary to be modified.
    ///   - keys: A sequence of keys to remove from the dictionary.
    ///
    /// Example usage:
    /// ```swift
    /// var dict = ["a": 1, "b": 2, "c": 3]
    /// let keysToRemove = ["a", "c"]
    ///
    /// dict -= keysToRemove
    /// // Result: dict = ["b": 2]
    /// ```
    static func -= <S: Sequence>(lhs: inout [Key: Value], keys: S) where S.Element == Key {
        lhs.removeAll(keys: keys)  // Remove the keys specified in the sequence, modifying lhs in place
    }
}

public extension Dictionary {
    
    /// Returns the value for the specified key, casted to `UInt`. If the key doesn't exist or the value cannot be cast, the default value is returned.
    ///
    /// - Parameters:
    ///   - key: The key for which the value is retrieved.
    ///   - defaultValue: An optional default value to return if the key doesn't exist or the value cannot be cast. Defaults to `nil`.
    /// - Returns: The value for the key casted to `UInt`, or the default value if the key doesn't exist or the cast fails.
    ///
    /// Example:
    /// ```swift
    /// let dict: [String: Any] = ["age": 30]
    /// let age: UInt? = dict.uintValue(for: "age")  // Returns 30 as a UInt
    /// ```
    func uintValue(for key: Key, defaultValue: UInt? = nil) -> UInt? {
        return object(for: key, defaultValue: defaultValue)
    }
    
    /// Returns the value for the specified key, casted to `Int`. If the key doesn't exist or the value cannot be cast, the default value is returned.
    ///
    /// - Parameters:
    ///   - key: The key for which the value is retrieved.
    ///   - defaultValue: An optional default value to return if the key doesn't exist or the value cannot be cast. Defaults to `nil`.
    /// - Returns: The value for the key casted to `Int`, or the default value if the key doesn't exist or the cast fails.
    func intValue(for key: Key, defaultValue: Int? = nil) -> Int? {
        return object(for: key, defaultValue: defaultValue)
    }
    
    /// Returns the value for the specified key, casted to `Float`. If the key doesn't exist or the value cannot be cast, the default value is returned.
    ///
    /// - Parameters:
    ///   - key: The key for which the value is retrieved.
    ///   - defaultValue: An optional default value to return if the key doesn't exist or the value cannot be cast. Defaults to `nil`.
    /// - Returns: The value for the key casted to `Float`, or the default value if the key doesn't exist or the cast fails.
    func floatValue(for key: Key, defaultValue: Float? = nil) -> Float? {
        return object(for: key, defaultValue: defaultValue)
    }
    
    /// Returns the value for the specified key, casted to `CGFloat`. If the key doesn't exist or the value cannot be cast, the default value is returned.
    ///
    /// - Parameters:
    ///   - key: The key for which the value is retrieved.
    ///   - defaultValue: An optional default value to return if the key doesn't exist or the value cannot be cast. Defaults to `nil`.
    /// - Returns: The value for the key casted to `CGFloat`, or the default value if the key doesn't exist or the cast fails.
    func cgfloatValue(for key: Key, defaultValue: CGFloat? = nil) -> CGFloat? {
        return object(for: key, defaultValue: defaultValue)
    }
    
    /// Returns the value for the specified key, casted to `String`. If the key doesn't exist or the value cannot be cast, the default value is returned.
    ///
    /// - Parameters:
    ///   - key: The key for which the value is retrieved.
    ///   - defaultValue: An optional default value to return if the key doesn't exist or the value cannot be cast. Defaults to `nil`.
    /// - Returns: The value for the key casted to `String`, or the default value if the key doesn't exist or the cast fails.
    func stringValue(for key: Key, defaultValue: String? = nil) -> String? {
        return object(for: key, defaultValue: defaultValue)
    }
    
    /// Returns the value for the specified key, casted to `Bool`. If the key doesn't exist or the value cannot be cast, the default value is returned.
    ///
    /// - Parameters:
    ///   - key: The key for which the value is retrieved.
    ///   - defaultValue: An optional default value to return if the key doesn't exist or the value cannot be cast. Defaults to `nil`.
    /// - Returns: The value for the key casted to `Bool`, or the default value if the key doesn't exist or the cast fails.
    func boolValue(for key: Key, defaultValue: Bool? = nil) -> Bool? {
        return object(for: key, defaultValue: defaultValue)
    }
    
    /// A helper method that retrieves and casts the value for the specified key to the given type `S`, or returns the default value if the cast fails or the key doesn't exist.
    ///
    /// - Parameters:
    ///   - key: The key for which the value is retrieved.
    ///   - defaultValue: An optional default value to return if the key doesn't exist or the value cannot be cast. Defaults to `nil`.
    /// - Returns: The value for the key casted to type `S`, or the default value if the key doesn't exist or the cast fails.
    func object<S>(for key: Key, defaultValue: S?) -> S? {
        return self[key] as? S ?? defaultValue
    }
}

public extension Dictionary {
    
    /// Merges the current dictionary with another dictionary, updating the current dictionary in place.
    ///
    /// - Description:
    ///     - This method updates the current dictionary by merging it with another dictionary (`other`).
    ///     - For each key in the `other` dictionary, if the key exists in the current dictionary,
    ///       the existing value will be kept (as defined by the closure `merge` logic).
    ///     - In this case, the closure simply returns the current value (ignoring the value from `other`).
    ///
    /// - Parameter other: The dictionary whose key-value pairs are to be merged with the current dictionary.
    ///
    /// Example usage:
    /// ```swift
    /// var dict1: [String: Int] = ["a": 1, "b": 2]
    /// let dict2: [String: Int] = ["b": 3, "c": 4]
    ///
    /// dict1.merge(dict2)
    /// // Result:
    /// // dict1 = ["a": 1, "b": 2, "c": 4]
    /// ```
    ///
    /// - Note:
    ///     - The value of `"b"` remains `2` (from `dict1`), and the key-value pair `"c": 4` is added from `dict2`.
    mutating func merge(_ other: [Key: Value]) {
        merge(other) { current, _ in current }  // Keeps the current value when a conflict arises.
    }
    
    /// Merges the current dictionary with another dictionary, returning a new dictionary.
    ///
    /// - Description:
    ///     - This method creates a new dictionary by merging the current dictionary with another dictionary (`other`).
    ///     - The resulting dictionary will contain all the key-value pairs from both dictionaries.
    ///     - If any key exists in both dictionaries, the value from the current dictionary is kept (as defined by the closure `merge` logic).
    ///
    /// - Parameter other: The dictionary whose key-value pairs are to be merged with the current dictionary.
    ///
    /// - Returns: A new dictionary that contains the merged key-value pairs.
    ///
    /// Example usage:
    /// ```swift
    /// let dict1: [String: Int] = ["a": 1, "b": 2]
    /// let dict2: [String: Int] = ["b": 3, "c": 4]
    ///
    /// let mergedDict = dict1.merging(dict2)
    /// // Result:
    /// // mergedDict = ["a": 1, "b": 2, "c": 4]
    /// ```
    ///
    /// - Note:
    ///     - The value of `"b"` remains `2` (from `dict1`), and the key-value pair `"c": 4` is added from `dict2`.
    func merging(_ other: [Key: Value]) -> [Key: Value] {
        var dict = self
        dict.merge(other)  // Merge the dictionaries and return the modified version.
        return dict  // Return the new dictionary.
    }
}

public extension Dictionary where Value: Comparable, Value: Hashable {
    
    /// Groups the dictionary's keys based on their corresponding values.
    ///
    /// - Description:
    ///     - This method groups the dictionary's keys by their associated values.
    ///     - It returns a new dictionary where each key is a unique value from the original dictionary,
    ///       and the associated value is an array of keys that have the same value in the original dictionary.
    ///     - If multiple keys have the same value, they are grouped together under that value in the result.
    ///
    /// - Returns: A dictionary where the keys are the unique values from the original dictionary,
    ///            and the values are arrays of keys that share the same value.
    ///
    /// Example usage:
    /// ```swift
    /// let dict: [String: String] = [
    ///     "a": "f",
    ///     "b": "f",
    ///     "c": "g",
    ///     "d": "h",
    ///     "e": "h"
    /// ]
    ///
    /// let grouped = dict.groupedByValues()
    ///
    /// // Result:
    /// // [
    /// //   "f": ["a", "b"],
    /// //   "g": ["c"],
    /// //   "h": ["d", "e"]
    /// // ]
    /// ```
    ///
    /// In this example, the dictionary's keys are grouped by their values. The keys `"a"` and `"b"` share the value `"f"`,
    /// so they are grouped together under the key `"f"`. Similarly, `"d"` and `"e"` share the value `"h"`, and `"c"` has the unique
    /// value `"g"`.
    ///
    /// - Returns: A dictionary where the keys are the unique values from the original dictionary,
    ///            and the values are arrays of keys that share the same value.
    func groupedByValues() -> [Value: [Key]] {
        var converted: [Value: [Key]] = [:]  // Initialize the result dictionary.
        
        // Iterate through the original dictionary to group keys by their values.
        for (key, value) in self {
            // If a group for this value already exists, append the current key; otherwise, create a new group.
            var cachedGroup = converted[value] ?? []
            cachedGroup.append(key)
            
            // Save the updated group back into the dictionary.
            converted[value] = cachedGroup
        }
        
        // Return the dictionary with grouped keys.
        return converted
    }
}

public extension Dictionary {
    
    /// Groups the dictionary's key-value pairs by a given criterion.
    ///
    /// - Description:
    ///     - This method groups the dictionary's elements by a custom criterion provided in the `convert` closure.
    ///     - The closure takes each key-value pair and returns a new key (`GroupKey`) that will be used to group the entries.
    ///     - The result is a dictionary where each group key maps to a dictionary of key-value pairs belonging to that group.
    ///
    /// - Parameters:
    ///   - convert: A closure that accepts a key-value pair and returns a new key that defines the group.
    ///             The closure's return type must conform to `Hashable`, as it will be used as a dictionary key.
    ///
    /// - Returns: A dictionary where the keys are the result of the `convert` closure, and the values are dictionaries containing
    ///            key-value pairs from the original dictionary that belong to that group.
    ///
    /// Example usage:
    /// ```swift
    /// let dict0: [String: Any] = [
    ///     "aa": "1",
    ///     "ab": "2",
    ///     "bc": "3",
    ///     "bd": "4",
    ///     "ee": "5",
    ///     "eg": "6"
    /// ]
    ///
    /// let res0 = dict0.grouped { key, _ in
    ///     return String(describing: key.first!)  // Grouping by the first letter of the key
    /// }
    ///
    /// // Result:
    /// // [
    /// //     "a": ["aa": "1", "ab": "2"],
    /// //     "e": ["ee": "5", "eg": "6"],
    /// //     "b": ["bd": "4", "bc": "3"]
    /// // ]
    /// ```
    ///
    /// In this example, the dictionary is grouped by the first letter of each key, creating a new dictionary where each group is
    /// a dictionary containing key-value pairs from the original dictionary with the same starting letter.
    ///
    /// - Returns: A dictionary where the keys are group keys (of type `GroupKey`), and the values are dictionaries of key-value pairs
    ///            that belong to that group.
    func grouped<GroupKey>(convert: (Key, Value) -> GroupKey) -> [GroupKey: [Key: Value]] where GroupKey: Hashable {
        var converted: [GroupKey: [Key: Value]] = [:]  // Initialize the result dictionary.
        
        // Iterate through the dictionary and apply the grouping logic.
        for (key, value) in self {
            let groupKey = convert(key, value)  // Get the group key by applying the `convert` closure.
            
            // Get the existing group (if any) for the group key, or create an empty dictionary.
            var cachedGroup = converted[groupKey] ?? [:]
            
            // Add the key-value pair to the appropriate group.
            cachedGroup[key] = value
            
            // Save the updated group back into the dictionary.
            converted[groupKey] = cachedGroup
        }
        
        // Return the dictionary with grouped key-value pairs.
        return converted
    }
}

/// Dictionary 扩展，提供增强版的 compactMapValues 方法
extension Dictionary {
    /// 转换字典的 Value，并过滤掉 nil 结果（同时提供 Key 和 Value）
    ///
    /// **与标准库 compactMapValues 的区别**：
    /// - 标准库：transform 只接收 Value
    /// - 这个方法：transform 同时接收 Key 和 Value
    ///
    /// **使用场景**：
    /// - 转换时需要同时使用 Key 和 Value 的信息
    /// - 根据 Key 和 Value 的组合决定是否保留该项
    ///
    /// **典型用法**：
    /// ```swift
    /// let saveResults: [CKRecord.ID: Result<CKRecord, Error>] = ...
    ///
    /// // 只保留成功的记录，并提取 recordName 和 record
    /// let successMap = saveResults.compactMapValues2 { recordID, result in
    ///     if case .success(let record) = result {
    ///         return (recordID.recordName, record)  // 同时使用 Key 和 Value
    ///     }
    ///     return nil
    /// }
    /// ```
    ///
    /// **在框架中的使用**：
    /// - 处理 CloudKit modifyRecords 的结果
    /// - 同时需要 recordID（Key）和 Result（Value）的信息
    /// - 过滤成功/失败的记录，并提取有用的信息
    ///
    /// **性能**：
    /// - 遍历一次字典，O(n)
    /// - 只保留 transform 返回非 nil 的项
    ///
    /// - Parameter transform: 转换闭包，接收 (Key, Value)，返回新的 Value 或 nil
    /// - Returns: 转换并过滤后的字典
    /// - Throws: transform 闭包抛出的错误
    func compactMapValues2<T>(_ transform: (Key, Value) throws -> T?) rethrows -> [Key: T] {
        var dict: [Key: T] = [:]
        for (key, value) in self {
            if let newValue = try transform(key, value) {
                dict[key] = newValue
            }
        }
        return dict
    }
}

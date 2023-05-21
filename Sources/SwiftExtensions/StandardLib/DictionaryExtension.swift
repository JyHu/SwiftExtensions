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
    /// - Parameter key: Checked key.
    /// - Returns: Contains
    func has(key: Key) -> Bool {
        return index(forKey: key) != nil
    }
    
    /// Remove all values of the given keys.
    /// - Parameter keys: The keys to be removed.
    mutating func removeAll<S: Sequence>(keys: S) where S.Element == Key {
        keys.forEach { removeValue(forKey: $0) }
    }
}

public extension Dictionary {
    
    ///
    /// let dict = [
    ///     "key1": [
    ///         "key2": [
    ///             "key3": "value"
    ///         ]
    ///     }
    /// ]
    ///
    /// let value = dict[path: ["key1", "key2", "key3"]]
    ///
    subscript(path pathItems: [Key]) -> Any? {
        get {
            guard !pathItems.isEmpty else { return nil }
            
            var result: Any? = self
            for key in pathItems {
                guard let element = (result as? [Key: Any])?[key] else {
                    return nil
                }
                
                result = element
            }
            
            return result
        }
        set {
            guard let currentKey = pathItems.first else {
                return
            }
            
            if pathItems.count == 1, let new = newValue as? Value {
                return self[currentKey] = new
            }
            
            if var children = self[currentKey] as? [Key: Any] {
                children[path: Array(pathItems.dropFirst())] = newValue
                return self[currentKey] = children as? Value
            }
        }
    }
    
    ///
    /// dict[path: "k1/k2/k3/k4"]
    subscript(path route: String, separtor: String = "/") -> Any? {
        guard let components = route.components(separatedBy: separtor).map({ String($0) }) as? [Key] else { return nil }
        return self[path: components]
    }
}

public extension Dictionary {
    static func + (lhs: [Key: Value], rhs: [Key: Value]) -> [Key: Value] {
        var result = lhs
        rhs.forEach { result[$0] = $1 }
        return result
    }
    
    static func += (lhs: inout [Key: Value], rhs: [Key: Value]) {
        rhs.forEach { lhs[$0] = $1 }
    }
    
    static func - <S: Sequence>(lhs: [Key: Value], keys: S) -> [Key: Value] where S.Element == Key {
        var result = lhs
        result.removeAll(keys: keys)
        return result
    }
    
    static func -= <S: Sequence>(lhs: inout [Key: Value], keys: S) where S.Element == Key {
        lhs.removeAll(keys: keys)
    }
}

public extension Dictionary {
    func uintValue(for key: Key, defaultValue: UInt? = nil) -> UInt? {
        return object(for: key, defaultValue: defaultValue)
    }
    
    func intValue(for key: Key, defaultValue: Int? = nil) -> Int? {
        return object(for: key, defaultValue: defaultValue)
    }
    
    func floatValue(for key: Key, defaultValue: Float? = nil) -> Float? {
        return object(for: key, defaultValue: defaultValue)
    }
    
    func cgfloatValue(for key: Key, defaultValue: CGFloat? = nil) -> CGFloat? {
        return object(for: key, defaultValue: defaultValue)
    }
    
    func stringValue(for key: Key, defaultValue: String? = nil) -> String? {
        return object(for: key, defaultValue: defaultValue)
    }
    
    func boolValue(for key: Key, defaultValue: Bool? = nil) -> Bool? {
        return object(for: key, defaultValue: defaultValue)
    }
    
    func object<S>(for key: Key, defaultValue: S?) -> S? {
        return self[key] as? S ?? defaultValue
    }
}

public extension Dictionary {
    mutating func merge(_ other: [Key : Value]) {
        merge(other) { current, _ in current }
    }
    
    func merging(_ other: [Key: Value]) -> [Key: Value] {
        var dict = self
        dict.merge(other)
        return dict
    }
}

public extension Dictionary where Value: Comparable, Value: Hashable {
    ///
    /// [
    ///   "a": "f",
    ///   "b": "f",
    ///   "c": "g",
    ///   "d": "h",
    ///   "e": "h"
    /// ]
    ///
    /// --->
    /// [
    ///   "f": ["a", "b"],
    ///   "g": ["c"],
    ///   "h": ["d", "e"]
    /// ]
    func groupedByValues() -> [Value: [Key]] {
        var converted: [Value: [Key]] = [:]
        for (key, value) in self {
            var cachedGroup = converted[value] ?? []
            cachedGroup.append(key)
            converted[value] = cachedGroup
        }
        return converted
    }
}

public extension Dictionary {
    
    ///
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
    ///     return String(describing: key.first!)
    /// }
    ///
    /// --->
    /// [
    ///     "a": ["aa": "1", "ab": "2"],
    ///     "e": ["ee": "5", "eg": "6"],
    ///     "b": ["bd": "4", "bc": "3"]
    /// ]
    ///
    func grouped<GroupKey>(convert: (Key, Value) -> GroupKey) -> [GroupKey: [Key: Value]] where GroupKey: Hashable {
        var converted: [GroupKey: [Key: Value]] = [:]
        for (key, value) in self {
            let groupKey = convert(key, value)
            var cachedGroup = converted[groupKey] ?? [:]
            cachedGroup[key] = value
            converted[groupKey] = cachedGroup
        }
        return converted
    }
}

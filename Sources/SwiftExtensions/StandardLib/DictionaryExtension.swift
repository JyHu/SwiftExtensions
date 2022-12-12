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
    /// let value = dict["key1", "key2", "key3"]
    ///
    subscript(path: [Key]) -> Any? {
        get {
            guard !path.isEmpty else { return nil }
            
            var result: Any? = self
            for key in path {
                guard let element = (result as? [Key: Any])?[key] else {
                    return nil
                }
                
                result = element
            }
            
            return result
        }
        set {
            guard let currentKey = path.first else {
                return
            }
            
            if path.count == 1, let new = newValue as? Value {
                return self[currentKey] = new
            }
            
            if var children = self[currentKey] as? [Key: Any] {
                children[Array(path.dropFirst())] = newValue
                return self[currentKey] = children as? Value
            }
        }
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
}

public extension Dictionary where Value: Comparable, Value: Hashable {
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

public extension Dictionary where Key: StringProtocol {
    func toURLQueryParams() -> String {
        return map { "\($0.key)=\($0.value)" }.joined(separator: "&")
    }
}

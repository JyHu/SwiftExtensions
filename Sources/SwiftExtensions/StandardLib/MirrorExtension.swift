//
//  File.swift
//  
//
//  Created by Jo on 2022/11/20.
//

import Foundation

public protocol MirrorReadble {
    /// Convert the object to a JSON-compatible model.
    /// - Returns: A representation of the object as a dictionary or nil for unsupported types.
    func toJSONModel() -> Any?
}

public extension MirrorReadble {
    /// Convert model data to a dictionary representation.
    /// Uses reflection to inspect the properties of the object and create a dictionary.
    func toJSONModel() -> Any? {
        // Create a mirror (reflection) of the current instance.
        let mirror = Mirror(reflecting: self)
        
        // If the object has properties (children), we process them.
        if mirror.children.count > 0 {
            var result: [String: Any] = [:]  // Empty dictionary to hold the key-value pairs.
            
            // Iterate through all properties of the object.
            for children in mirror.children {
                let propertyNameString = children.label!  // The name of the property.
                let value = children.value  // The value of the property.
                
                // If the value is also conforming to the MirrorReadble protocol, we recursively convert it.
                if let jsonValue = value as? MirrorReadble {
                    result[propertyNameString] = jsonValue.toJSONModel()
                }
            }
            return result  // Return the dictionary of properties.
        }
        return self  // If the object has no properties, return the object itself.
    }
}

extension Optional: MirrorReadble {
    // Special handling for Optional types.
    public func toJSONModel() -> Any? {
        if let x = self {
            if let value = x as? MirrorReadble {
                return value.toJSONModel()
            }
        }
        return nil  // If the value is nil, return nil (don't include it in the JSON model).
    }
}

extension String: MirrorReadble { }
extension Int: MirrorReadble { }
extension Bool: MirrorReadble { }
extension Dictionary: MirrorReadble { }
extension Array: MirrorReadble { }

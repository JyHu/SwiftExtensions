//
//  File.swift
//  
//
//  Created by Jo on 2022/10/31.
//

#if canImport(Foundation)

import Foundation

// MARK: - dictionary and array extensions
public protocol SequenceSerializationProtocol { }

public extension SequenceSerializationProtocol {
    func toJsonData(options: JSONSerialization.WritingOptions = .prettyPrinted) throws -> Data {
        return try JSONSerialization.data(withJSONObject: self, options: options)
    }
    
    func toPropertyListData(format: PropertyListSerialization.PropertyListFormat = .xml, options: PropertyListSerialization.WriteOptions = .bitWidth) throws -> Data {
        return try PropertyListSerialization.data(fromPropertyList: self, format: format, options: options)
    }
    
    func toJsonString(options: JSONSerialization.WritingOptions = .prettyPrinted) -> String? {
        return (try? toJsonData(options: options))?.toString(encoding: .utf8)
    }
    
    func toPropertyListString(format: PropertyListSerialization.PropertyListFormat = .xml, options: PropertyListSerialization.WriteOptions = .bitWidth) -> String? {
        return (try? toPropertyListData(format: format, options: options))?.toString(encoding: .utf8)
    }
}

extension Dictionary: SequenceSerializationProtocol { }
extension Array: SequenceSerializationProtocol { }

// MARK: - data extension
public extension Data {
    
    /// Convert data to string value
    /// - Parameter encoding: string encoding
    /// - Returns: Target string value
    func toString(encoding: String.Encoding = .utf8) -> String? {
        return String(data: self, encoding: encoding)
    }
    
    func toJsonObject(options: JSONSerialization.ReadingOptions = .mutableContainers) throws -> Any {
        return try JSONSerialization.jsonObject(with: self, options: options)
    }
    
    func toPropertyList(options: PropertyListSerialization.MutabilityOptions = .mutableContainersAndLeaves) throws -> Any {
        return try PropertyListSerialization.propertyList(from: self, options: options, format: nil)
    }
}

// MARK: - string extension
public extension String {
    func jsonObject(options: JSONSerialization.ReadingOptions = []) -> Any? {
        return try? data(using: .utf8)?.toJsonObject(options: options)
    }
    
    func propertyList(options: PropertyListSerialization.MutabilityOptions = []) -> Any? {
        return try? data(using: .utf8)?.toPropertyList(options: options)
    }
}

#endif

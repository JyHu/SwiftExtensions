//
//  File.swift
//  
//
//  Created by Jo on 2022/10/29.
//

#if canImport(Foundation)

import Foundation

public extension Data {
    
    /// Converts the data to an array of bytes (UInt8).
    ///
    /// - Returns: An array of `UInt8` representing the bytes of the data.
    var bytes: [UInt8] {
        return [UInt8](self)
    }
    
    /// Converts the data to a UTF-8 encoded string.
    ///
    /// If the data cannot be converted to a valid UTF-8 string, this method returns nil.
    ///
    /// - Returns: A `String` representation of the data, or `nil` if the conversion fails.
    func toUTF8String() -> String? {
        return String(data: self, encoding: .utf8)
    }
    
    /// Converts the data to a Base64 encoded string.
    ///
    /// - Parameter options: Options for Base64 encoding (default is an empty array).
    /// - Returns: A Base64 encoded string representation of the data.
    func toBase64String(options: Base64EncodingOptions = []) -> String? {
        return base64EncodedString(options: options)
    }
    
    /// Converts the data to a hexadecimal string.
    ///
    /// Each byte is converted into a 2-character hexadecimal string, and all bytes are concatenated.
    ///
    /// - Returns: A hexadecimal string representation of the data.
    func toHexString() -> String {
        return map { String(format: "%02hhx", $0) }.joined()
    }
}
#endif

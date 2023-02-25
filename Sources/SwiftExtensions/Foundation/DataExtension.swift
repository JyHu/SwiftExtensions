//
//  File.swift
//  
//
//  Created by Jo on 2022/10/29.
//

#if canImport(Foundation)

import Foundation

public extension Data {
    
    /// Convert data to bytes array
    var bytes: [UInt8] {
        return [UInt8](self)
    }
    
    func toUTF8String() -> String? {
        return String(data: self, encoding: .utf8)
    }
    
    func toBase64String(options: Base64EncodingOptions = []) -> String? {
        return base64EncodedString(options: options)
    }
    
    func toHexString() -> String {
        return map { String(format: "%02hhx", $0) }.joined()
    }
}

#endif

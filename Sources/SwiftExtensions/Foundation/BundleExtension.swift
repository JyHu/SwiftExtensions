//
//  File.swift
//  
//
//  Created by Jo on 2022/10/29.
//

#if canImport(Foundation)

import Foundation

public extension Bundle {
    
    /// Value of CFBundleShortVersionString
    var shortVersionString: String? {
        infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    /// Value of CFBundleVersion
    var version: String? {
        infoDictionary?["CFBundleVersion"] as? String
    }
    
    /// Value of CFBundleIdentifier
    var identifier: String? {
        infoDictionary?["CFBundleIdentifier"] as? String
    }
    
    var name: String? {
        infoDictionary?["CFBundleName"] as? String
    }
}

public extension Bundle {
    func decode<T: Decodable>(_ type: T.Type, from fileName: String, decoder: JSONDecoder = JSONDecoder()) -> T {
        guard let json = url(forResource: fileName, withExtension: nil) else {
            fatalError("Failed to locate \(fileName) in app bundle")
        }
        
        guard let jsonData = try? Data(contentsOf: json) else {
            fatalError("Failed to load \(fileName) from app bundle")
        }
        
        guard let result = try? decoder.decode(T.self, from: jsonData) else {
            fatalError("Failed to decode \(fileName) from app bundle")
        }
        
        return result
    }
}

#endif

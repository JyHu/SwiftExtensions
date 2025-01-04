//
//  File.swift
//  
//
//  Created by Jo on 2022/10/29.
//

#if canImport(Foundation)

import Foundation

public extension Bundle {
    
    /// The short version string of the app, typically representing the version number.
    /// Corresponds to `CFBundleShortVersionString` in the Info.plist.
    var shortVersionString: String? {
        infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    /// The build version number of the app.
    /// Corresponds to `CFBundleVersion` in the Info.plist.
    var version: String? {
        infoDictionary?["CFBundleVersion"] as? String
    }
    
    /// The app's unique identifier.
    /// Corresponds to `CFBundleIdentifier` in the Info.plist.
    var identifier: String? {
        infoDictionary?["CFBundleIdentifier"] as? String
    }
    
    /// The name of the app.
    /// Corresponds to `CFBundleName` in the Info.plist.
    var name: String? {
        infoDictionary?["CFBundleName"] as? String
    }
}

public extension Bundle {
    
    /// Decodes a JSON file from the app bundle into a given Decodable type.
    ///
    /// This method attempts to locate a file in the bundle with the specified file name,
    /// then loads and decodes the contents into the specified Decodable type using the provided decoder.
    /// If any of these steps fail, it will terminate the application with a fatal error.
    ///
    /// - Parameters:
    ///   - type: The type of the object to decode.
    ///   - fileName: The name of the file to decode, without extension.
    ///   - decoder: The JSON decoder to use, default is `JSONDecoder()`.
    /// - Returns: A decoded object of the specified type.
    /// - Throws: FatalError if the file cannot be found, loaded, or decoded.
    func decode<T: Decodable>(_ type: T.Type, from fileName: String, decoder: JSONDecoder = JSONDecoder()) -> T {
        // Attempt to find the file in the app bundle.
        guard let json = url(forResource: fileName, withExtension: nil) else {
            fatalError("Failed to locate \(fileName) in app bundle")
        }
        
        // Attempt to load the file data.
        guard let jsonData = try? Data(contentsOf: json) else {
            fatalError("Failed to load \(fileName) from app bundle")
        }
        
        // Attempt to decode the data into the specified type.
        guard let result = try? decoder.decode(T.self, from: jsonData) else {
            fatalError("Failed to decode \(fileName) from app bundle")
        }
        
        // Return the decoded object.
        return result
    }
}

#endif

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

public class AppInfo {
    private struct Entry {
        var value: String?
    }
    
    private static var shared = AppInfo()
    private init() { }
    
    private var shortVersionEntry: Entry?
    private var versionEntry: Entry?
    private var nameEntry: Entry?
    private var identifierEntry: Entry?
    
    public static var shortVersion: String? {
        if let entry = shared.shortVersionEntry {
            return entry.value
        }
        
        shared.shortVersionEntry = Entry(value: Bundle.main.shortVersionString)
        return shared.shortVersionEntry?.value
    }
    
    public static var version: String? {
        if let entry = shared.versionEntry {
            return entry.value
        }
        
        shared.versionEntry = Entry(value: Bundle.main.version)
        return shared.versionEntry?.value
    }
    
    public static var name: String? {
        if let entry = shared.nameEntry {
            return entry.value
        }
        
        shared.nameEntry = Entry(value: Bundle.main.name)
        return shared.nameEntry?.value
    }
    
    public static var identifier: String? {
        if let entry = shared.identifierEntry {
            return entry.value
        }
        
        shared.identifierEntry = Entry(value: Bundle.main.identifier)
        return shared.identifierEntry?.value
    }
}

#endif

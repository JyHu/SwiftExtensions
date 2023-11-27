//
//  File.swift
//  
//
//  Created by Jo on 2022/10/28.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
#elseif canImport(UIKit) && canImport(MobileCoreServices)
import UIKit
import MobileCoreServices
#endif

import UniformTypeIdentifiers

public extension NSDataAsset {
    convenience init?(assetName: String, bundleIdentifier: String?) {
        guard let bundleIdentifier = bundleIdentifier,
              let bundle = Bundle(identifier: bundleIdentifier) else { return nil }
        self.init(name: assetName, bundle: bundle)
    }
    
    var objectValue: Any? {
        if #available(iOS 14.0, macOS 11.0, *) {
            func isType(_ type: UTType) -> Bool {
                return typeIdentifier == type.identifier
            }
            
            if isType(.json) {
                return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            }
            
            if isType(.propertyList) {
                return try? PropertyListSerialization.propertyList(from: data, options: .mutableContainersAndLeaves, format: nil)
            }
            
            if isType(.data) {
                return data
            }
            
            if isType(.plainText) {
                return String(data: data, encoding: .utf8)
            }
        } else {
            func isType(_ type: CFString) -> Bool {
                return CFStringCompare(typeIdentifier as CFString, type, .compareCaseInsensitive) == .compareEqualTo
            }
            
            if isType(kUTTypeJSON) {
                return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            }
            
            if isType(kUTTypePropertyList) {
                return try? PropertyListSerialization.propertyList(from: data, options: .mutableContainersAndLeaves, format: nil)
            }
            
            if isType(kUTTypeData) {
                return data
            }
            
            if isType(kUTTypePlainText) {
                return String(data: data, encoding: .utf8)
            }
        }
        
        return nil
    }
}

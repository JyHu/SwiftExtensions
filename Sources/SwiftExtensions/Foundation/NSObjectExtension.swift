//
//  File.swift
//  
//
//  Created by Jo on 2022/10/29.
//

#if canImport(Foundation)

import Foundation

func synchronized(_ object: AnyObject, closure: () -> Void) {
    objc_sync_enter(object)
    closure()
    objc_sync_exit(object)
}

public protocol ClassNameProtocol {
    static var className: String { get }
    var className: String { get }
}

public extension ClassNameProtocol {
    static var className: String {
        String(describing: self)
    }
    
    var className: String {
        Self.className
    }
}

extension NSObject: ClassNameProtocol {}

public extension NSObjectProtocol {
    var propertyDescription: String {
        Mirror(reflecting: self)
            .children
            .map { "\($0.label ?? "Unknown"): \($0.value)" }
            .joined(separator: "\n")
    }
}

#endif

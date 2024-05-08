//
//  File.swift
//  
//
//  Created by Jo on 2024/4/19.
//

#if !os(Linux)

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
public typealias NSUIEdgeInsets = NSEdgeInsets


public extension NSEdgeInsets {
    static var zero: NSEdgeInsets {
        return NSEdgeInsetsZero
    }
}

#elseif canImport(UIKit)
import UIKit
public typealias NSUIEdgeInsets = UIEdgeInsets
#endif

public extension NSUIEdgeInsets {
    init(length: CGFloat) {
        self.init(top: length, left: length, bottom: length, right: length)
    }
    
    init(horizontal: CGFloat, vertical: CGFloat) {
        self.init(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
    }
}

#endif

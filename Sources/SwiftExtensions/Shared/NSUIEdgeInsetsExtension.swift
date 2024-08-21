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
    
    /// Returns an NSEdgeInsets instance with all edge values set to zero.
    static var zero: NSEdgeInsets {
        return NSEdgeInsetsZero
    }
}

#elseif canImport(UIKit)
import UIKit
public typealias NSUIEdgeInsets = UIEdgeInsets
#endif

public extension NSUIEdgeInsets {
    /// Initializes an instance with all edges set to the same length.
    /// - Parameter length: The length to set for all edges (top, left, bottom, right).
    init(length: CGFloat) {
        self.init(top: length, left: length, bottom: length, right: length)
    }
    
    /// Initializes an instance with specified horizontal and vertical edge values.
    /// - Parameters:
    ///   - horizontal: The length to set for the left and right edges. Default is 0.
    ///   - vertical: The length to set for the top and bottom edges. Default is 0.
    init(horizontal: CGFloat = 0, vertical: CGFloat = 0) {
        self.init(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
    }
}

#endif

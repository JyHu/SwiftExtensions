//
//  File.swift
//  
//
//  Created by Jo on 2022/10/28.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)

import AppKit

public extension NSEdgeInsets {
    static var zero: NSEdgeInsets {
        return NSEdgeInsetsZero
    }
}

#endif

//
//  File.swift
//  
//
//  Created by Jo on 2022/10/28.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)

import AppKit

public extension NSControl {
    
    func add(target: AnyObject?, action: Selector) {
        self.target = target
        self.action = action
    }
}

#endif

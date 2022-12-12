//
//  File.swift
//  
//
//  Created by Jo on 2022/10/31.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)

import AppKit

public extension NSTabViewItem {
    convenience init(with view: NSView, identifier: Any?) {
        self.init()
        self.view = view
        self.identifier = identifier
    }
    
    convenience init(with viewController: NSViewController, identifier: Any?) {
        self.init(viewController: viewController)
        self.identifier = identifier
    }
}

#endif


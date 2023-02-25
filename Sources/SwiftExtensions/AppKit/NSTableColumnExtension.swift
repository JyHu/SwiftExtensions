//
//  NSTableColumnExtension.swift
//  
//
//  Created by Jo on 2022/12/17.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)

import AppKit

public extension NSTableColumn {
    convenience init(identifier: NSUserInterfaceItemIdentifier, title: String, minWidth: CGFloat? = nil, maxWidth: CGFloat? = nil, width: CGFloat? = nil) {
        self.init(identifier: identifier)
        self.title = title
        
        if let minWidth = minWidth {
            self.minWidth = minWidth
        }
        
        if let maxWidth = maxWidth {
            self.maxWidth = maxWidth
        }
        
        if let width = width {
            self.width = width
            
            if minWidth == nil && maxWidth == nil {
                self.minWidth = width
                self.maxWidth = width
            }
        } else if let minWidth = minWidth, let maxWidth = maxWidth {
            self.width = (minWidth + maxWidth) / 2
        }
    }
}

#endif

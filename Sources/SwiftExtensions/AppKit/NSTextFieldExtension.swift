//
//  File.swift
//  
//
//  Created by Jo on 2022/10/31.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)

import AppKit

public extension NSTextField {
    class func label(with textColor: NSColor? = nil, lineBreakMode: NSLineBreakMode = .byTruncatingTail) -> NSTextField {
        let label = NSTextField(labelWithString: "")
        label.lineBreakMode = lineBreakMode
        if let textColor = textColor {
            label.textColor = textColor
        }
        return label
    }
    
    class func wrappingLabel(with textColor: NSColor? = nil) -> NSTextField {
        let label = NSTextField(wrappingLabelWithString: "")
        if let textColor = textColor {
            label.textColor = textColor
        }
        return label
    }
}

#endif

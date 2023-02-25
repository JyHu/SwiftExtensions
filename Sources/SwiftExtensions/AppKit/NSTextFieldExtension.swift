//
//  File.swift
//  
//
//  Created by Jo on 2022/10/31.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)

import AppKit

public extension NSTextField {
    convenience init(textColor: NSColor) {
        self.init(frame: NSMakeRect(0, 0, 100, 100))
        self.textColor = textColor
    }
    
    convenience init(labelWithString stringValue: String, textColor: NSColor, lineBreakMode: NSLineBreakMode = .byTruncatingTail) {
        self.init(labelWithString: stringValue)
        self.textColor = textColor
        self.lineBreakMode = lineBreakMode
    }
    
    convenience init(wrappingLabelWithString stringValue: String, textColor: NSColor, lineBreakMode: NSLineBreakMode = .byTruncatingTail) {
        self.init(wrappingLabelWithString: stringValue)
        self.textColor = textColor
        self.lineBreakMode = lineBreakMode
    }
}

#endif

//
//  File.swift
//  
//
//  Created by Jo on 2022/11/24.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)

import AppKit

public extension NSScrollView {
    convenience init(documentView: NSView) {
        self.init(frame: NSMakeRect(0, 0, 100, 60))
        self.documentView = documentView
        
        drawsBackground = false
        focusRingType = .none
        hasHorizontalScroller = true
        hasVerticalScroller = true
        horizontalScrollElasticity = .automatic
        verticalScrollElasticity = .automatic
        scrollerStyle = .overlay
    }
}

#endif

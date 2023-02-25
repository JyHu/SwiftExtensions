//
//  File.swift
//  
//
//  Created by Jo on 2022/11/24.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)

import AppKit

public extension NSScrollView {
    convenience init(documentView: NSView, isHorizontal: Bool = false, hasScroller: Bool = true) {
        self.init(frame: NSMakeRect(0, 0, 100, 60))
        self.documentView = documentView
        
        drawsBackground = false
        focusRingType = .none
        scrollerStyle = .overlay
        
        if hasScroller {        
            if isHorizontal {
                hasHorizontalScroller = true
                horizontalScrollElasticity = .automatic
            } else {
                hasVerticalScroller = true
                verticalScrollElasticity = .automatic
            }
        }
    }
}

#endif

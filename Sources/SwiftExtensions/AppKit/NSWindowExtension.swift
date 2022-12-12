//
//  File.swift
//  
//
//  Created by Jo on 2022/10/29.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)

import AppKit

public extension NSWindow {
    var closeButton: NSButton? {
        standardWindowButton(.closeButton)
    }
    
    var miniaturizeButton: NSButton? {
        standardWindowButton(.miniaturizeButton)
    }
    
    var zoomButton: NSButton? {
        standardWindowButton(.zoomButton)
    }
    
    var toolbarButton: NSButton? {
        standardWindowButton(.toolbarButton)
    }
    
    var documentIconButton: NSButton? {
        standardWindowButton(.documentIconButton)
    }
    
    var documentVersionsButton: NSButton? {
        standardWindowButton(.documentVersionsButton)
    }
}

public extension NSWindow {
    func centerAtScreen() {
        guard let screenFrame = NSScreen.main?.visibleFrame else {
            return
        }
        
        let xpos = screenFrame.width / 2 - frame.width / 2 + screenFrame.minX
        let ypos = screenFrame.height / 2 - frame.height / 2 + screenFrame.minY
        setFrame(CGRect(x: xpos, y: ypos, width: frame.width, height: frame.height), display: true)
    }
    
    func center(of rect: CGRect) {
        let xpos = rect.width / 2 - frame.width / 2 + rect.minX
        let ypos = rect.height / 2 - frame.height / 2 + rect.minY
        setFrame(CGRect(x: xpos, y: ypos, width: frame.width, height: frame.height), display: true)
    }
}

#endif

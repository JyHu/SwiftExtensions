//
//  File.swift
//  
//
//  Created by Jo on 2022/10/30.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)

import AppKit

public extension NSApplication {
    var isInFullScreenMode: Bool {
        return presentationOptions.contains(.fullScreen)
    }
    
    var isContainsModalWindow: Bool {
        return windows.contains { $0.isModalPanel }
    }
    
    func smoothlyRunModal(for window: NSWindow) {
        if window.windowController == nil {
            _ = NSWindowController(window: window)
        }
        
        performSelector(onMainThread: #selector(_smoothlyRunModal), with: window, waitUntilDone: false, modes: [RunLoop.Mode.common.rawValue])
    }
    
    @objc private func _smoothlyRunModal(for window: NSWindow) {
        runModal(for: window)
    }
}

#endif

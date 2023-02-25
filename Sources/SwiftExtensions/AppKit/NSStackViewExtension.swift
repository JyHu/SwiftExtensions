//
//  File.swift
//  
//
//  Created by Jo on 2022/10/29.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)

import AppKit

public extension NSStackView {
    func removeAllViews() {
        for view in views {
            removeView(view)
        }
    }
    
    func appendSpace(_ space: CGFloat) {
        if let lastView = arrangedSubviews.last {
            setCustomSpacing(space, after: lastView)
        }
    }
}

#endif

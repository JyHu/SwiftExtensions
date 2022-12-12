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
}

#endif

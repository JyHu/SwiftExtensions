//
//  File.swift
//
//
//  Created by Jo on 2022/10/29.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)

import AppKit

public extension NSSplitViewItem {
    func set(thickness: CGFloat) {
        minimumThickness = thickness
        maximumThickness = thickness
    }

    func set(minThickness: CGFloat? = nil,
             maxThickness: CGFloat? = nil,
             priority: NSLayoutConstraint.Priority? = nil) {
        if let minThickness = minThickness {
            minimumThickness = minThickness
        }

        if let maxThickness = maxThickness {
            maximumThickness = maxThickness
        }

        if let priority = priority {
            holdingPriority = priority
        }
    }
}

#endif

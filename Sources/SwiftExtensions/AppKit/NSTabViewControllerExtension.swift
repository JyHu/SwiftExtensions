//
//  File.swift
//  
//
//  Created by Jo on 2022/10/31.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)

import AppKit

public extension NSTabViewController {
    func selectTabViewItem(at index: Int) {
        if index >= tabView.numberOfTabViewItems || index < 0 { return }
        tabView.selectTabViewItem(at: index)
    }
    
    func selectTabViewItem(with identifier: NSUserInterfaceItemIdentifier) {
        tabView.selectTabViewItem(with: identifier)
    }
    
    func tabViewItem(of identifier: NSUserInterfaceItemIdentifier) -> NSTabViewItem? {
        return tabView.tabViewItem(with: identifier)
    }
}

#endif

//
//  File.swift
//  
//
//  Created by hujinyou on 2024/12/22.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)

import AppKit

public extension NSToolbar {
    func setEnable(_ isEnabled: Bool, of itemIdentifiers: [NSToolbarItem.Identifier]) {
        for itemIdentifier in itemIdentifiers {
            items.first(where: { $0.itemIdentifier == itemIdentifier })?.isEnabled = isEnabled
        }
    }
    
    func setEnableOfAllItems(_ isEnable: Bool) {
        items.forEach { $0.isEnabled = isEnable }
    }
}

#endif

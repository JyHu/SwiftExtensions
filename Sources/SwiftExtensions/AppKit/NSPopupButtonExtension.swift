//
//  File.swift
//  
//
//  Created by Jo on 2022/10/29.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)

import AppKit

public extension NSPopUpButton {
    @discardableResult
    func addItem(with title: String, toolTip: String? = nil, representedObject: Any? = nil) -> NSMenuItem? {
        addItem(withTitle: title)
        
        let menuItem = item(withTitle: title)
        menuItem?.toolTip = toolTip
        menuItem?.representedObject = representedObject
        return menuItem
    }
    
    func selectedItemRepresentedObject<T>() -> T? {
        return selectedItem?.representedObject as? T
    }
}

public extension NSPopUpButtonCell {
    @discardableResult
    func addItem(with title: String, toolTip: String? = nil, representedObject: Any? = nil) -> NSMenuItem? {
        addItem(withTitle: title)
        
        let menuItem = item(withTitle: title)
        menuItem?.toolTip = toolTip
        menuItem?.representedObject = representedObject
        return menuItem
    }
}


#endif

//
//  File.swift
//  
//
//  Created by Jo on 2022/10/28.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)

import AppKit

public extension NSObject {
    /// 创建一个菜单项
    /// - Parameters:
    ///   - title: 标题
    ///   - action: 事件
    ///   - representedObject: 缓存信息
    ///   - toolTip: 提示信息
    /// - Returns: 菜单项
    func createMenuItem(with title: String, action: Selector? = nil, representedObject: Any? = nil, keyEquivalent: String? = nil, toolTip: String? = nil, state: NSControl.StateValue = .off) -> NSMenuItem {
        let item = NSMenuItem(title: title, action: action, keyEquivalent: keyEquivalent ?? "")
        item.target = self
        item.representedObject = representedObject
        item.toolTip = toolTip
        item.state = state
        return item
    }
    
    /// 创建一个菜单项
    /// - Parameters:
    ///   - title: 菜单项标题
    ///   - subMenu: 子菜单
    /// - Returns: 菜单项
    func createMenuItem(with title: String, subMenu: NSMenu?) -> NSMenuItem {
        let item = NSMenuItem(title: title, action: nil, keyEquivalent: "")
        item.submenu = subMenu
        return item
    }
    
    /// 创建一个菜单
    /// - Parameter items: 菜单项列表
    /// - Returns: 创建的菜单
    func createMenu(with items: NSMenuItem ...) -> NSMenu {
        let menu = NSMenu()
        for item in items {
            menu.addItem(item)
        }
        return menu
    }
}

public extension NSMenu {
    func item(withIdentifier identifier: NSUserInterfaceItemIdentifier) -> NSMenuItem? {
        return items.first(where: { $0.identifier == identifier })
    }
    
    func item(withIdentifier identifier: String) -> NSMenuItem? {
        return items.first(where: { $0.identifier?.rawValue == identifier })
    }
    
    @discardableResult
    func addItem(with title: String, action: Selector? = nil, representedObject: Any? = nil, keyEquivalent: String? = nil, toolTip: String? = nil) -> NSMenuItem {
        let item = NSMenuItem(title: title, action: action, keyEquivalent: keyEquivalent ?? "")
        item.target = self
        item.representedObject = representedObject
        item.toolTip = toolTip
        addItem(item)
        return item
    }
    
    @discardableResult
    func addItem(with title: String, subMenu: NSMenu?) -> NSMenuItem {
        let item = NSMenuItem(title: title, action: nil, keyEquivalent: "")
        item.submenu = subMenu
        addItem(item)
        return item
    }
}

public extension NSMenuItem {
    convenience init(title: String, target: AnyObject? = nil, action: Selector? = nil, representedObject: Any? = nil, keyEquivalent: String? = nil, toolTip: String? = nil) {
        self.init(title: title, action: action, keyEquivalent: keyEquivalent ?? "")
        self.target = target
        self.toolTip = toolTip
        self.representedObject = representedObject
    }
    
    func subItem(withIdentifier identifier: NSUserInterfaceItemIdentifier) -> NSMenuItem? {
        return submenu?.item(withIdentifier: identifier)
    }

    func subItem(withIdentifier identifier: String) -> NSMenuItem? {
        return submenu?.item(withIdentifier: identifier)
    }
}

#endif

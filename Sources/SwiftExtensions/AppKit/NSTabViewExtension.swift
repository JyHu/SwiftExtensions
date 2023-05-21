//
//  File.swift
//  
//
//  Created by Jo on 2022/10/29.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)

import AppKit

public extension NSTabView {
    convenience init(tabViewType: NSTabView.TabType = .noTabsNoBorder) {
        self.init(frame: NSMakeRect(0, 0, 100, 100))
        self.tabViewType = tabViewType
    }
    
    /// 当前选择的索引
    var indexOfSelectedItem: Int? {
        get {
            guard let selectedTabViewItem = selectedTabViewItem else { return nil }
            return indexOfTabViewItem(selectedTabViewItem)
        }
        set {
            guard let indexOfSelectedItem = newValue else { return }
            selectTabViewItem(tabViewItem(at: indexOfSelectedItem))
        }
    }
    
    /// 添加一个viewController
    func addTabbed(viewControllers: NSViewController ...) {
        for viewController in viewControllers {
            addTabViewItem(NSTabViewItem(viewController: viewController))
        }
    }
    
    /// 添加一个view
    func addTabbed(views: NSView ...) {
        for view in views {
            let item = NSTabViewItem()
            item.view = view
            addTabViewItem(item)
        }
    }
    
    /// 增加一个显示的viewController到tabView
    /// - Parameters:
    ///   - viewController: 需要添加的viewController
    ///   - title: tab标题
    ///   - identifier: tab标识
    func addTabbed(viewController: NSViewController, title: String? = nil, identifier: NSUserInterfaceItemIdentifier? = nil) {
        let tabItem = NSTabViewItem(viewController: viewController)
        
        if let title = title {
            tabItem.label = title
        }
        
        if let identifier = identifier {
            tabItem.identifier = identifier
        }
        
        addTabViewItem(tabItem)
    }
    
    /// 增加一个显示的view到tabview
    /// - Parameters:
    ///   - view: 需要添加的view视图
    ///   - title: tab标题
    ///   - identifier: tab标识
    func addTabbed(view: NSView, title: String? = nil, identifier: NSUserInterfaceItemIdentifier? = nil) {
        let tabItem = NSTabViewItem(identifier: identifier)
        if let title = title {
            tabItem.label = title
        }
        tabItem.view = view
        tabItem.identifier = identifier
        addTabViewItems(tabItem)
    }
    
    /// 添加一个tab
    func addTabViewItems(_ tabItems: NSTabViewItem ...) {
        for tab in tabItems {
            addTabViewItem(tab)
        }
    }
    
    func removeTabViewItem(with identifier: NSUserInterfaceItemIdentifier) {
        let index = indexOfTabViewItem(withIdentifier: identifier)
        if index == NSNotFound { return }
        let item = tabViewItem(at: index)
        removeTabViewItem(item)
    }
    
    func selectTabViewItem(with identifier: NSUserInterfaceItemIdentifier) {
        guard let index = indexOfTabViewItem(with: identifier) else { return }
        selectTabViewItem(at: index)
    }
    
    func containsTabViewItem(with identifier: NSUserInterfaceItemIdentifier) -> Bool {
        return indexOfTabViewItem(withIdentifier: identifier) != NSNotFound
    }
    
    func indexOfTabViewItem(with identifier: NSUserInterfaceItemIdentifier) -> Int? {
        let index = indexOfTabViewItem(withIdentifier: identifier)
        if index == NSNotFound { return nil }
        return index
    }
    
    func tabViewItem(with identifier: NSUserInterfaceItemIdentifier) -> NSTabViewItem? {
        guard let index = indexOfTabViewItem(with: identifier) else { return nil }
        return tabViewItems[index]
    }
}

#endif

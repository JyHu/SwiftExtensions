//
//  File.swift
//  
//
//  Created by Jo on 2022/10/28.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)

import AppKit

public extension NSPathControlItem {
    convenience init(title: String) {
        self.init()
        self.title = title
    }
    
    convenience init(image: NSImage) {
        self.init()
        self.image = image
    }
    
    convenience init(attributedTitle: NSAttributedString) {
        self.init()
        self.attributedTitle = attributedTitle
    }
}

public extension NSPathControl {
    var stringValues: [String] {
        set {
            pathItems = newValue.map { NSPathControlItem(title: $0) }
        }
        get {
            return pathItems.map { $0.title }
        }
    }
    
    func updateLastTitle(_ title: String) {
        pathItems.removeLast()
        pathItems.append(NSPathControlItem(title: title))
    }
    
    func updateFirstTitle(_ title: String) {
        pathItems.removeFirst()
        pathItems.insert(NSPathControlItem(title: title), at: 0)
    }
    
    func updateTitle(at index: Int, title: String) {
        if index >= pathItems.count || index < 0 { return }
        pathItems.remove(at: index)
        pathItems.insert(NSPathControlItem(title: title), at: index)
    }
    
    func appendItemWith(title: String) {
        pathItems.append(NSPathControlItem(title: title))
    }
    
    func insertItemWith(title: String, at index: Int) {
        if index > pathItems.count || index < 0 { return }
        pathItems.insert(NSPathControlItem(title: title), at: index)
    }
    
    @discardableResult func removeItem(at index: Int) -> NSPathControlItem? {
        if index >= pathItems.count || index < 0 { return nil }
        return pathItems.remove(at: index)
    }
    
    @discardableResult func removeFirstItem() -> NSPathControlItem? {
        pathItems.removeFirst()
    }
    
    @discardableResult func removeLastItem() -> NSPathControlItem? {
        return pathItems.removeLast()
    }
}

#endif


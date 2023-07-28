//
//  File.swift
//
//
//  Created by Jo on 2022/10/29.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)

import AppKit

public extension NSSplitViewController {
    
    /// 分栏视图的方向，是否是垂直的
    var isVertical: Bool {
        set {
            splitView.isVertical = newValue
        }
        get {
            return splitView.isVertical
        }
    }
    
    /// 添加一个视图控制器到split viewController
    /// - Parameters:
    ///   - viewController: 需要添加的ViewController
    ///   - minThickness: 最小压缩尺寸
    ///   - maxThickness: 最大拉伸尺寸
    /// - Returns: 添加后的splitItem
    @discardableResult
    func add(_ viewController: NSViewController, minThickness: CGFloat? = nil, maxThickness: CGFloat? = nil) -> NSSplitViewItem {
        let splitItem = NSSplitViewItem(viewController: viewController)
        
        if let minThickness = minThickness {
            splitItem.minimumThickness = minThickness
        }
        
        if let maxThickness = maxThickness {
            splitItem.maximumThickness = maxThickness
        }
        
        addSplitViewItem(splitItem)
        
        return splitItem
    }
    
    @discardableResult
    func add(_ view: NSView, minThickness: CGFloat? = nil, maxThickness: CGFloat? = nil) -> NSSplitViewItem {
        let viewController = NSViewController()
        viewController.view = view
        return add(viewController, minThickness: minThickness, maxThickness: maxThickness)
    }
    
    /// 添加一个ViewController到Split ViewController
    /// - Parameters:
    ///   - viewController: 需要添加的视图控制器
    ///   - thickness: 固定的宽或高
    /// - Returns: 添加后的split item
    @discardableResult
    func add(_ viewController: NSViewController, thickness: CGFloat? = nil) -> NSSplitViewItem {
        let splitItem = NSSplitViewItem(viewController: viewController)
        
        if let thickness = thickness {
            splitItem.minimumThickness = thickness
            splitItem.maximumThickness = thickness
        }
        
        addSplitViewItem(splitItem)
        
        return splitItem
    }
    
    @discardableResult
    func add(_ view: NSView, thickness: CGFloat? = nil) -> NSSplitViewItem {
        let viewController = NSViewController()
        viewController.view = view
        return add(viewController, thickness: thickness)
    }
}

#endif

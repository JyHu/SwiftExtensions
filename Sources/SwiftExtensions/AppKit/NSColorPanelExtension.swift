//
//  File.swift
//  
//
//  Created by Jo on 2022/10/30.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)

import AppKit

public extension NSColorPanel {
    class Bridge {
        public private(set) var callback: ((NSColor) -> Void)?
        
        fileprivate init(color: NSColor? = nil, callback: ((NSColor) -> Void)? = nil) {
            self.callback = callback
            _ = NSColorPanel.panelWith(target: self, action: #selector(selectedColorAction))
        }
        
        @objc private func selectedColorAction(_ color: NSColor) {
            callback?(color)
        }
        
        deinit {
            /// 在没有创建颜色选择器的时候，可以不用进行下面的判断
            if NSColorPanel.sharedColorPanelExists {
                /// 如果颜色选择器能看见，才能进行下面的判断
                if NSColorPanel.shared.isVisible {
                    /// 获取颜色选择器的target
                    /// 如果target为nil，说明目标被释放，那么颜色选择器就必须被关掉
                    /// 如果target就是当前页面，那么颜色选择器也必须被关掉
                    if let target = NSColorPanel.shared.weakTarget, target === self {
                        NSColorPanel.shared.close()
                    }
                }
            }
        }
    }
    
    static func pickColor(color: NSColor? = nil, _ callback: @escaping (NSColor) -> Void) -> Bridge {
        return Bridge(color: color, callback: callback)
    }
}

public extension NSColorPanel {
    ///// color picker 中转类
    ///// 如果正常的使用color picker，在设置的target销毁的时候没有处理color picker的target属性置空
    ///// 那么再次选择颜色的时候就会出现crash
    private class _SharedBridge {
        weak var target: AnyObject?
        var action: Selector?
        
        static var shared = _SharedBridge()
        private init() {
            NotificationCenter.default.addObserver(self, selector: #selector(colorChangedNotificationAction), name: NSColorPanel.colorDidChangeNotification, object: nil)
        }
        
        @objc func colorChangedNotificationAction(_ notification: Notification) {
            colorChangedAction(NSColorPanel.shared)
        }
        
        @objc func colorChangedAction(_ colorPanel: NSColorPanel) {
            guard let target = target, let action = action, target.responds(to: action) else {
                return
            }
            
            _ = target.perform(action, with: colorPanel.color)
        }
        
        func colorPanelWith(target: AnyObject?, action: Selector?, color: NSColor? = nil) -> NSColorPanel {
            self.target = nil
            self.action = nil
            
            self.target = target
            self.action = action
            
            NSColorPanel.shared.isContinuous = true
            NSColorPanel.shared.setTarget(self)
            if let color = color {
                NSColorPanel.shared.color = color
            }
            NSColorPanel.shared.setAction(#selector(colorChangedAction))
            
            return NSColorPanel.shared
        }
    }
    
    static func panelWith(target: AnyObject?, action: Selector?, color: NSColor? = nil) -> NSColorPanel {
        return _SharedBridge.shared.colorPanelWith(target: target, action: action, color: color)
    }
    
    var weakTarget: AnyObject? {
        return _SharedBridge.shared.target
    }
}

#endif

//
//  File.swift
//  
//
//  Created by Jo on 2022/10/29.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)

import AppKit

public extension NSStackView {
    
    /// 移除所有的子视图
    func removeAllViews() {
        for view in arrangedSubviews {
            removeView(view)
        }
    }
    
    /// 在最后一个视图后面设置自定义的空格
    func appendSpace(_ space: CGFloat) {
        if let lastView = arrangedSubviews.last {
            setCustomSpacing(space, after: lastView)
        }
    }
}

#endif

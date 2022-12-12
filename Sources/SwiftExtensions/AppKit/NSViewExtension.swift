//
//  File.swift
//
//
//  Created by Jo on 2022/10/29.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)

import AppKit

public extension NSView {
    var layerBackgroundColor: NSColor? {
        get {
            guard let cgColor = layer?.backgroundColor else { return nil }
            return NSColor(cgColor: cgColor)
        }
        set {
            if !wantsLayer { wantsLayer = true }
            layer?.backgroundColor = newValue?.cgColor
        }
    }
    
    var layerBorderColor: NSColor? {
        get {
            guard let cgColor = layer?.borderColor else { return nil }
            return NSColor(cgColor: cgColor)
        }
        set {
            if !wantsLayer { wantsLayer = true }
            layer?.borderColor = newValue?.cgColor
        }
    }
    
    var layerBorderWidth: CGFloat {
        get { layer?.borderWidth ?? 0 }
        set {
            if !wantsLayer { wantsLayer = true }
            layer?.borderWidth = newValue
        }
    }
    
    var layerCornerRadius: CGFloat {
        get { layer?.cornerRadius ?? 0 }
        set {
            if !wantsLayer { wantsLayer = true }
            layer?.cornerRadius = newValue
        }
    }
    
    var layerShadowColor: NSColor? {
        get {
            guard let cgColor = layer?.shadowColor else { return nil }
            return NSColor(cgColor: cgColor)
        }
        set {
            if !wantsLayer { wantsLayer = true }
            layer?.shadowColor = newValue?.cgColor
        }
    }
    
    var layerShadowOffset: CGSize {
        get { layer?.shadowOffset ?? .zero }
        set {
            if !wantsLayer { wantsLayer = true }
            layer?.shadowOffset = newValue
        }
    }
    
    var layerShadowOpacity: Float {
        get { layer?.shadowOpacity ?? 0 }
        set {
            if !wantsLayer { wantsLayer = true }
            layer?.shadowOpacity = newValue
        }
    }
    
    var layerShadowRadius: CGFloat {
        get { layer?.shadowRadius ?? 0 }
        set {
            if !wantsLayer { wantsLayer = true }
            layer?.shadowRadius = newValue
        }
    }
}

public extension NSView {
    var rectInScreen: CGRect? {
        return window?.convertToScreen(convert(bounds, to: nil))
    }
    
    var rectInWindow: CGRect {
        return convert(bounds, to: nil)
    }
}

public extension NSView {
    func snapShotWithRect(_ rect: CGRect? = nil) -> NSImage? {
        guard let bitmap = bitmapImageRepForCachingDisplay(in: rect ?? bounds) else {
            return nil
        }
        
        cacheDisplay(in: bounds, to: bitmap)
        let image = NSImage(size: bounds.size)
        image.addRepresentation(bitmap)
        return image
    }
    
    func snapShotWithInsets(_ insets: NSEdgeInsets) -> NSImage? {
        let rect = CGRect(
            x: insets.left,
            y: insets.top,
            width: bounds.size.width - insets.left - insets.right,
            height: bounds.height - insets.top - insets.bottom
        )
        
        return snapShotWithRect(rect)
    }
}

public extension NSView {
    private struct AssociatedKeys {
        static var trackingArea: String = "com.auu.association.trackingArea"
    }
    
    /// 添加鼠标事件跟踪区域
    /// - Parameters:
    ///   - rect: 需要添加的区域
    ///   - options: 跟踪的事件类型
    func addCustomizedTrackingArea(with rect: NSRect? = nil, options: NSTrackingArea.Options = [.mouseEnteredAndExited, .activeAlways]) {
        if let trackingArea = objc_getAssociatedObject(self, &AssociatedKeys.trackingArea) as? NSTrackingArea {
            removeTrackingArea(trackingArea)
        }
        
        let trackingArea = NSTrackingArea(rect: rect ?? bounds, options: options, owner: self, userInfo: nil)
        addTrackingArea(trackingArea)
        objc_setAssociatedObject(self, &AssociatedKeys.trackingArea, trackingArea, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}

#endif

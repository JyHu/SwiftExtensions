//
//  File.swift
//  
//
//  Created by Jo on 2022/11/1.
//

#if !os(Linux)

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
public typealias NSUIViewController = NSViewController
#elseif canImport(UIKit)
import UIKit
public typealias NSUIViewController = UIViewController
#endif

public extension NSUIViewController {
    func addAutoLayout(subView: NSUIView) {
        view.addAutoLayout(subView: subView)
    }
    
    func layout(subView: NSUIView, insets: NSUIEdgeInsets = .zero, saftyLayout: Bool = true) {
        view.layout(subView: subView, insets: insets, saftyLayout: saftyLayout)
    }
    
    func layout(subView view: NSUIView, padding: CGFloat, saftyLayout: Bool = true) {
        layout(subView: view, insets: NSUIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding), saftyLayout: saftyLayout)
    }
    
    func layoutCenter(subView: NSUIView, horizontalPadding: CGFloat = 0, verticalPadding: CGFloat = 0, saftyLayout: Bool = false) {
        view.layoutCenter(subView: subView, horizontalPadding: horizontalPadding, verticalPadding: verticalPadding, saftyLayout: saftyLayout)
    }
    
    func layout(subViews: [String: NSUIView], vfls: [String], metrics: [String: Any] = [:], options: NSLayoutConstraint.FormatOptions = .directionMask) {
        view.layout(subViews: subViews, vfls: vfls, metrics: metrics, options: options)
    }
    
    func gridLayout(with config: NSUIView.GridConfig? = nil, creation: (Int, Int) -> NSUIView) {
        view.gridLayout(with: config, creation: creation)
    }
    
    func layout(subViews: [NSView], constraints: [NSLayoutConstraint]) {
        view.layout(subViews: subViews, constraints: constraints)
    }
}

#endif

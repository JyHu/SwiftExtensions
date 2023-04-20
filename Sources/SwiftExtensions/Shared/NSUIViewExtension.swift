//
//  File.swift
//  
//
//  Created by Jo on 2022/11/1.
//

#if !os(Linux)

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
public typealias NSUIView = NSView
public typealias NSUIEdgeInsets = NSEdgeInsets
public typealias NSUILayoutGuide = NSLayoutGuide
#elseif canImport(UIKit)
import UIKit
public typealias NSUIView = UIView
public typealias NSUIEdgeInsets = UIEdgeInsets
public typealias NSUILayoutGuide = UILayoutGuide
#endif

/// Geometry protocol
public protocol GeometryProtocol { }

/// Layout sub view protocol
public protocol SubViewLayoutProtocol { }

/// Layout attributes
public protocol LayoutGuideProtocol {
    var leadingAnchor: NSLayoutXAxisAnchor { get }
    var trailingAnchor: NSLayoutXAxisAnchor { get }
    var leftAnchor: NSLayoutXAxisAnchor { get }
    var rightAnchor: NSLayoutXAxisAnchor { get }
    var topAnchor: NSLayoutYAxisAnchor { get }
    var bottomAnchor: NSLayoutYAxisAnchor { get }
    var widthAnchor: NSLayoutDimension { get }
    var heightAnchor: NSLayoutDimension { get }
    var centerXAnchor: NSLayoutXAxisAnchor { get }
    var centerYAnchor: NSLayoutYAxisAnchor { get }
}

public extension GeometryProtocol where Self: NSUIView {
    
    /// The x-coordinate of current view.
    var x: CGFloat {
        get { frame.minX }
        set { frame.origin.x = newValue }
    }
    
    /// The y-coordinate of current view.
    var y: CGFloat {
        get { frame.minY }
        set { frame.origin.y = newValue }
    }
    
    /// The width value of current view.
    var width: CGFloat {
        get { frame.width }
        set { frame.size.width = newValue }
    }
    
    /// The height value of current view.
    var height: CGFloat {
        get { frame.height }
        set { frame.size.height = newValue }
    }
    
#if os(iOS)
    
    /// The center x coordinate of current view.
    var centerX: CGFloat { center.x }
    
    /// The center y coordinate of current view.
    var centerY: CGFloat { center.y }
#endif
}

public extension SubViewLayoutProtocol where Self: NSUIView {
    
    /// Get the safty autolayout guide of current view, only macOS 11.0 and iOS 11.0 or later supported.
    /// - Parameter saftyLayout: Whether `safeAreaLayoutGuide` is needed
    /// - Returns: The object has layout anchor and dimension properties
    func getLayoutGuide(saftyLayout: Bool = true) -> LayoutGuideProtocol {
        if #available(macOS 11.0, iOS 11.0, *) {
            if saftyLayout {
                return safeAreaLayoutGuide
            } else {
                return self
            }
        } else {
            return self
        }
    }
    
    /// Add the view as subview to current view, and automatically sets it to
    /// support auto-layout.
    ///
    /// - Parameter subView: Added view.
    func addAutoLayout(subView: NSUIView) {
        if subView.translatesAutoresizingMaskIntoConstraints {
            subView.translatesAutoresizingMaskIntoConstraints = false
        }
        
        if subView.superview == nil {
            addSubview(subView)
        }
    }
    
    /// 添加一个view到当前view上，并做自动布局
    ///
    /// 内部会自己判断有没有addSubView
    ///
    /// - Parameters:
    ///   - view: 要添加的view
    ///   - insets: 四周的边距
    
    
    /// Add a sub view to current view using auto layout.
    /// - Parameters:
    ///   - subView: The view to be added
    ///   - insets: Layout insets
    ///   - saftyLayout: Whether the safe area is required
    func layout(subView: NSUIView, insets: NSUIEdgeInsets = .zero, saftyLayout: Bool = true) {
        addAutoLayout(subView: subView)
        
        let layoutGuide = getLayoutGuide(saftyLayout: saftyLayout)
        
        NSLayoutConstraint.activate([
            subView.topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: insets.top),
            subView.leftAnchor.constraint(equalTo: layoutGuide.leftAnchor, constant: insets.left),
            subView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor, constant: insets.bottom * -1),
            subView.rightAnchor.constraint(equalTo: layoutGuide.rightAnchor, constant: insets.right * -1),
        ])
    }
    
    /// Add a sub view to current view using auto layout.
    /// - Parameters:
    ///   - view: The view to be added
    ///   - padding: The padding of all side.
    ///   - saftyLayout: Whether the safe area is required.
    func layout(subView view: NSUIView, padding: CGFloat, saftyLayout: Bool = true) {
        layout(subView: view, insets: NSUIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding), saftyLayout: saftyLayout)
    }
    
    /// Add the view to current view, and layout center. and align the two views in center.
    /// - Parameters:
    ///   - view: The view to be added
    ///   - horizontalPadding: The horizontal padding
    ///   - verticalPadding: The vertical padding
    ///   - saftyLayout: Whether the safe area is required.
    func layoutCenter(subView view: NSUIView, horizontalPadding: CGFloat = 0, verticalPadding: CGFloat = 0, saftyLayout: Bool = false) {
        addAutoLayout(subView: view)
        
        let layoutGuide = getLayoutGuide(saftyLayout: saftyLayout)
        
        NSLayoutConstraint.activate([
            view.centerXAnchor.constraint(equalTo: layoutGuide.centerXAnchor),
            view.centerYAnchor.constraint(equalTo: layoutGuide.centerYAnchor),
            view.topAnchor.constraint(greaterThanOrEqualTo: layoutGuide.topAnchor, constant: verticalPadding),
            view.leftAnchor.constraint(greaterThanOrEqualTo: layoutGuide.leftAnchor, constant: horizontalPadding),
            view.bottomAnchor.constraint(lessThanOrEqualTo: layoutGuide.bottomAnchor, constant: verticalPadding * -1),
            view.rightAnchor.constraint(lessThanOrEqualTo: layoutGuide.rightAnchor, constant: horizontalPadding * -1),
        ])
    }
    
    /// 添加一个view到当前view上，并使用VFL的方式添加自动布局
    /// - Parameters:
    ///   - views: 要添加的视图列表
    ///   - vfls: VLF列表
    ///   - metrics: VFL中的间距
    func layout(subViews: [String: NSUIView], vfls: [String], metrics: [String: Any] = [:], options: NSLayoutConstraint.FormatOptions = .directionMask) {
        for view in subViews.values {
            addAutoLayout(subView: view)
        }
        
        /// 添加自动布局
        for vfl in vfls {
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: vfl, options: options, metrics: metrics, views: subViews)
            )
        }
    }
    
    func gridLayout(with config: NSUIView.GridConfig? = nil, creation: (Int, Int) -> NSUIView) {
        let config = config ?? GridConfig()
        var HVFLs = [String](repeating: "H:|-\(config.edgeInsets.left)-", count: config.rows)
        var VVFLs = [String](repeating: "V:|-\(config.edgeInsets.top)-", count: config.columns)
        
        var dict: Dictionary<String, AnyObject> = [:]
        for i in 0 ..< config.rows {
            for j in 0 ..< config.columns {
                let view = creation(i, j)
                
                addAutoLayout(subView: view)
                
                func ij(_ ii: Int, _ jj: Int) -> String { return "VFLObj\(ii * config.columns + jj)" }
                dict[ij(i, j)] = view
                
                let relateH = (j == config.columns - 1 ? "\(config.edgeInsets.right)-|" : "\(config.margin)-")
                let relateV = (i == config.rows - 1 ? "\(config.edgeInsets.bottom)-|" : "\(config.margin)-")
                HVFLs[i] += "[\(ij(i,j))\(j > 0 ? "(\(ij(i, j - 1)))" : "")]-\(relateH)"
                VVFLs[j] += "[\(ij(i,j))\(i > 0 ? "(\(ij(i - 1, j)))" : "")]-\(relateV)"
            }
        }
        
        for vfl in HVFLs + VVFLs {
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: vfl, options: .directionMask, metrics: nil, views: dict)
            )
        }
    }
    
    func layout(subViews: [NSUIView], constraints: [NSLayoutConstraint]) {
        for subView in subViews {
            if subView.superview == nil {
                addSubview(subView)
            }
            
            if subView.translatesAutoresizingMaskIntoConstraints {
                subView.translatesAutoresizingMaskIntoConstraints = false
            }
        }
        
        for constraint in constraints {
            constraint.isActive = true
        }
    }
    
    func constraint(size: CGSize) {
        if translatesAutoresizingMaskIntoConstraints {
            translatesAutoresizingMaskIntoConstraints = false
        }
        
        widthAnchor.constraint(equalToConstant: size.width).isActive = true
        heightAnchor.constraint(equalToConstant: size.height).isActive = true
    }
}

public extension NSUIView {
    struct GridConfig {
        var rows: Int = 1
        var columns: Int = 1
        var margin: CGFloat = 5
        var edgeInsets: NSUIEdgeInsets = .zero
    }
}

extension NSUILayoutGuide: LayoutGuideProtocol { }
extension NSUIView: LayoutGuideProtocol { }

extension NSUIView: GeometryProtocol { }
extension NSUIView: SubViewLayoutProtocol { }

public extension NSUIView {
    var viewController: NSUIViewController? {
        for view in sequence(first: superview, next: { $0?.superview }) {
#if os(iOS)
            guard let nextResponder = view?.next else { return nil }
#elseif os(macOS)
            guard let nextResponder = view?.nextResponder else { return nil }
#endif
            
            if let controller = nextResponder as? NSUIViewController {
                return controller
            }
            
            if nextResponder.isMember(of: NSObject.self) {
                return nil
            }
        }
        
        return nil
    }
}

#if canImport(Cocoa) || canImport(UIKit)

public extension NSUIView {
    convenience init(subView: NSUIView, insets: NSUIEdgeInsets = .zero, saftyLayout: Bool = true) {
        self.init(frame: CGRectMake(0, 0, 100, 100))
        self.layout(subView: subView, insets: insets, saftyLayout: saftyLayout)
    }
    
    convenience init(subView view: NSUIView, padding: CGFloat, saftyLayout: Bool = true) {
        self.init(frame: CGRectMake(0, 0, 100, 100))
        layout(subView: view, insets: NSUIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding), saftyLayout: saftyLayout)
    }
    
    convenience init(centerSubView view: NSUIView, horizontalPadding: CGFloat = 0, verticalPadding: CGFloat = 0, saftyLayout: Bool = false) {
        self.init(frame: CGRectMake(0, 0, 100, 100))
        layoutCenter(subView: view, horizontalPadding: horizontalPadding, verticalPadding: verticalPadding, saftyLayout: saftyLayout)
    }
    
    convenience init(subViews: [String: NSUIView], vfls: [String], metrics: [String: Any] = [:], options: NSLayoutConstraint.FormatOptions = .directionMask) {
        self.init(frame: CGRectMake(0, 0, 100, 100))
        self.layout(subViews: subViews, vfls: vfls, metrics: metrics, options: options)
    }
    
    convenience init(gridConfig: NSUIView.GridConfig? = nil, creation: (Int, Int) -> NSUIView) {
        self.init(frame: CGRectMake(0, 0, 100, 100))
        self.gridLayout(with: gridConfig, creation: creation)
    }
    
    convenience init(subViews: [NSUIView], constraintsMaker: ((_ superView: NSUIView) -> [NSLayoutConstraint])) {
        self.init(frame: CGRectMake(0, 0, 100, 100))
        self.layout(subViews: subViews, constraints: constraintsMaker(self))
    }
    
    convenience init(subViews: [NSUIView], constraints: [NSLayoutConstraint]) {
        self.init(frame: CGRectMake(0, 0, 100, 100))
        self.layout(subViews: subViews, constraints: constraints)
    }
}

#endif

#endif


//
//  File.swift
//  
//
//  Created by Jo on 2022/12/14.
//

#if !os(Linux)

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

public extension NSUIColor {
    enum ComponentsType: String, CaseIterable {
        case RGB
        case CMYK
        case CMY
        case HSB
        case HSL
        case YUV
        case YCbCr
        case YDbDr
        case YPbPr
        case YIQ
    }
}

internal extension NSUIColor.ComponentsType {
    var bridgeType: NSUIColor.ComponentsType {
        switch self {
        case .RGB: fallthrough
        case .CMYK: fallthrough
        case .CMY: fallthrough
        case .HSB: fallthrough
        case .HSL: fallthrough
        case .YUV: fallthrough
        case .YCbCr: fallthrough
        case .YDbDr: fallthrough
        case .YPbPr: fallthrough
        case .YIQ: return .RGB
        }
    }
}

/// https://github.com/ibireme/yy_color_convertor
public protocol NSUIColorComponentsProtocol {
    var componentsType: NSUIColor.ComponentsType { get }
    func prettyStringValue() -> String
    func toBridgeComponents() -> NSUIColorComponentsProtocol
}

public extension NSUIColorComponentsProtocol {
    func to(_ componentsType: NSUIColor.ComponentsType) -> NSUIColorComponentsProtocol {
        if componentsType == self.componentsType {
            return self
        }
        
        if let components = self as? NSUIColor.CMYComponents, componentsType == .CMYK {
            return components.toCMYKComponents()
        }
        
        if let components = self as? NSUIColor.CMYKComponents, componentsType == .CMY {
            return components.toCMYComponents()
        }
        
        if let components = self as? NSUIColor.HSLComponents, componentsType == .HSB {
            return components.toHSBComponents()
        }
        
        if let components = self as? NSUIColor.HSBComponents, componentsType == .HSL {
            return components.toHSLComponents()
        }
        
        let bridgeComponents = toBridgeComponents()
        
        if let bridgeComponents = bridgeComponents as? NSUIColor.RGBComponents {
            return bridgeComponents.convertTo(componentsType)
        }
        
        return bridgeComponents
    }
}

#endif

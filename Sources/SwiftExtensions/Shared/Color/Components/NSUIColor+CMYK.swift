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
    struct CMYKComponents {
        public private(set) var componentsType: NSUIColor.ComponentsType = .CMYK
        
        /// The cyan component value of the color.
        /// Display as %0 ~ 100%, the value is 0 ~ 1
        public var cyan: CGFloat
        /// The magenta component value of the color.
        /// Display as %0 ~ 100%, the value is 0 ~ 1
        public var magenta: CGFloat
        /// The yellow component value of the color.
        /// Display as %0 ~ 100%, the value is 0 ~ 1
        public var yellow: CGFloat
        /// The black component value of the color.
        /// Display as %0 ~ 100%, the value is 0 ~ 1
        public var black: CGFloat
        /// The alpha component value of the color.
        public var alpha: CGFloat = 1
        
        public init(cyan: CGFloat, magenta: CGFloat, yellow: CGFloat, black: CGFloat, alpha: CGFloat = 1) {
            self.cyan = cyan
            self.magenta = magenta
            self.yellow = yellow
            self.black = black
            self.alpha = alpha
        }
    }
    
    var cmykComponents: CMYKComponents {
        var cyan: CGFloat = 1.0
        var magenta: CGFloat = 1.0
        var yellow: CGFloat = 1.0
        var black: CGFloat = 1.0
        var alpha: CGFloat = 1.0
        
        if self.colorSpace == .deviceCMYK {
            getCyan(&cyan, magenta: &magenta, yellow: &yellow, black: &black, alpha: &alpha)
        } else {
            usingColorSpace(.deviceCMYK)?
                .getCyan(&cyan, magenta: &magenta, yellow: &yellow, black: &black, alpha: &alpha)
        }
        
        return CMYKComponents(cyan: cyan, magenta: magenta, yellow: yellow, black: black, alpha: alpha)
    }
}

extension NSUIColor.CMYKComponents: NSUIColorComponentsProtocol {
    public func prettyStringValue() -> String {
        return String(format: "CMYK(%.2f%%, %.2f%%, %.2f%%, %.2f%%)", cyan * 100, magenta * 100, yellow * 100, black * 100)
    }
    
    public func toBridgeComponents() -> NSUIColorComponentsProtocol {
        return NSUIColor.RGBComponents(
            R: (1 - cyan) * (1 - black),
            G: (1 - magenta) * (1 - black),
            B: (1 - yellow) * (1 - black)
        )
    }
    
    public func toCMYComponents() -> NSUIColor.CMYComponents {
        return NSUIColor.CMYComponents(
            cyan: cyan * (1 - black) + black,
            magenta: magenta * (1 - black) + black,
            yellow: yellow * (1 - black) + black
        )
    }
}

#endif

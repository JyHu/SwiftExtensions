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
        public let componentsType: NSUIColor.ComponentsType = .CMYK
        
        /// The cyan component value of the color.
        /// Display as %0 ~ 100%, the value is 0 ~ 1
        public let cyan: CGFloat
        /// The magenta component value of the color.
        /// Display as %0 ~ 100%, the value is 0 ~ 1
        public let magenta: CGFloat
        /// The yellow component value of the color.
        /// Display as %0 ~ 100%, the value is 0 ~ 1
        public let yellow: CGFloat
        /// The black component value of the color.
        /// Display as %0 ~ 100%, the value is 0 ~ 1
        public let black: CGFloat
        /// The alpha component value of the color.
        public let alpha: CGFloat
        
        public init(cyan: CGFloat, magenta: CGFloat, yellow: CGFloat, black: CGFloat, alpha: CGFloat = 1) {
            self.cyan = cyan
            self.magenta = magenta
            self.yellow = yellow
            self.black = black
            self.alpha = alpha
        }
    }
    
    var cmykComponents: CMYKComponents {
        return rgbComponents.toCMYKComponents()
    }
}

extension NSUIColor.CMYKComponents: NSUIColorComponentsProtocol {
    public func prettyStringValue() -> String {
        return String(format: "CMYK(%.2f%%, %.2f%%, %.2f%%, %.2f%%)", cyan * 100, magenta * 100, yellow * 100, black * 100)
    }
    
    public func toBridgeComponents() -> NSUIColorComponentsProtocol {
        return NSUIColor.RGBComponents(
            red: (1 - cyan) * (1 - black),
            green: (1 - magenta) * (1 - black),
            blue: (1 - yellow) * (1 - black)
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

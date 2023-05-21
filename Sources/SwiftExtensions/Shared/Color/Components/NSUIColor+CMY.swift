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
    struct CMYComponents {
        public let componentsType: NSUIColor.ComponentsType = .CMY
        
        /// The cyan component value of the color.
        /// Display as %0 ~ 100%, the value is 0 ~ 1
        public let cyan: CGFloat
        /// The magenta component value of the color.
        /// Display as %0 ~ 100%, the value is 0 ~ 1
        public let magenta: CGFloat
        /// The yellow component value of the color.
        /// Display as %0 ~ 100%, the value is 0 ~ 1
        public let yellow: CGFloat
        /// The alpha component value of the color.
        public let alpha: CGFloat
        
        public init(cyan: CGFloat, magenta: CGFloat, yellow: CGFloat, alpha: CGFloat = 1) {
            self.cyan = cyan
            self.magenta = magenta
            self.yellow = yellow
            self.alpha = alpha
        }
    }
    
    var cmyComponents: CMYComponents {
        return rgbComponents.toCMYComponents()
    }
}

extension NSUIColor.CMYComponents: NSUIColorComponentsProtocol {
    public func prettyStringValue() -> String {
        return String(format: "CMY(%.2f%%, %.2f%%, %.2f%%)", cyan * 100, magenta * 100, yellow * 100)
    }
    
    public func toBridgeComponents() -> NSUIColorComponentsProtocol {
        return NSUIColor.RGBComponents(
            red: (1 - cyan),
            green: (1 - magenta),
            blue: (1 - yellow)
        )
    }
    
    public func toCMYKComponents() -> NSUIColor.CMYKComponents {
        let kk = min(min(cyan, magenta), yellow)
        
        if kk == 1 {
            return NSUIColor.CMYKComponents(cyan: 0, magenta: 0, yellow: 0, black: kk)
        }
        
        return NSUIColor.CMYKComponents(
            cyan: (cyan - kk) / (1 - kk),
            magenta: (magenta - kk) / (1 - kk),
            yellow: (yellow - kk) / (1 - kk),
            black: kk
        )
    }
}

#endif

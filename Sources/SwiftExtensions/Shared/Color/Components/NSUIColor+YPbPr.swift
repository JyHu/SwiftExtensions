//
//  File.swift
//  
//
//  Created by Jo on 2022/12/15.
//

#if !os(Linux)

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif


public extension NSUIColor {
    struct YPbPrComponents {
        public let componentsType: NSUIColor.ComponentsType = .YPbPr
        
        /// Y
        public let luminance: CGFloat
        /// Pb
        public let blue: CGFloat
        /// Pr
        public let red: CGFloat
        
        public init(luminance: CGFloat, blue: CGFloat, red: CGFloat) {
            self.luminance = luminance
            self.blue = blue
            self.red = red
        }
    }
    
    var ypbprComponents: YPbPrComponents {
        return rgbComponents.toYPbPrComponents()
    }
}

extension NSUIColor.YPbPrComponents: NSUIColorComponentsProtocol {
    public func prettyStringValue() -> String {
        return String(format: "YPbPr(%.2f, %.2f, %.2f)", luminance, blue, red)
    }
    
    public func toBridgeComponents() -> NSUIColorComponentsProtocol {
        let Pb = blue - 0.5
        let Pr = red - 0.5
        
        let R = 0.99999999999914679361 * luminance - 1.2188941887145875e-06 * Pb + 1.4019995886561440468 * Pr
        let G = 0.99999975910502514331 * luminance - 0.34413567816504303521 * Pb - 0.71413649331646789076 * Pr
        let B = 1.00000124040004623180 * luminance + 1.77200006607230409200 * Pb + 2.1453384174593273e-06 * Pr
        
        return NSUIColor.RGBComponents(red: R, green: G, blue: B)
    }
}

#endif

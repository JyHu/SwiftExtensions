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
    struct YCbCrComponents {
        public private(set) var componentsType: NSUIColor.ComponentsType = .YCbCr
        
        /// Y
        public var luminance: CGFloat
        /// Cb
        public var blue: CGFloat
        /// Cr
        public var red: CGFloat
        
        public init(luminance: CGFloat, blue: CGFloat, red: CGFloat) {
            self.luminance = luminance
            self.blue = blue
            self.red = red
        }
    }
    
    var ycbcrComponents: YCbCrComponents {
        return rgbComponents.toYCbCrComponents()
    }
}

extension NSUIColor.YCbCrComponents: NSUIColorComponentsProtocol {
    public func prettyStringValue() -> String {
        return String(format: "YCbCr(%.2f, %.2f, %.2f)", luminance, blue, red)
    }
    
    public func toBridgeComponents() -> NSUIColorComponentsProtocol {
        let Cb = blue - 0.5
        let Cr = red - 0.5
        
        let R = 0.99999999999914679361 * luminance - 1.2188941887145875e-06 * Cb + 1.4019995886561440468 * Cr
        let G = 0.99999975910502514331 * luminance - 0.34413567816504303521 * Cb - 0.71413649331646789076 * Cr
        let B = 1.00000124040004623180 * luminance + 1.77200006607230409200 * Cb + 2.1453384174593273e-06 * Cr
        return NSUIColor.RGBComponents(R: R, G: G, B: B)
    }
}

#endif

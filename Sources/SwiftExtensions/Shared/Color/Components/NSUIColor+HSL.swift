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
    struct HSLComponents {
        public private(set) var componentsType: NSUIColor.ComponentsType = .HSL

        /// The hue component of the color object.
        /// Display as degree, 0 ~ 360
        public var hue: CGFloat
        /// The saturation component of the color object.
        /// Display as 0% ~ 100%, the value is 0 ~ 1
        public var saturation: CGFloat
        /// The lightness component of the color object. 0 ~ 1
        /// Display as 0% ~ 100%, the value is 0 ~ 1
        public var lightness: CGFloat
        /// The opacity value of the color object.
        public var alpha: CGFloat = 1
        
        public init(hue: CGFloat, saturation: CGFloat, lightness: CGFloat, alpha: CGFloat = 1) {
            self.hue = hue
            self.saturation = saturation
            self.lightness = lightness
            self.alpha = alpha
        }
    }
    
    /// Convert the color object to HSB Components value.
    var hslComponents: HSLComponents {
        return hsbComponents.toHSLComponents()
    }
}


extension NSUIColor.HSLComponents: NSUIColorComponentsProtocol {
    public func prettyStringValue() -> String {
        return String(format: "HSL(%.2fº, %.2f%%, %.2f%%)", hue * 360, saturation * 100, lightness * 100)
    }
    
    public func toBridgeComponents() -> NSUIColorComponentsProtocol {
        if saturation == 0 {
            return NSUIColor.RGBComponents(R: lightness, G: lightness, B: lightness)
        }
        
        let q = (lightness <= 0.5) ? (lightness * (1 + saturation)) : (lightness + saturation - lightness * saturation)
        
        if q <= 0 {
            return NSUIColor.RGBComponents(R: 0, G: 0, B: 0)
        }
        
        let m = lightness * 2 - q
        let sv = (q - m) / q
        
        let H = (hue == 1 ? 0 : hue) * 6
        let sextant = Int(floor(H))
        
        let fract = H - CGFloat(sextant)
        let vsf = q * sv * fract
        let mid1 = m + vsf
        let mid2 = q - vsf
        
        switch sextant {
        case 0: return NSUIColor.RGBComponents(R: q, G: mid1, B: m)
        case 1: return NSUIColor.RGBComponents(R: mid2, G: q, B: m)
        case 2: return NSUIColor.RGBComponents(R: m, G: q, B: mid1)
        case 3: return NSUIColor.RGBComponents(R: m, G: mid2, B: q)
        case 4: return NSUIColor.RGBComponents(R: mid1, G: m, B: q)
        case 5: return NSUIColor.RGBComponents(R: q, G: m, B: mid2)
        default: return NSUIColor.RGBComponents(R: 0, G: 0, B: 0)
        }
    }
    
    public func toHSBComponents() -> NSUIColor.HSBComponents {
        let H = hue
        
        var B: CGFloat = 0
        var S: CGFloat = 0
        
        if lightness <= 0.5 {
            B = (saturation + 1) * lightness
            S = 2 * saturation / (saturation + 1)
        } else {
            B = lightness + saturation * (1 - lightness)
            S = 2 * saturation * (1 - lightness) / B
        }
        
        return NSUIColor.HSBComponents(hue: H, saturation: S, brightness: B)
    }
}

#endif

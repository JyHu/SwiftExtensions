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
    struct HSBComponents {
        public let componentsType: NSUIColor.ComponentsType = .HSB

        /// The hue component of the color object.
        /// Display as degree, 0 ~ 360
        public let hue: CGFloat
        /// The saturation component of the color object.
        /// Display as 0% ~ 100%, the value is 0 ~ 1
        public let saturation: CGFloat
        /// The brightness component of the color object. 0 ~ 1
        /// Display as 0% ~ 100%, the value is 0 ~ 1
        public let brightness: CGFloat
        /// The opacity value of the color object.
        public let alpha: CGFloat
        
        public init(hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat = 1) {
            self.hue = hue
            self.saturation = saturation
            self.brightness = brightness
            self.alpha = alpha
        }
    }
    
    /// Convert the color object to HSB Components value.
    var hsbComponents: HSBComponents {
        var hue: CGFloat = 0.0
        var saturation: CGFloat = 0.0
        var brightness: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        
        getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        return HSBComponents(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    }
}


extension NSUIColor.HSBComponents: NSUIColorComponentsProtocol {
    public func prettyStringValue() -> String {
        return String(format: "HSB(%.2fº, %.2f%%, %.2f%%)", hue * 360, saturation * 100, brightness * 100)
    }
    
    public func toBridgeComponents() -> NSUIColorComponentsProtocol {
        if saturation == 0 {
            return NSUIColor.RGBComponents(red: brightness, green: brightness, blue: brightness)
        }
        
        let H = (hue == 1 ? 0 : hue) * 6
        let sextant = Int(floor(H))
        
        let f = H - CGFloat(sextant)
        let p = brightness * (1 - saturation)
        let q = brightness * (1 - saturation * f)
        let t = brightness * (1 - saturation * (1 - f))
        
        switch sextant {
        case 0: return NSUIColor.RGBComponents(red: brightness, green: t, blue: p)
        case 1: return NSUIColor.RGBComponents(red: q, green: brightness, blue: p)
        case 2: return NSUIColor.RGBComponents(red: p, green: brightness, blue: t)
        case 3: return NSUIColor.RGBComponents(red: p, green: q, blue: brightness)
        case 4: return NSUIColor.RGBComponents(red: t, green: p, blue: brightness)
        case 5: return NSUIColor.RGBComponents(red: brightness, green: p, blue: q)
        default: return NSUIColor.RGBComponents(red: 0, green: 0, blue: 0)
        }
    }
    
    public func toHSLComponents() -> NSUIColor.HSLComponents {
        let ll = (2 - saturation) * brightness / 2
        var S: CGFloat = 0
        
        if ll <= 0.5 {
            S = saturation / (2 - saturation)
        } else {
            S = (saturation * brightness) / (2 - (2 - saturation) * brightness)
        }
        
        return NSUIColor.HSLComponents(hue: hue, saturation: S, lightness: ll)
    }
}

#endif

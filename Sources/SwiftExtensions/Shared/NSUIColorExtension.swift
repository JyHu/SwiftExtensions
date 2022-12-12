//
//  File.swift
//
//
//  Created by Jo on 2022/10/28.
//

#if !os(Linux)

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
public typealias NSUIColor = NSColor
#elseif canImport(UIKit)
import UIKit
public typealias NSUIColor = UIColor
#endif

public extension NSUIColor {
    
    /// Create color object using RGBA channel values
    /// - Note: If the component value is smaller than the minimum, it will take
    ///     the minimum value; If it's bigger than the maximum, then it's going
    ///     to be the maximum
    /// - Parameters:
    ///   - R: red component value, 0 ~ 255
    ///   - G: green component value, 0 ~ 255
    ///   - B: blue component value, 0 ~ 255
    ///   - alpha: alpha component value, 0 ~ 1
    convenience init(R: Int, G: Int, B: Int, alpha: CGFloat = 1) {
        func _v(_ v: Int) -> CGFloat {
            CGFloat(min(max(0, v), 255)) / 255
        }
        self.init(red: _v(R), green: _v(G), blue: _v(B), alpha: alpha)
    }
    
    /// Create color object using hex value.
    /// - Parameter hexValue: Hex value, 0x000000 ~ 0xFFFFFF
    convenience init(hexValue: UInt, alpha: CGFloat = 1) {
        self.init(
            R: Int((hexValue & 0xFF0000) >> 16),
            G: Int((hexValue & 0xFF00) >> 8),
            B: Int(hexValue & 0xFF),
            alpha: alpha
        )
    }
    
    /// Create color object using hex string value.
    /// - Parameter hexString: Hex string value
    convenience init(hexString: String) {
        var hexValue: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&hexValue)
        self.init(hexValue: UInt(hexValue))
    }
    
    /// Generate a random color object.
    /// - Returns: NS/UIColor object.
    static func random() -> NSUIColor {
        func g() -> Int { return Int.random(in: 0 ... 255) }
        return NSUIColor(R: g(), G: g(), B: g())
    }
    
    /// Get the alpha component value from color object.
    var alpha: CGFloat {
        cgColor.alpha
    }
    
    /// Convert the color object to hex string.
    /// - Parameters:
    ///   - prefix: The prefix value of color hex string.
    ///   - defaultHex: The default hex string.
    /// - Returns: Color hex string.
    func hexString(prefix: String = "#", defaultHex: String = "000000") -> String {
        guard let components = rgbComponents else { return prefix + defaultHex }
        return String(format: "\(prefix)%02X%02X%02X", components.red, components.green, components.blue)
    }
    
    /// Convert the color object to uint hex value.
    var hexValue: UInt {
        guard let components = rgbComponents else { return 0 }
        return UInt(components.red) << 16 + UInt(components.green) << 8 + UInt(components.blue)
    }
}

public extension NSUIColor {
    
    struct RGBComponents {
        
        /// The red component value, 0 ~ 255
        var R: CGFloat
        /// The green component value, 0 ~ 255
        var G: CGFloat
        /// The blue component value, 0 ~ 255
        var B: CGFloat
        
        /// The red component value, 0 ~ 1
        var red: Int
        /// The green component value, 0 ~ 1
        var green: Int
        /// The blue component value, 0 ~ 1
        var blue: Int
        
        /// The alpha component value, 0 ~ 1
        var alpha: CGFloat = 1
        
        fileprivate init(R: CGFloat, G: CGFloat, B: CGFloat, alpha: CGFloat) {
            self.R = R
            self.G = G
            self.B = B
            
            red = Int(R * 255)
            green = Int(G * 255)
            blue = Int(B * 255)
            
            self.alpha = alpha
        }
    }
    
    /// Convert the color object to RGB Components value.
    var rgbComponents: RGBComponents? {
        guard let components = cgColor.components else { return nil }
        
        if components.count == 4 {
            return RGBComponents(R: components[0], G: components[1], B: components[2], alpha: components[3])
        }
        
        if components.count == 2 {
            return RGBComponents(R: components[0], G: components[0], B: components[0], alpha: components[1])
        }
        
        return nil
    }
}

public extension NSUIColor {
    struct HSBComponents {
        /// The hue component of the color object.
        var hue: CGFloat
        /// The saturation component of the color object.
        var saturation: CGFloat
        /// The brightness component of the color object.
        var brightness: CGFloat
        /// The opacity value of the color object.
        var alpha: CGFloat = 1
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

public extension NSUIColor {
    struct WhiteComponents {
        /// The white component value of the color.
        var white: CGFloat
        /// The alpha (opacity) component value of the color.
        var alpha: CGFloat = 1
    }
    
    /// Convert the color object to White Components value.
    var whiteComponents: WhiteComponents {
        var white: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        getWhite(&white, alpha: &alpha)
        return WhiteComponents(white: white, alpha: alpha)
    }
}

public extension NSUIColor {
    struct CMYBComponents {
        /// The cyan component value of the color.
        var cyan: CGFloat
        /// The magenta component value of the color.
        var magenta: CGFloat
        /// The yellow component value of the color.
        var yellow: CGFloat
        /// The black component value of the color.
        var black: CGFloat
        /// The alpha component value of the color.
        var alpha: CGFloat = 1
    }
    
    var cmybComponents: CMYBComponents {
        var cyan: CGFloat = 1.0
        var magenta: CGFloat = 1.0
        var yellow: CGFloat = 1.0
        var black: CGFloat = 1.0
        var alpha: CGFloat = 1.0
        
        getCyan(&cyan, magenta: &magenta, yellow: &yellow, black: &black, alpha: &alpha)
        return CMYBComponents(cyan: cyan, magenta: magenta, yellow: yellow, black: black, alpha: alpha)
    }
}

#endif

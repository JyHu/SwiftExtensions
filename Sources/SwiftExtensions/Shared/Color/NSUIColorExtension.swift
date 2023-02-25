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
        var offset: Int = 0
        if hexString.hasPrefix("0x") {
            offset = 2
        } else if hexString.hasPrefix("#") {
            offset = 1
        }
        
        let startIndex = hexString.index(hexString.startIndex, offsetBy: offset)
        let scanned = hexString[startIndex..<hexString.endIndex]
        var hexValue: UInt64 = 0
        Scanner(string: String(scanned)).scanHexInt64(&hexValue)
        self.init(hexValue: UInt(hexValue))
    }
    
    convenience init(components: NSUIColorComponentsProtocol) {
        if let hsbComponents = components as? NSUIColor.HSBComponents {
            self.init(
                hue: hsbComponents.hue,
                saturation: hsbComponents.saturation,
                brightness: hsbComponents.brightness,
                alpha: hsbComponents.alpha
            )
        } else if let cmykComponents = components as? NSUIColor.CMYKComponents {
            self.init(
                deviceCyan: cmykComponents.cyan,
                magenta: cmykComponents.magenta,
                yellow: cmykComponents.yellow,
                black: cmykComponents.black,
                alpha: cmykComponents.alpha
            )
        } else if let cmyComponents = components as? CMYComponents {
            self.init(components: cmyComponents.toCMYKComponents())
        } else if let hslComponents = components as? HSLComponents {
            self.init(components: hslComponents.toHSBComponents())
        } else {
            let rgbComponents = (components.to(.RGB) as? RGBComponents) ?? RGBComponents(hexValue: 0x000000)
            self.init(
                red: rgbComponents.R,
                green: rgbComponents.G,
                blue: rgbComponents.B,
                alpha: rgbComponents.alpha
            )
        }
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
        let components = rgbComponents
        return String(format: "\(prefix)%02X%02X%02X", components.red, components.green, components.blue)
    }
    
    /// Convert the color object to uint hex value.
    var hexValue: UInt {
        let components = rgbComponents
        return UInt(components.red) << 16 + UInt(components.green) << 8 + UInt(components.blue)
    }
}

#endif

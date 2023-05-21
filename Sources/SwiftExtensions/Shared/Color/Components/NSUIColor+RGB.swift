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
    
    struct RGBComponents {
        public let componentsType: NSUIColor.ComponentsType = .RGB

        /// The red component value, 0 ~ 255
        public let R: UInt
        /// The green component value, 0 ~ 255
        public let G: UInt
        /// The blue component value, 0 ~ 255
        public let B: UInt
        
        /// The red component value, 0 ~ 1
        public let red: CGFloat
        /// The green component value, 0 ~ 1
        public let green: CGFloat
        /// The blue component value, 0 ~ 1
        public let blue: CGFloat
        
        /// The alpha component value, 0 ~ 1
        public let alpha: CGFloat
        
        public let hexValue: UInt
        public let hexString: String
        
        public init(R: UInt, G: UInt, B: UInt, alpha: CGFloat = 1) {
            self.R = R
            self.G = G
            self.B = B
            
            self.red = CGFloat(R) / 255
            self.green = CGFloat(G) / 255
            self.blue = CGFloat(B) / 255
            
            self.alpha = alpha
            self.hexValue = (((R << 8) + G) << 8) + B
            self.hexString = String(format: "#%02X%02X%02X", R, G, B)
        }
        
        public init(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1) {
            self.R = UInt(red * 255)
            self.G = UInt(green * 255)
            self.B = UInt(blue * 255)
            
            self.red = red
            self.green = green
            self.blue = blue
            
            self.alpha = alpha
            self.hexValue = (UInt(R << 8) + G) << 8 + B
            self.hexString = String(format: "#%02X%02X%02X", R, G, B)
        }
        
        public init(hexValue: UInt, alpha: CGFloat = 1) {
            self.R = UInt(hexValue >> 16)
            self.G = UInt((hexValue >> 8) & 0xFF)
            self.B = UInt(hexValue & 0xFF)
            
            self.red = CGFloat(R) / 255.0
            self.green = CGFloat(G) / 255.0
            self.blue = CGFloat(B) / 255.0
            
            self.alpha = alpha
            self.hexValue = hexValue
            self.hexString = String(format: "#%02X%02X%02X", R, G, B)
        }
        
        public init?(hexString: String) {
            func getOffset() -> Int {
                if hexString.hasPrefix("0x") || hexString.hasPrefix("0X") {
                    return 2
                }
                if hexString.hasPrefix("#") {
                    return 1
                }
                return 0
            }
            
            let offset = getOffset()
            
            guard hexString.count == offset + 6 else { return nil }
            
            let startIndex = hexString.index(hexString.startIndex, offsetBy: getOffset())
            let scannedHex = hexString[startIndex ..< hexString.endIndex]
            
            var hexValue: UInt64 = 0
            Scanner(string: String(scannedHex)).scanHexInt64(&hexValue)
            
            self.init(hexValue: UInt(hexValue))
        }
    }
    
    /// Convert the color object to RGB Components value.
    var rgbComponents: RGBComponents {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return RGBComponents(red: red, green: green, blue: blue, alpha: alpha)
    }
}

extension NSUIColor.RGBComponents: NSUIColorComponentsProtocol {
    public func toBridgeComponents() -> NSUIColorComponentsProtocol {
        return self
    }
    
    public func prettyStringValue() -> String {
        if alpha == 1 {
            return "RGB(\(red), \(green), \(blue))"
        }
        
        let alpha = String(format: "%.2f", alpha)
        return "RGBA(\(red), \(green), \(blue), \(alpha))"
    }
}

#endif

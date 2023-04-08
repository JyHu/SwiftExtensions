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
        public private(set) var componentsType: NSUIColor.ComponentsType = .RGB

        /// The red component value, 0 ~ 255
        public var R: CGFloat
        /// The green component value, 0 ~ 255
        public var G: CGFloat
        /// The blue component value, 0 ~ 255
        public var B: CGFloat
        
        /// The red component value, 0 ~ 1
        public var red: Int
        /// The green component value, 0 ~ 1
        public var green: Int
        /// The blue component value, 0 ~ 1
        public var blue: Int
        
        /// The alpha component value, 0 ~ 1
        public var alpha: CGFloat = 1
        
        public var hexValue: UInt
        public var hexString: String
        
        public init(R: CGFloat, G: CGFloat, B: CGFloat, alpha: CGFloat = 1) {
            self.R = R
            self.G = G
            self.B = B
            
            red = Int(R * 255)
            green = Int(G * 255)
            blue = Int(B * 255)
            
            self.alpha = alpha
            self.hexValue = (((UInt(red) << 8) + UInt(green)) << 8) + UInt(blue)
            self.hexString = String(format: "#%02X%02X%02X", red, green, blue)
        }
        
        public init(red: Int, green: Int, blue: Int, alpha: CGFloat = 1) {
            self.init(hexValue: UInt((((red << 8) + green) << 8) + blue), alpha: alpha)
        }
        
        public init(hexValue: UInt, alpha: CGFloat = 1) {
            self.hexValue = hexValue
            
            self.alpha = alpha
            
            red = Int(hexValue >> 16)
            green = Int((hexValue >> 8) & 0xFF)
            blue = Int(hexValue & 0xFF)
            
            R = CGFloat(red) / 255.0
            G = CGFloat(green) / 255.0
            B = CGFloat(blue) / 255.0
            
            hexString = String(format: "#%02X%02X%02X", red, green, blue)
        }
        
        public init(hexString: String) {
            func getOffset() -> Int {
                if hexString.hasPrefix("0x") || hexString.hasPrefix("0X") {
                    return 2
                }
                if hexString.hasPrefix("#") {
                    return 1
                }
                return 0
            }
            
            let startIndex = hexString.index(hexString.startIndex, offsetBy: getOffset())
            let scannedHex = hexString[startIndex ..< hexString.endIndex]
            
            var hexValue: UInt64 = 0
            Scanner(string: String(scannedHex)).scanHexInt64(&hexValue)
            
            self.init(hexValue: UInt(hexValue))
        }
    }
    
    /// Convert the color object to RGB Components value.
    var rgbComponents: RGBComponents {
        var R: CGFloat = 0
        var G: CGFloat = 0
        var B: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&R, green: &G, blue: &B, alpha: &alpha)
        return RGBComponents(R: R, G: G, B: B, alpha: alpha)
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

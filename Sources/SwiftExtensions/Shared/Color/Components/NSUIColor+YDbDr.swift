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
    struct YDbDrComponents {
        public let componentsType: NSUIColor.ComponentsType = .YDbDr
        
        /// Y
        public let luminance: CGFloat
        /// Db
        public let blue: CGFloat
        /// Dr
        public let red: CGFloat
        
        public init(luminance: CGFloat, blue: CGFloat, red: CGFloat) {
            self.luminance = luminance
            self.blue = blue
            self.red = red
        }
    }
    
    var ydbdrComponents: YDbDrComponents {
        return rgbComponents.toYDbDrComponents()
    }
}

extension NSUIColor.YDbDrComponents: NSUIColorComponentsProtocol {
    public func prettyStringValue() -> String {
        return String(format: "YDbDr(%.2f, %.2f, %.2f)", luminance, blue, red)
    }
    
    public func toBridgeComponents() -> NSUIColorComponentsProtocol {
        let Db = blue - 0.5
        let Dr = red - 0.5
        
        let R = luminance + 9.2303716147657e-05 * Db - 0.52591263066186533 * Dr;
        let G = luminance - 0.12913289889050927 * Db + 0.26789932820759876 * Dr;
        let B = luminance + 0.66467905997895482 * Db - 7.9202543533108e-05 * Dr;
        
        return NSUIColor.RGBComponents(red: R, green: G, blue: B)
    }
}

#endif

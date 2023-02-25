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

internal extension NSUIColor.RGBComponents {
    func convertTo(_ componentsType: NSUIColor.ComponentsType) -> NSUIColorComponentsProtocol {
        switch componentsType {
        case .RGB: return self
        case .CMY: return toCMYComponents()
        case .CMYK: return toCMYKComponents()
        case .HSB: return toHSBComponents()
        case .HSL: return toHSLComponents()
        case .YUV: return toYUVComponents()
        case .YCbCr: return toYCbCrComponents()
        case .YDbDr: return toYDbDrComponents()
        case .YPbPr: return toYPbPrComponents()
        case .YIQ: return toYIQComponents()
        }
    }
    
    func toCMYComponents() -> NSUIColor.CMYComponents {
        return NSUIColor.CMYComponents(cyan: 1 - R, magenta: 1 - G, yellow: 1 - B)
    }
    
    func toCMYKComponents() -> NSUIColor.CMYKComponents {
        let C: CGFloat = 1 - R
        let M: CGFloat = 1 - G
        let Y: CGFloat = 1 - B
        let K: CGFloat = min(min(C, M), Y)
        
        if K == 1 {
            return NSUIColor.CMYKComponents(cyan: 0, magenta: 0, yellow: 0, black: 1)
        }
        
        return NSUIColor.CMYKComponents(
            cyan: (C - K) / (1 - K),
            magenta: (M - K) / (1 - K),
            yellow: (Y - K) / (1 - K),
            black: K
        )
    }
    
    func toHSBComponents() -> NSUIColor.HSBComponents {
        let maxVal = max(max(R, G), B)
        let minVal = min(min(R, G), B)
        
        let delta = maxVal - minVal
        let V = maxVal
        
        if delta == 0 {
            return NSUIColor.HSBComponents(hue: 0, saturation: 0, brightness: V)
        }
        
        let S = delta / maxVal
        var H: CGFloat = 0
        
        if R == maxVal {
            H = (G - B) / delta / 6
        } else if (G == maxVal) {
            H = (2 + (B - R) / delta) / 6
        } else {
            H = (4 + (R - G) / delta) / 6
        }
        
        if H < 0 {
            H += 1
        }
        
        return NSUIColor.HSBComponents(hue: H, saturation: S, brightness: V)
    }
    
    func toHSLComponents() -> NSUIColor.HSLComponents {
        let maxVal = max(max(R, G), B)
        let minVal = min(min(R, G), B)
        
        let delta = maxVal - minVal
        let sumVal = maxVal + minVal
        
        let L = sumVal / 2
        
        if delta == 0 {
            return NSUIColor.HSLComponents(hue: 0, saturation: 0, lightness: L)
        }
        
        let S = delta / (sumVal < 1 ? sumVal : 2 - sumVal)
        var H: CGFloat = 0
        
        if R == maxVal {
            H = (G - B) / delta / 6
        } else if (G == maxVal) {
            H = (2 + (B - R) / delta) / 6
        } else {
            H = (4 + (R - G) / delta) / 6
        }
        
        if H < 0 {
            H += 1
        }
        
        return NSUIColor.HSLComponents(hue: H, saturation: S, lightness: L)
    }
    
    func toYUVComponents() -> NSUIColor.YUVComponents {
        let Y =  0.298839 * R + 0.586811 * G + 0.114350 * B;
        let U = -0.147    * R - 0.289    * G + 0.436    * B + 0.5;
        let V =  0.615    * R - 0.515    * G - 0.100    * B + 0.5;
        
        return NSUIColor.YUVComponents(luma: Y, chroma1: U, chroma2: V)
    }
    
    func toYCbCrComponents() -> NSUIColor.YCbCrComponents {
        let Y  =  0.298839 * R + 0.586811 * G + 0.114350 * B;
        let Cb = -0.168737 * R - 0.331264 * G + 0.500000 * B + 0.5;
        let Cr =  0.500000 * R - 0.418688 * G - 0.081312 * B + 0.5;
        
        return NSUIColor.YCbCrComponents(luminance: Y, blue: Cb, red: Cr)
    }
    
    func toYDbDrComponents() -> NSUIColor.YDbDrComponents {
        let Y  =  0.298839 * R + 0.586811 * G + 0.114350 * B
        let Db = -0.450    * R - 0.883    * G + 1.333    * B + 0.5
        let Dr = -1.333    * R + 1.116    * G + 0.217    * B + 0.5
        
        return NSUIColor.YDbDrComponents(luminance: Y, blue: Db, red: Dr)
    }
    
    func toYPbPrComponents() -> NSUIColor.YPbPrComponents {
        let Y  =  0.298839 * R + 0.586811 * G + 0.114350 * B
        let Pb = -0.168737 * R - 0.331264 * G + 0.500000 * B + 0.5
        let Pr =  0.500000 * R - 0.418688 * G - 0.081312 * B + 0.5
        
        return NSUIColor.YPbPrComponents(luminance: Y, blue: Pb, red: Pr)
    }
    
    func toYIQComponents() -> NSUIColor.YIQComponents {
        let Y = 0.298839 * R + 0.586811 * G + 0.114350 * B
        let I = 0.595716 * R - 0.274453 * G - 0.321263 * B + 0.5
        let Q = 0.211456 * R - 0.522591 * G + 0.311135 * B + 0.5
        
        return NSUIColor.YIQComponents(brightness: Y, inPhase: I, quadraturePhase: Q)
    }
}

#endif

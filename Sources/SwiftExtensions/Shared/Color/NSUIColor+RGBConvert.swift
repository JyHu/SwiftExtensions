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
        return NSUIColor.CMYComponents(cyan: 1 - red, magenta: 1 - green, yellow: 1 - blue)
    }
    
    func toCMYKComponents() -> NSUIColor.CMYKComponents {
        let k = max(red, green, blue)
        
        if k == 1 {
            return NSUIColor.CMYKComponents(cyan: 0, magenta: 0, yellow: 0, black: 1)
        }
        
        return NSUIColor.CMYKComponents(
            cyan: (1 - red - k) / (1 - k),
            magenta: (1 - green - k) / (1 - k),
            yellow: (1 - blue - k) / (1 - k),
            black: k,
            alpha: alpha
        )
    }
    
    func toHSBComponents() -> NSUIColor.HSBComponents {
        let maxVal = max(max(red, green), blue)
        let minVal = min(min(red, green), blue)
        
        let delta = maxVal - minVal
        let V = maxVal
        
        if delta == 0 {
            return NSUIColor.HSBComponents(hue: 0, saturation: 0, brightness: V)
        }
        
        let S = delta / maxVal
        var H: CGFloat = 0
        
        if red == maxVal {
            H = (green - blue) / delta / 6
        } else if (green == maxVal) {
            H = (2 + (blue - red) / delta) / 6
        } else {
            H = (4 + (red - green) / delta) / 6
        }
        
        if H < 0 {
            H += 1
        }
        
        return NSUIColor.HSBComponents(hue: H, saturation: S, brightness: V)
    }
    
    func toHSLComponents() -> NSUIColor.HSLComponents {
        let maxVal = max(max(red, green), blue)
        let minVal = min(min(red, green), blue)
        
        let delta = maxVal - minVal
        let sumVal = maxVal + minVal
        
        let L = sumVal / 2
        
        if delta == 0 {
            return NSUIColor.HSLComponents(hue: 0, saturation: 0, lightness: L)
        }
        
        let S = delta / (sumVal < 1 ? sumVal : 2 - sumVal)
        var H: CGFloat = 0
        
        if red == maxVal {
            H = (green - blue) / delta / 6
        } else if (green == maxVal) {
            H = (2 + (blue - red) / delta) / 6
        } else {
            H = (4 + (red - green) / delta) / 6
        }
        
        if H < 0 {
            H += 1
        }
        
        return NSUIColor.HSLComponents(hue: H, saturation: S, lightness: L)
    }
    
    func toYUVComponents() -> NSUIColor.YUVComponents {
        let Y =  0.298839 * red + 0.586811 * green + 0.114350 * blue;
        let U = -0.147    * red - 0.289    * green + 0.436    * blue + 0.5;
        let V =  0.615    * red - 0.515    * green - 0.100    * blue + 0.5;
        
        return NSUIColor.YUVComponents(luma: Y, chroma1: U, chroma2: V)
    }
    
    func toYCbCrComponents() -> NSUIColor.YCbCrComponents {
        let Y  =  0.298839 * red + 0.586811 * green + 0.114350 * blue;
        let Cb = -0.168737 * red - 0.331264 * green + 0.500000 * blue + 0.5;
        let Cr =  0.500000 * red - 0.418688 * green - 0.081312 * blue + 0.5;
        
        return NSUIColor.YCbCrComponents(luminance: Y, blue: Cb, red: Cr)
    }
    
    func toYDbDrComponents() -> NSUIColor.YDbDrComponents {
        let Y  =  0.298839 * red + 0.586811 * green + 0.114350 * blue
        let Db = -0.450    * red - 0.883    * green + 1.333    * blue + 0.5
        let Dr = -1.333    * red + 1.116    * green + 0.217    * blue + 0.5
        
        return NSUIColor.YDbDrComponents(luminance: Y, blue: Db, red: Dr)
    }
    
    func toYPbPrComponents() -> NSUIColor.YPbPrComponents {
        let Y  =  0.298839 * red + 0.586811 * green + 0.114350 * blue
        let Pb = -0.168737 * red - 0.331264 * green + 0.500000 * blue + 0.5
        let Pr =  0.500000 * red - 0.418688 * green - 0.081312 * blue + 0.5
        
        return NSUIColor.YPbPrComponents(luminance: Y, blue: Pb, red: Pr)
    }
    
    func toYIQComponents() -> NSUIColor.YIQComponents {
        let Y = 0.298839 * red + 0.586811 * green + 0.114350 * blue
        let I = 0.595716 * red - 0.274453 * green - 0.321263 * blue + 0.5
        let Q = 0.211456 * red - 0.522591 * green + 0.311135 * blue + 0.5
        
        return NSUIColor.YIQComponents(brightness: Y, inPhase: I, quadraturePhase: Q)
    }
}

#endif

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
    struct YUVComponents {
        public let componentsType: NSUIColor.ComponentsType = .YUV
        
        public let luma: CGFloat
        public let chroma1: CGFloat
        public let chroma2: CGFloat
        
        public init(luma: CGFloat, chroma1: CGFloat, chroma2: CGFloat) {
            self.luma = luma
            self.chroma1 = chroma1
            self.chroma2 = chroma2
        }
    }
    
    var yuvComponents: YUVComponents {
        return rgbComponents.toYUVComponents()
    }
}

extension NSUIColor.YUVComponents: NSUIColorComponentsProtocol {
    public func prettyStringValue() -> String {
        return String(format: "YUV(%.2f, %.2f, %.2f)", luma * 100, chroma1 * 100, chroma2 * 100)
    }
    
    public func toBridgeComponents() -> NSUIColorComponentsProtocol {
        let U = chroma1 - 0.5
        let V = chroma2 - 0.5
        
        let R = luma - 3.945707070708279e-05 * U + 1.1398279671717170825 * V
        let G = luma - 0.3946101641414141437 * U - 0.5805003156565656797 * V
        let B = luma + 2.0319996843434342537 * U - 4.813762626262513e-04 * V
        
        return NSUIColor.RGBComponents(red: R, green: G, blue: B)
    }
}

#endif

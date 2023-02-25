//
//  File.swift
//  
//
//  Created by Jo on 2022/12/15.
//

#if !os(Linux)

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif


public extension NSUIColor {
    struct YIQComponents {
        public private(set) var componentsType: NSUIColor.ComponentsType = .YIQ
        
        /// Y
        public var brightness: CGFloat
        /// I
        public var inPhase: CGFloat
        /// Q
        public var quadraturePhase: CGFloat
        
        public init(brightness: CGFloat, inPhase: CGFloat, quadraturePhase: CGFloat) {
            self.brightness = brightness
            self.inPhase = inPhase
            self.quadraturePhase = quadraturePhase
        }
    }
    
    var yiqComponents: YIQComponents {
        return rgbComponents.toYIQComponents()
    }
}

extension NSUIColor.YIQComponents: NSUIColorComponentsProtocol {
    public func prettyStringValue() -> String {
        return String(format: "YIQ(%.2f, %.2f, %.2f)", brightness, inPhase, quadraturePhase)
    }
    
    public func toBridgeComponents() -> NSUIColorComponentsProtocol {
        let I = inPhase - 0.5
        let Q = quadraturePhase - 0.5
        
        let R = brightness + 0.9562957197589482261 * I + 0.6210244164652610754 * Q
        let G = brightness - 0.2721220993185104464 * I - 0.6473805968256950427 * Q
        let B = brightness - 1.1069890167364901945 * I + 1.7046149983646481374 * Q
        
        return NSUIColor.RGBComponents(R: R, G: G, B: B)
    }
}

#endif

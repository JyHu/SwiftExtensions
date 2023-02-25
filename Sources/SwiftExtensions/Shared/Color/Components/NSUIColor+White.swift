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
    struct WhiteComponents {
        /// The white component value of the color.
        public var white: CGFloat
        /// The alpha (opacity) component value of the color.
        public var alpha: CGFloat = 1
    }
    
    convenience init(whiteComponents: WhiteComponents) {
        self.init(white: whiteComponents.white, alpha: whiteComponents.alpha)
    }
    
    /// Convert the color object to White Components value.
    var whiteComponents: WhiteComponents {
        var white: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        getWhite(&white, alpha: &alpha)
        
        return WhiteComponents(white: white, alpha: alpha)
    }
}

#endif

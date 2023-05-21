//
//  File.swift
//  
//
//  Created by Jo on 2022/10/30.
//

#if canImport(Foundation)

import Foundation

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

public extension NSMutableAttributedString {
    func append(_ string: Any, attributes: [NSAttributedString.Key: Any] = [:]) {
        append(NSAttributedString(string: String(describing: string), attributes: attributes))
    }
    
#if (canImport(AppKit) && !targetEnvironment(macCatalyst)) || canImport(UIKit)
    func append(_ image: NSUIImage, offsetCreator: (() -> CGPoint)? = nil) {
        append(image.attributedString(with: offsetCreator))
    }
#endif
    
    func addAttributes(_ attributes: [Key: Any], range: NSRange? = nil) {
        addAttributes(attributes, range: range ?? NSMakeRange(0, length))
    }
    
    func addAttribute(_ attribute: Key, value: Any, range: NSRange? = nil) {
        addAttribute(attribute, value: value, range: NSMakeRange(0, length))
    }
    
//    func setAttributes(_ attributes: [Key: Any], range: NSRange? = nil) {
//
//    }
}

#endif


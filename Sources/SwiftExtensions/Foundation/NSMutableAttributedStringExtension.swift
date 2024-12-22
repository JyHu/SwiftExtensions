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
        if let string = string as? String {
            append(NSAttributedString(string: string, attributes: attributes))
        } else if let attrStr = string as? NSAttributedString {
            append(attrStr)
        }
    }
    
    func append(_ string: String, link: Any) {
        append(NSAttributedString(string: string, attributes: [.link: link]))
    }
    
#if (canImport(AppKit) && !targetEnvironment(macCatalyst)) || canImport(UIKit)
    func append(_ image: NSUIImage, offsetCreator: (() -> CGPoint)? = nil) {
        append(image.attributedString(with: offsetCreator))
    }
#endif
    
    func addAttributes(_ attributes: [Key: Any]) {
        addAttributes(attributes, range: NSMakeRange(0, length))
    }
    
    func addAttribute(_ attribute: Key, value: Any) {
        addAttribute(attribute, value: value, range: NSMakeRange(0, length))
    }
    
    func replace(tag: String, with attributedString: NSAttributedString) {
        let range = NSString(string: string).range(of: tag)
        if range.location == NSNotFound { return }
        replaceCharacters(in: range, with: attributedString)
    }
    
    func replace(tag: String, with text: String) {
        let range = NSString(string: string).range(of: tag)
        if range.location == NSNotFound { return }
        replaceCharacters(in: range, with: text)
    }
    
    func appendLineFeed() {
        append(.lineFeed)
    }
}

#endif


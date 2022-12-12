//
//  File.swift
//
//
//  Created by Jo on 2022/10/30.
//

#if !os(Linux)

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
public typealias NSUIImage = NSImage
#elseif canImport(UIKit)
import UIKit
public typealias NSUIImage = UIImage
#endif

public extension NSUIImage {
    
    /// Create a solid color image using the given property.
    /// - Parameters:
    ///   - color: The target image color.
    ///   - size: The target image size.
    convenience init(color: NSUIColor, size: CGSize) {
#if canImport(UIKit)
        let image = UIGraphicsImageRenderer(size: size).image { context in
            context.cgContext.setFillColor(color.cgColor)
            context.fill(CGRect(origin: .zero, size: size))
        }
        
        if let cgImage = image.cgImage {
            self.init(cgImage: cgImage)
        } else {
            self.init()
        }
#else
        self.init(size: size)
        lockFocus()
        color.drawSwatch(in: CGRect(origin: .zero, size: size))
        unlockFocus()
#endif
    }
    
    func imageWith(tintColor: NSUIColor) -> NSUIImage {
#if canImport(UIKit)
        guard let cgImage = cgImage else { return self }
        let rect = CGRect(origin: .zero, size: size)
        
        return UIGraphicsImageRenderer(size: size).image { context in
            context.cgContext.scaleBy(x: 1, y: -1)
            context.cgContext.translateBy(x: 0, y: -size.height)
            context.cgContext.clip(to: rect, mask: cgImage)
            context.cgContext.setFillColor(tintColor.cgColor)
            context.fill(rect)
        }
#elseif os(macOS)
        lockFocus()
        
        let bounds = CGRect(origin: .zero, size: size)
        tintColor.setFill()
        bounds.fill()
        
        draw(in: bounds, from: bounds, operation: .luminosity, fraction: 1.0)
        draw(in: bounds, from: bounds, operation: .destinationIn, fraction: 1.0)
        
        unlockFocus()
        
        return self
#else
        return self
#endif
    }
    
    /// Convert the image to NSAttributedString.
    /// - Parameter offsetCreator: The offset closure for the image.
    /// - Returns: NSAttributedString
    func attributedString(with offsetCreator: (() -> CGPoint)? = nil) -> NSAttributedString {
        return NSAttributedString(attachment: textAttachment(with: offsetCreator))
    }
}

public extension String {
    @available(macOS 11.0, iOS 13.0, *)
    var systemSymbolImage: NSUIImage? {
#if os(macOS)
        return NSImage(systemSymbolName: self, accessibilityDescription: nil)
#elseif os(iOS)
        return UIImage(systemName: self)
#else
        return nil
#endif
    }
}

#endif

//
//  File.swift
//
//
//  Created by Jo on 2022/10/29.
//

#if canImport(Foundation)

import Foundation

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

#if (canImport(AppKit) && !targetEnvironment(macCatalyst)) || canImport(UIKit)
public extension NSAttributedString {
    
    /// A typealias for a closure that calculates the offset for images inserted into an `NSAttributedString`.
    ///
    /// - Parameters:
    ///   - NSUIImage: The image being inserted into the attributed string.
    ///   - Int: The index of the image in the `sources` array.
    ///
    /// - Returns: A `CGPoint` representing the offset to apply to the image.
    ///
    /// - Usage:
    ///   You can use this closure to define custom alignment or positioning for images within the attributed string.
    ///
    /// - Example:
    ///   ```swift
    ///   let imageOffsetCreator: AttributedImageCreator = { image, index in
    ///       // Align images with a custom vertical offset based on index.
    ///       return CGPoint(x: 0, y: -CGFloat(index) * 5)
    ///   }
    ///
    ///   let attributedString = NSAttributedString(
    ///       sources: ["Text before", UIImage(named: "icon1"), "Text after"],
    ///       separator: ", ",
    ///       imageOffsetCreator: imageOffsetCreator
    ///   )
    ///   ```
    typealias AttributedImageCreator = ((NSUIImage, Int) -> CGPoint)
    
    /// Convenience initializer for creating an `NSAttributedString` from multiple sources without a separator.
    ///
    /// - Parameters:
    ///   - sources: An array of mixed content (`String`, `NSUIImage`, `NSAttributedString`, etc.) to be converted into a single `NSAttributedString`.
    ///   - attributes: A dictionary of attributes (`[Key: Any]`) to be applied to the entire resulting string.
    ///   - imageOffsetCreator: A closure that provides the offset for images within the attributed string.
    ///
    /// - Usage:
    ///   ```
    ///   let attributedString = NSAttributedString(sources: ["Hello", UIImage(named: "icon"), "World"], attributes: [.foregroundColor: UIColor.red])
    ///   ```
    ///
    /// - Returns: An optional `NSAttributedString`. If the `sources` array is empty or all elements are invalid, returns `nil`.
    convenience init?(
        sources: [Any],
        attributes: [Key: Any] = [:],
        imageOffsetCreator: AttributedImageCreator? = nil
    ) {
        // Calls another initializer, providing `nil` for the separator.
        self.init(sources: sources, separator: nil, attributes: attributes, imageOffsetCreator: imageOffsetCreator)
    }

    /// Convenience initializer for creating an `NSAttributedString` with a string separator.
    ///
    /// - Parameters:
    ///   - sources: An array of mixed content (`String`, `NSUIImage`, `NSAttributedString`, etc.).
    ///   - separator: A string separator to be inserted between each element.
    ///   - attributes: Attributes to apply to the resulting attributed string.
    ///   - imageOffsetCreator: A closure for calculating image offsets.
    ///
    /// - Usage:
    ///   ```
    ///   let attributedString = NSAttributedString(sources: ["Hello", "World"], separator: ", ")
    ///   ```
    ///
    /// - Returns: An optional `NSAttributedString`. If the `sources` array is empty or all elements are invalid, returns `nil`.
    convenience init?(
        sources: [Any],
        separator: String,
        attributes: [Key: Any] = [:],
        imageOffsetCreator: AttributedImageCreator? = nil
    ) {
        // Converts the separator string into an attributed string and calls the main initializer.
        self.init(sources: sources, separator: NSAttributedString(string: separator), attributes: attributes, imageOffsetCreator: imageOffsetCreator)
    }

    /// Main initializer for creating an `NSAttributedString` with full customization.
    ///
    /// - Parameters:
    ///   - sources: An array of mixed content to be converted into a single `NSAttributedString`. The array can include:
    ///     - `String`: Text to be included directly.
    ///     - `NSUIImage`: Images to be inserted into the attributed string.
    ///     - `NSAttributedString`: Preformatted attributed strings to be appended.
    ///     - `NSTextAttachment`: Attachments for embedding images or other content.
    ///     - `[Any]`: Nested arrays of mixed content (recursively processed).
    ///   - separator: An optional `NSAttributedString` to use as a separator between elements.
    ///   - attributes: Attributes to apply to the entire resulting string.
    ///   - imageOffsetCreator: A closure for calculating offsets for image elements. If `nil`, the default offset is `.zero`.
    ///
    /// - Usage:
    ///   ```
    ///   let attributedString = NSAttributedString(
    ///       sources: ["Hello", UIImage(named: "icon"), "World"],
    ///       separator: NSAttributedString(string: " - "),
    ///       attributes: [.font: UIFont.systemFont(ofSize: 16)]
    ///   )
    ///   ```
    ///
    /// - Returns: An optional `NSAttributedString`. If the `sources` array is empty or all elements are invalid, returns `nil`.
    convenience init?(
        sources: [Any],
        separator: NSAttributedString?,
        attributes: [Key: Any] = [:],
        imageOffsetCreator: AttributedImageCreator? = nil
    ) {
        // Guard clause: If sources are empty, return nil since there's nothing to construct.
        if sources.isEmpty {
            return nil
        }

        // Creates a mutable attributed string to build the result.
        let mutableAttributedString = NSMutableAttributedString(string: "")

        // Iterates over each element in the `sources` array.
        for (index, element) in sources.enumerated() {
            // If the index is greater than 1, append the separator between elements (if provided).
            if index > 0, let separator {
                mutableAttributedString.append(separator)
            }

            // Handles different types of elements in the `sources` array.

            // Case 1: If the element is a `String`, append it to the attributed string.
            if let string = element as? String {
                mutableAttributedString.append(string)
            }
            // Case 2: If the element is an `NSUIImage`, convert it to an attributed string with offset.
            else if let image = element as? NSUIImage {
                mutableAttributedString.append(image) {
                    // Use the `imageOffsetCreator` closure if available, otherwise set offset to `.zero`.
                    imageOffsetCreator?(image, index) ?? .zero
                }
            }
            // Case 3: If the element is already an `NSAttributedString`, append it directly.
            else if let attributedString = element as? NSAttributedString {
                mutableAttributedString.append(attributedString)
            }
            // Case 4: If the element is an `NSTextAttachment`, convert it to an attributed string and append.
            else if let attachment = element as? NSTextAttachment {
                mutableAttributedString.append(NSAttributedString(attachment: attachment))
            }
            // Case 5: If the element is a nested array, recursively create an attributed string and append.
            else if let subSources = element as? [Any], subSources.count > 0 {
                if let subAttributedString = NSAttributedString(
                    sources: subSources,
                    separator: separator,
                    attributes: attributes,
                    imageOffsetCreator: imageOffsetCreator
                ) {
                    mutableAttributedString.append(subAttributedString)
                }
            }
            // Case 6: Fallback for unsupported types, convert to string and append.
            else {
                mutableAttributedString.append("\(element)")
            }
        }

        // If the resulting attributed string is empty, return nil.
        if mutableAttributedString.length == 0 {
            return nil
        }

        // Apply additional attributes to the entire attributed string, if any are provided.
        if !attributes.isEmpty {
            mutableAttributedString.addAttributes(attributes)
        }

        // Initialize with the constructed attributed string.
        self.init(attributedString: mutableAttributedString)
    }
    
    /// 对当前富文本内容添加下划线
    func applyingUnderline(style: NSUnderlineStyle, color: NSUIColor? = nil, range: NSRange? = nil) -> NSAttributedString {
        let mutableAttributedString = {
            if let target = self as? NSMutableAttributedString { return target }
            return NSMutableAttributedString(attributedString: self)
        }()
        
        if let color = color {
            return mutableAttributedString.applying(attributes: [
                .underlineColor: color,
                .underlineStyle: style.rawValue,
            ], range: range)
        } else {
            return mutableAttributedString.applying(attributes: [
                .underlineStyle: style.rawValue,
            ], range: range)
        }
    }
}
#endif

public extension NSAttributedString {
    class var lineFeed: Self {
        return self.init(string: "\n")
    }
    
    class var empty: Self {
        return self.init(string: "")
    }
}

public extension NSAttributedString {
    func applying(attributes: [Key: Any], range: NSRange? = nil) -> NSAttributedString {
        let mutableAttributedString = {
            if let target = self as? NSMutableAttributedString { return target }
            return NSMutableAttributedString(attributedString: self)
        }()
        
        mutableAttributedString.addAttributes(attributes, range: range ?? NSMakeRange(0, length))
        return mutableAttributedString
    }
}

public extension NSAttributedString {
    static func += (lhs: inout NSAttributedString, rhs: NSAttributedString) {
        let mutableAttributedString = {
            if let target = lhs as? NSMutableAttributedString { return target }
            return NSMutableAttributedString(attributedString: lhs)
        }()
        mutableAttributedString.append(rhs)
        lhs = mutableAttributedString
    }
    
    static func += (lhs: inout NSAttributedString, rhs: String) {
        lhs += NSAttributedString(string: rhs)
    }
    
    static func + (lhs: NSAttributedString, rhs: NSAttributedString) -> NSMutableAttributedString {
        let mutableAttributedString = {
            if let target = lhs as? NSMutableAttributedString { return target }
            return NSMutableAttributedString(attributedString: lhs)
        }()
        mutableAttributedString.append(rhs)
        return mutableAttributedString
    }
    
    static func + (lhs: NSAttributedString, rhs: String) -> NSMutableAttributedString {
        return lhs + NSAttributedString(string: rhs)
    }
    
    func appending(_ string: String?, attributes: [NSAttributedString.Key: Any] = [:]) -> Self {
        guard let string, !string.isEmpty else { return self }
        return appending(NSAttributedString(string: string, attributes: attributes))
    }
    
    func appending(_ attributedString: NSAttributedString) -> Self {
        func getMutableAttributedString() -> NSMutableAttributedString {
            if let mutable = self as? NSMutableAttributedString {
                return mutable
            }
            return NSMutableAttributedString(attributedString: self)
        }
        
        let mutableAttributedString = getMutableAttributedString()
        mutableAttributedString.append(attributedString)
        return mutableAttributedString as! Self
    }
}

#endif

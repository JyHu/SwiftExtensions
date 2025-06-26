//
//  AttributedString+.swift
//  SwiftExtensions
//
//  Created by hujinyou on 2025/5/29.
//

import Foundation

@available(macOS 12, iOS 15, *)
public extension AttributedString {
    
    /// Converts a `Range<String.Index>` from a source `String` into a `Range<AttributedString.Index>` for this `AttributedString` instance.
    ///
    /// This is particularly useful when you have already found a substring range in a `String`, and you want to apply attributes
    /// to that same range in an `AttributedString` created from the same content.
    ///
    /// - Parameter range: A `Range<String.Index>` from the original source `String`.
    /// - Returns: An optional `Range<AttributedString.Index>` that corresponds to the same characters, or `nil` if conversion fails.
    ///
    /// ### Example:
    /// ```swift
    /// let base = "Hello, Swift World!"
    /// let attrString = AttributedString(base)
    /// if let stringRange = base.range(of: "Swift"),
    ///    let attrRange = attrString.range(from: stringRange) {
    ///     var mutableAttr = attrString
    ///     mutableAttr[attrRange].foregroundColor = .red
    ///     print(mutableAttr)  // "Swift" part is red
    /// }
    /// ```
    func range(from range: Range<String.Index>) -> Range<AttributedString.Index>? {
        guard let lower = AttributedString.Index(range.lowerBound, within: self),
              let upper = AttributedString.Index(range.upperBound, within: self) else {
            return nil
        }
        
        return lower..<upper
    }
    
    /// Creates an `AttributedString` from a plain `String` and a dictionary of `NSAttributedString.Key` attributes.
    ///
    /// This initializer bridges traditional `NSAttributedString` styling into the modern `AttributedString` API.
    ///
    /// - Parameters:
    ///   - string: The base string content.
    ///   - attributes: A dictionary of `NSAttributedString.Key: Any` to apply as base attributes.
    ///
    /// ### Example:
    /// ```swift
    /// let font = NSFont.systemFont(ofSize: 14, weight: .bold)
    /// let color = NSColor.systemBlue
    /// let attrs: [NSAttributedString.Key: Any] = [
    ///     .font: font,
    ///     .foregroundColor: color
    /// ]
    /// let attributed = AttributedString("Hello, styled world!", attributes: attrs)
    /// print(attributed)  // Entire string has blue, bold font
    /// ```
    init(_ string: String, attributes: [NSAttributedString.Key: Any]) {
        self.init(string, attributes: AttributeContainer(attributes))
    }
    
    /// Initializes an `AttributedString` from a Markdown string.
    ///
    /// - Parameters:
    ///   - source: The input Markdown string.
    ///
    /// ### Example:
    /// ```swift
    /// let str = AttributedString(markdown: "**Bold** and *italic* text")!
    /// print(str)
    /// ```
    init?(markdown source: String) {
        try? self.init(markdown: source, options: .init(interpretedSyntax: .inlineOnlyPreservingWhitespace), baseURL: nil)
    }
    
    /// Returns a new `AttributedString` by applying specified attributes to all occurrences of a target substring.
    ///
    /// - Parameters:
    ///   - target: The substring to search for.
    ///   - attributes: The attributes to apply to matched ranges.
    ///   - options: String comparison options (e.g., case-insensitive). Default is `[.caseInsensitive]`.
    ///
    /// - Returns: A new `AttributedString` with modified attributes.
    ///
    /// ### Example:
    /// ```swift
    /// var str = AttributedString("Swift is great. I love Swift.")
    /// let styled = str.applyingAttributes(
    ///     toOccurrencesOf: "Swift",
    ///     attributes: [.foregroundColor: .red, .font: Font.title]
    /// )
    /// print(styled)
    /// ```
    func applyingAttributes(toOccurrencesOf target: String,
                            attributes: AttributeContainer,
                            options: String.CompareOptions = [.caseInsensitive]) -> AttributedString {
        var result = self
        let plain = String(self.characters)
        
        plain.enumerate(target, options: options) { range in
            if let attrRange = result.range(from: range) {
                result[attrRange].mergeAttributes(attributes)
            }
        }
        
        return result
    }
}

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
public extension Array where Element == AttributedString {
    func componentsJoined(_ separator: String) -> AttributedString? {
        componentsJoined(AttributedString(separator))
    }
    
    func componentsJoined(_ separator: AttributedString) -> AttributedString? {
        if count == 0 {
            return nil
        }
        
        if count == 1 {
            return first
        }
        
        var index = 1
        var result = self[0]
        
        while index < count {
            result += separator
            result += self[index]
            index += 1
        }
        
        return result
    }
}

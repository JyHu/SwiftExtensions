//
//  File.swift
//  
//
//  Created by Jo on 2022/10/29.
//

#if canImport(Foundation)

import Foundation

public extension String {
    /// A computed property that returns the localized version of the string.
    /// Uses the string as both the key and the comment for localization.
    /// - Returns: The localized string.
    var localized: String {
        NSLocalizedString(self, comment: self)
    }
    
    /// Localizes the string with an optional table name, bundle, and default value.
    /// - Parameters:
    ///   - tableName: The name of the strings table to use. Defaults to nil, which uses the default table.
    ///   - bundle: The bundle where the localization files are stored. Defaults to the main bundle.
    ///   - value: A default value to return if the localized string is not found. Defaults to an empty string.
    /// - Returns: The localized string.
    func localized(withTableName tableName: String? = nil, bundle: Bundle = Bundle.main, value: String = "") -> String {
        NSLocalizedString(self, tableName: tableName, bundle: bundle, value: value, comment: self)
    }
}

#endif

public extension String {
    
    /// Allows subscripting with a `CountableClosedRange<Int>` to extract a substring.
    /// - Parameter bounds: A closed range of integers specifying the range of characters to extract, inclusive of the upper bound.
    /// - Returns: A substring within the specified range if it is valid; otherwise, `nil`.
    ///
    /// Example:
    /// ```swift
    /// let string = "Hello, World!"
    /// let substring = string[0...4] // "Hello"
    /// ```
    subscript (bounds: CountableClosedRange<Int>) -> String? {
        guard bounds.lowerBound >= 0 && bounds.upperBound < count else { return nil }
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start...end])
    }
    
    /// Allows subscripting with a `CountableRange<Int>` to extract a substring.
    /// - Parameter bounds: A range of integers specifying the range of characters to extract, exclusive of the upper bound.
    /// - Returns: A substring within the specified range if it is valid; otherwise, `nil`.
    ///
    /// Example:
    /// ```swift
    /// let string = "Hello, World!"
    /// let substring = string[0..<5] // "Hello"
    /// ```
    subscript (bounds: CountableRange<Int>) -> String? {
        guard bounds.lowerBound >= 0 && bounds.upperBound <= count else { return nil }
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start..<end])
    }
    
    /// Allows subscripting with a `PartialRangeUpTo<Int>` to extract a substring.
    /// - Parameter bounds: A range up to a specific integer, exclusive of the upper bound.
    /// - Returns: A substring up to the specified index if valid; otherwise, `nil`.
    ///
    /// Example:
    /// ```swift
    /// let string = "Hello, World!"
    /// let substring = string[..<5] // "Hello"
    /// ```
    subscript (bounds: PartialRangeUpTo<Int>) -> String? {
        guard bounds.upperBound <= count else { return nil }
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[startIndex..<end])
    }
    
    /// Allows subscripting with a `PartialRangeThrough<Int>` to extract a substring.
    /// - Parameter bounds: A range through a specific integer, inclusive of the upper bound.
    /// - Returns: A substring through the specified index if valid; otherwise, `nil`.
    ///
    /// Example:
    /// ```swift
    /// let string = "Hello, World!"
    /// let substring = string[...5] // "Hello,"
    /// ```
    subscript (bounds: PartialRangeThrough<Int>) -> String? {
        guard bounds.upperBound < count else { return nil }
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[startIndex...end])
    }
    
    /// Allows subscripting with a `CountablePartialRangeFrom<Int>` to extract a substring.
    /// - Parameter bounds: A range starting at a specific integer to the end of the string.
    /// - Returns: A substring starting at the specified index to the end of the string if valid; otherwise, `nil`.
    ///
    /// Example:
    /// ```swift
    /// let string = "Hello, World!"
    /// let substring = string[5...] // " World!"
    /// ```
    subscript (bounds: CountablePartialRangeFrom<Int>) -> String? {
        guard bounds.lowerBound >= 0 && bounds.lowerBound < count else { return nil }
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        return String(self[start..<endIndex])
    }
    
    /// Allows subscripting with an `NSRange` to extract a substring.
    /// - Parameter nsrange: An `NSRange` specifying the range to extract.
    /// - Returns: A substring within the specified `NSRange` if valid; otherwise, `nil`.
    ///
    /// Example:
    /// ```swift
    /// let string = "Hello, World!"
    /// let nsrange = NSRange(location: 7, length: 5)
    /// let substring = string[nsrange] // "World"
    /// ```
    subscript (nsrange: NSRange) -> String? {
        if nsrange.location == NSNotFound ||
            nsrange.location < 0 || nsrange.length < 0 ||
            nsrange.location + nsrange.length > count {
            return nil
        }
        
        let start = index(startIndex, offsetBy: nsrange.location)
        let end = index(start, offsetBy: nsrange.length)
        return String(self[start ..< end])
    }
    
    /// Extracts a substring from a given index to the end of the string.
    /// - Parameter index: The index from which the substring will start.
    /// - Returns: A substring starting from the specified index, or `nil` if the index is out of bounds.
    ///
    /// Example:
    /// ```swift
    /// let string = "Hello, World!"
    /// let substring = string.subString(from: 7) // "World!"
    /// ```
    func subString(from index: Int) -> String? {
        return self[index...]
    }
    
    /// Extracts a substring from the start of the string to the given index.
    /// - Parameter index: The index where the substring will end.
    /// - Returns: A substring up to the specified index, or `nil` if the index is out of bounds.
    ///
    /// Example:
    /// ```swift
    /// let string = "Hello, World!"
    /// let substring = string.subString(to: 5) // "Hello"
    /// ```
    func subString(to index: Int) -> String? {
        return self[...index]
    }
    
    /// Extracts a substring that matches a given regular expression pattern.
    /// - Parameter pattern: A regular expression pattern used to search the string.
    /// - Returns: A substring that matches the pattern, or `nil` if no match is found.
    ///
    /// Example:
    /// ```swift
    /// let string = "The quick brown fox jumps over the lazy dog"
    /// let substring = string.subStringWith(pattern: "quick\\s+\\w+") // "quick brown"
    /// ```
    func subStringWith(pattern: String) -> String? {
        guard let range = range(of: pattern, options: .regularExpression) else {
            return nil
        }
        
        return String(self[range])
    }
    
    /// Gets the character value of the string at the given index.
    /// - Parameter index: The index of the character to retrieve.
    /// - Returns: The character at the specified index, or `nil` if the index is out of bounds.
    ///
    /// Example:
    /// ```swift
    /// let string = "Hello"
    /// let character = string.char(at: 1) // "e"
    /// ```
    func char(at index: Int) -> Character? {
        if index >= count { return nil }
        return self[self.index(startIndex, offsetBy: index)]
    }
    
    /// Finds all occurrences of a given substring in the current string, returning an array of NSRange.
    /// - Parameters:
    ///   - string: The string to search for.
    ///   - options: Search options (e.g., `.regularExpression`). Defaults to an empty array for literal search.
    /// - Returns: An array of `NSRange` objects representing all the matches of the substring.
    ///
    /// Example:
    /// ```swift
    /// let string = "The quick brown fox jumps over the quick lazy dog"
    /// let ranges = string.nsranges(of: "quick") // [NSRange(location: 4, length: 5), NSRange(location: 32, length: 5)]
    /// ```
    func nsranges(of string: String, options: NSString.CompareOptions = []) -> [NSRange] {
        if options == .regularExpression {
            return textCheckingResults(with: string).map { $0.range }
        }
        
        let nsstring = NSString(string: self)
        
        func nextRange(from beginIndex: Int, result: [NSRange]) -> [NSRange] {
            if beginIndex >= count {
                return result
            }
            
            let range = nsstring.range(of: string, options: options, range: NSRange(location: beginIndex, length: count - beginIndex))
            
            if range.location == NSNotFound {
                return result
            }
            
            return nextRange(from: range.location + range.length, result: result + [range])
        }
        
        return nextRange(from: 0, result: [])
    }
    
    /// Finds the position of a given substring in the current string.
    /// - Parameters:
    ///   - subString: The substring to search for.
    ///   - backwards: Whether to search backwards, defaults to `false` (searches from the start).
    /// - Returns: The index of the first occurrence of the substring or `-1` if not found.
    ///
    /// Example:
    /// ```swift
    /// let string = "Hello, World!"
    /// let position = string.position(of: "World") // 7
    /// let backwardsPosition = string.position(of: "o", backwards: true) // 8
    /// ```
    func position(of subString: String, backwards: Bool = false) -> Int {
        // If not found, return -1
        if let range = range(of: subString, options: backwards ? .backwards : .literal) {
            if !range.isEmpty {
                return distance(from: startIndex, to: range.lowerBound)
            }
        }
        return -1
    }
    
    /// Calculates the indent length from the start of the paragraph to the selected range in the string.
    /// - Parameter selectedRange: The range of the selected content.
    /// - Returns: The number of characters representing the indent length.
    ///
    /// Example:
    /// ```swift
    /// let string = "   This is a paragraph."
    /// let selectedRange = string.range(of: "paragraph")!
    /// let indentLength = string.paraghIndentLength(to: selectedRange) // 3
    /// ```
    func paraghIndentLength(to selectedRange: Range<String.Index>) -> Int {
        // Find the start of the selection
        let startOfSelection = selectedRange.lowerBound
        
        // Find the start of the paragraph
        var startOfParagraph = startOfSelection
        if startOfParagraph > self.startIndex && self[startOfParagraph] == "\n" {
            startOfParagraph = self.index(before: startOfParagraph)
        }
        
        while startOfParagraph > self.startIndex && self[startOfParagraph] != "\n" {
            startOfParagraph = self.index(before: startOfParagraph)
        }
        
        // Calculate the distance from the start of the paragraph to the start of the selection, which is the indent length
        let indentLength = self.distance(from: startOfParagraph, to: startOfSelection)
        
        if indentLength == 0 {
            return 0
        }
        return indentLength - 1
    }
    
    /// Enumerates all non-overlapping ranges of a given substring within the string.
    ///
    /// - Parameters:
    ///   - string: The substring to search for.
    ///   - options: A set of options to use when comparing the substring. Defaults to an empty set (i.e., case-sensitive, literal search).
    ///   - handler: A closure that is called for each matching range. The range is relative to the base string.
    ///
    /// This method searches for all occurrences of the specified `string` within the base string, starting from the beginning
    /// and moving forward, calling the `handler` with each `Range<String.Index>` where a match was found. The search is **non-overlapping**,
    /// meaning that if a match is found, the next search starts after that match.
    ///
    /// - Note:
    ///   - If `string` is empty, this method performs no search and the handler will not be called.
    ///   - The `options` parameter allows for case-insensitive, backwards, anchored, or literal searches (among others).
    ///
    /// ### Example Usage:
    ///
    /// ```swift
    /// let sentence = "This is a test. This is only a test."
    /// sentence.enumerate("test") { range in
    ///     print("Found match at range: \(range), substring: '\(sentence[range])'")
    /// }
    /// // Output:
    /// // Found match at range: Range(10..<14), substring: 'test'
    /// // Found match at range: Range(31..<35), substring: 'test'
    /// ```
    ///
    /// Case-insensitive search:
    ///
    /// ```swift
    /// let sentence = "Hello world. hello Swift."
    /// sentence.enumerate("hello", options: [.caseInsensitive]) { range in
    ///     print("Found '\(sentence[range])' at \(range)")
    /// }
    /// // Output:
    /// // Found 'Hello' at Range(0..<5)
    /// // Found 'hello' at Range(13..<18)
    /// ```
    @discardableResult
    func enumerate(_ string: String, options: String.CompareOptions = [], handler: (Range<String.Index>) -> Void) -> Int {
        var index = startIndex
        var matches: Int = 0
        
        while index < endIndex {
            let findRange = index..<endIndex
            
            guard let range = self.range(of: string, options: options, range: findRange) else {
                return matches
            }
            
            handler(range)
            index = range.upperBound
            matches += 1
        }
        
        return matches
    }
}

public extension String {
    /// Finds all text checking results that match the given regular expression pattern.
    /// - Parameter pattern: The regular expression pattern to match against.
    /// - Returns: An array of NSTextCheckingResult objects, or an empty array if no matches are found.
    func textCheckingResults(with pattern: String) -> [NSTextCheckingResult] {
        return (try? NSRegularExpression(pattern: pattern, options: .caseInsensitive))?.matches(in: self) ?? []
    }
    
    /// Replaces occurrences of a specified string with another string.
    /// - Parameters:
    ///   - string: The string to be replaced.
    ///   - target: The string to replace the occurrences with.
    ///   - options: The options for the replacement, defaults to case-insensitive comparison.
    ///   - range: The range within which the replacement should occur. If nil, the entire string is considered.
    /// - Returns: The new string with the replacements.
    func replacing(_ string: String, target: String, options: NSString.CompareOptions = .caseInsensitive, range: Range<Index>? = nil) -> String {
        return replacingOccurrences(of: string, with: target, options: options, range: range)
    }
    
    private static let desensitizationReg = try? NSRegularExpression(pattern: "[\\.\\\\\\^\\$\\*\\+\\?\\[\\]\\{\\}\\(\\)\\|]", options: .caseInsensitive)
    
    /// Applies regex desensitization to escape special characters in the string.
    /// - Returns: A new string with special regex characters escaped, making it safe for use in regex patterns.
    var regexDesensitization: String {
        if let reg = String.desensitizationReg {
            return reg.stringByReplacingMatches(in: self, options: .reportCompletion, range: NSRange(location: 0, length: count), withTemplate: "\\\\$0")
        }
        
        return self
    }
}

public extension String {
    
    /// Returns a relative path by removing the given base path from the current string.
    /// - Parameters:
    ///   - path: The base path to be simplified.
    ///   - relativePath: The path to replace the base path with (default is an empty string).
    /// - Returns: The relative path string, or the original string if the base path isn't found.
    ///
    /// Example:
    /// ```swift
    /// let path = "A/B/C/D"
    /// let basePath = "A/B"
    /// let relativePath = path.relate(to: basePath) // "C/D"
    /// ```
    func relate(to path: String?, relativePath: String = "") -> String {
        guard let path = path else {
            return self
        }
        
        guard let range = range(of: path) else {
            return self
        }
        
        if range.lowerBound == startIndex {
            let target = replacingCharacters(in: range, with: relativePath)
            
            if relativePath.isEmpty {
                if target.hasPrefix("/") {
                    return target
                } else {
                    return "/" + target
                }
            } else {
                return target
            }
        }
        
        return self
    }
    
    /// Returns the last component of the path (after the last "/").
    /// - Returns: The last path component as a string, or `nil` if no path separator exists.
    ///
    /// Example:
    /// ```swift
    /// let path = "A/B/C/D"
    /// let lastPathComponent = path.lastPathComponent // "D"
    /// ```
    var lastPathComponent: String? {
        guard let range = range(of: "/", options: .backwards) else {
            return nil
        }
        
        return String(self[index(after: range.lowerBound) ..< index(startIndex, offsetBy: count)])
    }
    
    /// Returns the file extension of the current path string (everything after the last ".").
    /// - Returns: The file extension as a string, or `nil` if no extension exists.
    ///
    /// Example:
    /// ```swift
    /// let path = "file.txt"
    /// let extension = path.pathExtension // "txt"
    /// ```
    var pathExtension: String? {
        guard let range = range(of: ".", options: .backwards) else {
            return nil
        }
        
        return String(self[index(after: range.lowerBound) ..< index(startIndex, offsetBy: count)])
    }
    
    /// Appends a given file path or address to the current string, ensuring proper formatting.
    /// - Parameter pathComponent: The file name or address to append.
    /// - Returns: The resulting string with the appended path component.
    ///
    /// Example:
    /// ```swift
    /// let path = "/A/B"
    /// let newPath = path.stringByAppending(pathComponent: "C/D") // "/A/B/C/D"
    /// ```
    func stringByAppending(pathComponent: String) -> String {
        if hasSuffix("/") {
            if pathComponent.hasPrefix("/") {
                return self + String(pathComponent.dropFirst())
            }
            
            return self + pathComponent
        } else {
            if pathComponent.hasPrefix("/") {
                return self + pathComponent
            }
            
            return self + "/" + pathComponent
        }
    }
    
    /// Replaces occurrences of a given keyword with a replacement string, up to a specified maximum number of replacements.
    /// - Parameters:
    ///   - keyword: The string to replace.
    ///   - replacement: The string to replace the keyword with.
    ///   - options: Compare options for the replacement (default is empty).
    ///   - maxReplacements: The maximum number of replacements to make.
    /// - Returns: A new string with the replacements applied.
    ///
    /// Example:
    /// ```swift
    /// let string = "Hello, World! World!"
    /// let newString = string.replacingOccurrences(of: "World", with: "Universe", maxReplacements: 1) // "Hello, Universe! World!"
    /// ```
    func replacingOccurrences(of keyword: String, with replacement: String, options: CompareOptions = [], maxReplacements: Int) -> String {
        var count = 0
        var result = self
        
        while let range = result.range(of: keyword, options: options) {
            result = result.replacingCharacters(in: range, with: replacement)
            count += 1
            
            if count == maxReplacements {
                return result
            }
        }
        
        return result
    }
    
    /// Appends a given path component to the current string, modifying it in-place.
    /// - Parameter pathComponent: The file name or address to append.
    mutating func append(pathComponent: String) {
        if hasSuffix("/") {
            if pathComponent.hasPrefix("/") {
                self.append(String(pathComponent.dropFirst()))
            } else {
                self.append(pathComponent)
            }
        } else {
            if pathComponent.hasPrefix("/") {
                self.append(pathComponent)
            } else {
                self.append("/" + pathComponent)
            }
        }
    }
    
    /// Trims any leading or trailing whitespace and newline characters from the string.
    /// - Returns: A new string with leading and trailing whitespace removed.
    ///
    /// Example:
    /// ```swift
    /// let string = "  Hello, World!  "
    /// let trimmedString = string.trimming // "Hello, World!"
    /// ```
    var trimming: String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    /// Returns the range of the entire string.
    /// - Returns: The range representing the entire string.
    var rangeValue: Range<String.Index> {
        return startIndex ..< index(startIndex, offsetBy: count)
    }
    
    /// Converts a Swift `Range` to an Objective-C `NSRange` for interoperability.
    /// - Parameter range: The Swift `Range` to convert.
    /// - Returns: The corresponding `NSRange` object.
    ///
    /// Example:
    /// ```swift
    /// let range = "Hello".rangeValue
    /// let nsRange = "Hello".nsRangeValue(from: range) // NSRange(location: 0, length: 5)
    /// ```
    func nsRangeValue(from range: Range<String.Index>) -> NSRange {
        return NSRange(range, in: self)
    }
    
    /// Converts an Objective-C `NSRange` to a Swift `Range<String.Index>`.
    /// - Parameter nsrange: The `NSRange` to convert.
    /// - Returns: The corresponding Swift `Range` object, or `nil` if the conversion fails.
    func rangeValue(from nsrange: NSRange) -> Range<String.Index>? {
        return Range<String.Index>(nsrange, in: self)
    }
    
    /// Returns the word count of the current string by matching word-like characters.
    /// - Returns: The total number of words in the string.
    ///
    /// Example:
    /// ```swift
    /// let string = "Hello, World!"
    /// let wordCount = string.wordCount // 2
    /// ```
    var wordCount: Int {
        guard let regex = try? NSRegularExpression(pattern: "\\w+") else { return 0 }
        return regex.numberOfMatches(in: self, range: NSMakeRange(0, count))
    }
    
    /// Converts the string to a URL if it is a valid URL format.
    /// - Returns: A `URL` object if the string can be converted, otherwise `nil`.
    var asURL: URL? { URL(string: self) }
}

public extension String {
    /// Checks if the string matches a given regular expression pattern.
    /// - Parameter pattern: The regular expression pattern to match the string against.
    /// - Returns: A Boolean value indicating whether the string matches the pattern.
    func isLegal(with pattern: String) -> Bool {
        return NSPredicate(format: "SELF MATCHES %@", pattern).evaluate(with: self)
    }
    
    /// Checks if the string is a valid URL.
    /// - Returns: A Boolean value indicating whether the string is a valid URL.
    var isLegalURL: Bool {
        return isLegal(with: "(https://|http://)?([\\w-]+\\.)+[\\w-]+(/[\\w- ./?%&=]*)?")
    }
    
    /// Checks if the string is a valid phone number.
    /// - Returns: A Boolean value indicating whether the string is a valid phone number.
    var isLegalPhoneNumber: Bool {
        return isLegal(with: "^1[0-9]{10}$")
    }
    
    /// Checks if the string is a valid integer.
    /// - Returns: A Boolean value indicating whether the string is a valid integer.
    var isLegalPureIntNumber: Bool {
        return isLegal(with: "^\\d+$")
    }
    
    /// Checks if the string is a valid number (integer or decimal).
    /// - Returns: A Boolean value indicating whether the string is a valid number.
    var isLegalNumber: Bool {
        return isLegal(with: "^-?\\d+(\\.\\d+)?$")
    }
}

public extension String {
    /// Converts a regular string into UTF-8 encoded binary data.
    /// - Parameter allowLossyConversion: A Boolean value that determines whether to allow loss of data during conversion (default is `false`).
    /// - Returns: The UTF-8 encoded data, or `nil` if the conversion fails.
    func toUTF8Data(allowLossyConversion: Bool = false) -> Data? {
        return data(using: .utf8, allowLossyConversion: allowLossyConversion)
    }
    
    /// Converts a Base64 encoded string into binary data.
    /// - Parameter options: The options for decoding the Base64 string (default is an empty set).
    /// - Returns: The decoded binary data, or `nil` if the conversion fails.
    func base64StringToData(options: Data.Base64DecodingOptions = []) -> Data? {
        return Data(base64Encoded: self, options: options)
    }
    
    /// Converts a Base64 encoded string into a regular string.
    /// - Parameter options: The options for decoding the Base64 string (default is an empty set).
    /// - Parameter encoding: The encoding used for the resulting string (default is `.utf8`).
    /// - Returns: The decoded string, or `nil` if the conversion fails.
    func base64StringToString(options: Data.Base64DecodingOptions = [], encoding: String.Encoding = .utf8) -> String? {
        guard let data = base64StringToData(options: options) else { return nil }
        return String(data: data, encoding: encoding)
    }
    
    /// Converts a regular string into a Base64 encoded binary string.
    /// - Parameter options: The options for encoding the Base64 string (default is an empty set).
    /// - Returns: The Base64 encoded string, or `nil` if the conversion fails.
    func toBase64String(options: Data.Base64EncodingOptions = []) -> String? {
        return data(using: .utf8)?.base64EncodedString(options: options)
    }
    
    /// Converts a regular string into a Base64 encoded binary data.
    /// - Parameter encodingOptions: The options for encoding the Base64 string (default is an empty set).
    /// - Parameter decodingOptions: The options for decoding the Base64 string (default is an empty set).
    /// - Returns: The decoded binary data, or `nil` if the conversion fails.
    func toBase64Data(encodingOptions: Data.Base64EncodingOptions = [], decodingOptions: Data.Base64DecodingOptions = []) -> Data? {
        return toBase64String(options: encodingOptions)?.base64StringToData(options: decodingOptions)
    }
    
    /// Converts a string of hexadecimal characters into binary data.
    /// - Returns: The binary data, or `nil` if the string cannot be converted (e.g., invalid format).
    func toHexData() -> Data? {
        if count % 2 != 0 { return nil }
        
        var bytes: [UInt8] = []
        var sum: Int = 0
        
        let intRange = 48...57
        let lowerCaseRange = 97...102
        let upperCaseRange = 65...70
        
        for (index, c) in self.utf8CString.enumerated() {
            var intc = Int(c.byteSwapped)
            
            if intc == 0 { break }
            if intRange.contains(intc) {
                intc -= 48
            } else if lowerCaseRange.contains(intc) {
                intc -= 87
            } else if upperCaseRange.contains(intc) {
                intc -= 55
            } else {
                assertionFailure("Input string format is incorrect")
            }
            
            sum = sum * 16 + intc
            if index % 2 != 0 {
                bytes.append(UInt8(sum))
                sum = 0
            }
        }
        
        return Data(bytes: bytes, count: bytes.count)
    }
}

public extension String {
    /// Adds custom attributes to the string and returns an attributed string.
    /// - Parameter attributes: A dictionary containing the attributes to be applied to the string. These can include styles like font, color, links, etc.
    /// - Returns: An NSMutableAttributedString object with the applied attributes.
    ///
    /// Example:
    /// ```swift
    /// let string = "Hello, World!"
    /// let attributes: [NSAttributedString.Key: Any] = [
    ///     .foregroundColor: UIColor.red,
    ///     .font: UIFont.boldSystemFont(ofSize: 18)
    /// ]
    /// let attributedString = string.attributed(attributes)
    /// ```
    func attributed(_ attributes: [NSAttributedString.Key: Any] = [:]) -> NSMutableAttributedString {
        if attributes.isEmpty {
            return NSMutableAttributedString(string: self)
        }

        return NSMutableAttributedString(string: self, attributes: attributes)
    }
    
    /// Converts the string to a hyperlink with custom attributes.
    /// - Parameter link: The URL or any object representing the link. This can be a string or URL object.
    /// - Parameter attributes: A dictionary of attributes to apply to the hyperlink, such as font, color, etc.
    /// - Returns: An NSMutableAttributedString object with the link and applied attributes.
    ///
    /// Example:
    /// ```swift
    /// let string = "Click Here"
    /// let link = "https://www.example.com"
    /// let hyperlink = string.hypertextLinkTo(link, attributes: [
    ///     .foregroundColor: UIColor.blue,
    ///     .underlineStyle: NSUnderlineStyle.single.rawValue
    /// ])
    /// ```
    func hypertextLinkTo(_ link: Any, attributes: [NSAttributedString.Key: Any] = [:]) -> NSMutableAttributedString {
        if attributes.count == 0 {
            return attributed([.link: link])
        }
        
        var attributes = attributes
        attributes[.link] = link
        return attributed(attributes)
    }
}

public extension String {
    
    /// Converts the string to an unsafe raw pointer format, which can be used in Objective-C association.
    /// - Returns: An `UnsafeRawPointer` representing the raw pointer to the C string.
    ///
    /// Example:
    /// ```swift
    /// let myString = "Hello, World!"
    /// let pointer = myString.unsafePointer
    /// ```
    var unsafePointer: UnsafeRawPointer {
        return withCString { cString in
            return UnsafeRawPointer(cString)
        }
    }
}

public extension NSRange {
    
    /// Converts an `NSRange` into a `Range<String.Index>` for a specific string.
    /// This helps when working with ranges in Swift string types, which use `String.Index`.
    /// - Parameter string: The string in which the range should be interpreted.
    /// - Returns: An optional `Range<String.Index>` that represents the same range in the given string.
    ///
    /// Example:
    /// ```swift
    /// let string = "Hello, World!"
    /// let nsRange = NSRange(location: 0, length: 5)
    /// if let range = nsRange.range(in: string) {
    ///     let substring = string[range]
    /// }
    /// ```
    func range(in string: String) -> Range<String.Index>? {
        return Range<String.Index>(self, in: string)
    }
}

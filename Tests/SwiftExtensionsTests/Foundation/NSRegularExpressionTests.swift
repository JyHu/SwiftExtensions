//
//  NSRegularExpressionTests.swift
//  
//
//  Created by Jo on 2022/11/2.
//

import XCTest
import SwiftExtensions

final class NSRegularExpressionTests: XCTestCase {
    func testExample() throws {
        let html =
            """
            <html>
                <head>
                    <title>this is test</title>
                </head>
                <body>
                    <a href="https://itiger.com">itiger</a>
                </body>
            </html>
            """
        
        let reg = try? NSRegularExpression(pattern: "<\\w+>")
        XCTAssertNotNil(reg)
        
        let firstRange = reg?.firstMatch(in: html)
        XCTAssertNotNil(firstRange)
        XCTAssertTrue(NSEqualRanges(firstRange!.range, NSRange(location: 0, length: 6)))
        
        XCTAssertTrue(reg!.matches(in: html).count == 4)
        
        let groupedResults: [[String]] = [["<html>"], ["<head>"], ["<title>"], ["<body>"]]
        XCTAssertEqual(reg!.groupedResults(in: html), groupedResults)
        
        var enumeratedResults: [String] = []
        reg!.enumerateMatches(in: html) { result, flags, stop in
            guard let range = result?.range, let text = html[range] else {
                return
            }
            enumeratedResults.append(text)
        }
        XCTAssertEqual(enumeratedResults, ["<html>", "<head>", "<title>", "<body>"])
        
        
        let replacedHtml =
            """
            <<html>>
                <<head>>
                    <<title>>this is test</title>
                </head>
                <<body>>
                    <a href="https://itiger.com">itiger</a>
                </body>
            </html>
            """
        XCTAssertEqual(reg!.stringByReplacingMatches(in: html, withTemplate: "<$0>"), replacedHtml)
    }
}

//
//  DataTests.swift
//
//
//  Created by Jo on 2022/10/31.
//

import XCTest
import SwiftExtensions

final class NSStringTests: XCTestCase {
    func testExample() throws {
        let str = "hello world"
        
        XCTAssertEqual(str[6...10], "world")
        XCTAssertEqual(str[0...4], "hello")
        XCTAssertEqual(str[6..<11], "world")
        XCTAssertEqual(str[0..<5], "hello")
        XCTAssertEqual(str[...4], "hello")
        XCTAssertEqual(str[..<5], "hello")
        XCTAssertNil(str[..<12])
        XCTAssertEqual(str[..<11], str)
        XCTAssertEqual(str[10...], "d")
        XCTAssertNil(str[11...])
        XCTAssertEqual(str[6...], "world")
        
        let str2 = "abcabcabcabcabcabcabc"
        let ranges = str2.nsranges(of: "abc")
        print(ranges)
        
    }
}

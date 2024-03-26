//
//  StringTests.swift
//  
//
//  Created by Jo on 2024/2/1.
//

import XCTest

final class StringTests: XCTestCase {
    func testUnsafePointer() throws {
        let constKey = "com.itiger.testkey"
        
        XCTAssertNotNil(constKey.unsafePointer)
        
        XCTAssertEqual(constKey.unsafePointer, constKey.unsafePointer)
        
        XCTAssertNotNil("".unsafePointer)
    }
    
    func testRandomGenerate() throws {
        let range = 10..<20
        XCTAssertEqual(String.random(length: 10).count, 10)
        XCTAssertTrue(range.contains(String.random(length: range).count))
        XCTAssertTrue(range.contains(String.random(length: range, count: range).count))
    }
}

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
}

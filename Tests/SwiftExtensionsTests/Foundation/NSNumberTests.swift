//
//  NSNumberTests.swift
//  
//
//  Created by Jo on 2022/11/2.
//

import XCTest
import SwiftExtensions

final class NSNumberTests: XCTestCase {
    func testExample() throws {
        let num1 = NSNumber(value: 1)
        let num2 = NSNumber(value: 2)
        let num3 = NSNumber(value: 3)
        let num4 = NSNumber(value: 4)
        let num5 = NSNumber(value: 5)
        let num6 = NSNumber(value: 6)
        
        XCTAssertTrue(num1 < num2)
        XCTAssertTrue(num1 <= num2)
        XCTAssertTrue(num2 <= num2)
        XCTAssertTrue(num3 > num2)
        XCTAssertTrue(num3 >= num2)
        XCTAssertTrue(num3 >= num3)
        XCTAssertTrue(num3 == num3)
        XCTAssertTrue(num2 != num3)
        XCTAssertTrue(num3 == num2 + num1)
        XCTAssertTrue(num1 == num4 - num3)
        XCTAssertTrue(num6 == num2 * num3)
        XCTAssertTrue(num3 == num6 / num2)
        XCTAssertTrue(num5 % num2 == num1)
    }
}

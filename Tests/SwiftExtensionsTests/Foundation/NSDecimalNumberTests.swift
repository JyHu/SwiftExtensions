//
//  NSDecimalNumberTests.swift
//  
//
//  Created by Jo on 2022/11/2.
//

import XCTest
import SwiftExtensions

final class NSDecimalNumberTests: XCTestCase {

    func testExample() throws {
        let saftyEmptyNum = NSDecimalNumber(saftyString: nil)
        let saftyZeroNum = NSDecimalNumber(saftyString: "0")
        let zeroNum = NSDecimalNumber(floatLiteral: 0)
        
        XCTAssertEqual(NSDecimalNumber(string: nil), NSDecimalNumber.notANumber)
        XCTAssertNotEqual(saftyEmptyNum, NSDecimalNumber.notANumber)
        XCTAssertEqual(saftyEmptyNum, zeroNum)
        XCTAssertEqual(saftyZeroNum, zeroNum)
    }
    
    func testIncreaseDecrease() {
        let decimalNumber = NSDecimalNumber(string: "1234.123")
        let decimalValue = decimalNumber.decimalValue
        let exponent = decimalValue.exponent
        print(exponent)
    }
}


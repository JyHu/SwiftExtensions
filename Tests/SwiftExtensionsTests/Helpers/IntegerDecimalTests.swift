//
//  IntegerDecimalTests.swift
//
//
//  Created by Jo on 2023/12/19.
//

import XCTest
import SwiftExtensions

final class IntegerDecimalTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        let decimal = try IntegerDecimal(numberString: "-24.3546")
        let d2 = try IntegerDecimal(numberString: "00.23")
        let d3 = try IntegerDecimal(numberString: "0.000")
        let d4 = try IntegerDecimal(numberString: "0.2200")
        let d5 = try IntegerDecimal(numberString: "000.22")
        print("\(d2)")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

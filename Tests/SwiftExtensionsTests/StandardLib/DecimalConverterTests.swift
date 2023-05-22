//
//  DecimalConverterTests.swift
//  
//
//  Created by Jo on 2023/5/21.
//

import XCTest
import SwiftExtensions

final class DecimalConverterTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        print(try 0x9989afaf.convert(fromHex: 10, toHex: 62))
        print(try "afaaf".convert(fromHex: 16, toHex: 16))
        print(try "98789y987HJHYjhiuyo7yo78Y678687tigykjgut7tiyG7tUTGjkhghjkgfYTT67tuiygjkOYhiy8".convert(fromHex: 62, toHex: 10))
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

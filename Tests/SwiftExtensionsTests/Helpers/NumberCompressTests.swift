//
//  NumberCompressTests.swift
//  
//
//  Created by Jo on 2023/12/19.
//

import XCTest

final class NumberCompressTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        print(1000000.compress(using: .english))
        print(10008132894123510.01.compress(using: .english, decimals: 0))
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

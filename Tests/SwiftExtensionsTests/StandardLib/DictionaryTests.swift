//
//  DictionaryTests.swift
//  
//
//  Created by Jo on 2023/5/17.
//

import XCTest
import SwiftExtensions

final class DictionaryTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        let params: [String: Any] = [
            "a": "a",
            "b": [
                "1",
                "2"
            ],
            "c": [
                "d": "e",
                "f": "g",
                "h": [
                    "0",
                    "1",
                    "2"
                ],
                "j": [
                    "k": "l",
                    "m": "n"
                ]
            ]
        ]
        
        let res = params.toURLQuery()
        print(res)
        
        
        let dict0: [String: Any] = [
            "aa": "1",
            "ab": "2",
            "bc": "3",
            "bd": "4",
            "ee": "5",
            "eg": "6"
        ]
        
        let res0 = dict0.grouped { key, _ in
            return String(describing: key.first!)
        }
        print(res0)
        print("")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

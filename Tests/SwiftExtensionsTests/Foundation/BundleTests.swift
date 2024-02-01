//
//  BundleTests.swift
//  
//
//  Created by Jo on 2022/10/31.
//

import XCTest
import SwiftExtensions

final class BundleTests: XCTestCase {
    func testExample() throws {
        
        XCTAssertEqual(Bundle.main.identifier, "com.apple.dt.xctest.tool")
    }
}

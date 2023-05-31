//
//  FileManagerTests.swift
//  
//
//  Created by Jo on 2022/11/2.
//

import XCTest
import SwiftExtensions

final class FileManagerTests: XCTestCase {
    func testExample() throws {
        XCTAssertTrue(FileManager.documentDirectory?.hasSuffix("Documents") ?? false)
        XCTAssertTrue(FileManager.cacheDirectory?.hasSuffix("Caches") ?? false)
        XCTAssertTrue(FileManager.default.documentDirectory(with: "test")?.hasSuffix("Documents/test") ?? false)
        XCTAssertTrue(FileManager.default.cacheDirectory(with: "test")?.hasSuffix("Caches/test") ?? false)
    }
}

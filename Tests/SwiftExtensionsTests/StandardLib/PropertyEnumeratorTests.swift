//
//  File.swift
//  
//
//  Created by Jo on 2022/11/20.
//

import XCTest
import SwiftExtensions

final class PropertyEnumeratorTests: XCTestCase {
    private struct TestStruct: PropertyEnumerator {
        var name: String
        var age: Int
        var address: String?
    }

    private class TestClass: PropertyEnumerator {
        var name: String = ""
        var age: Int = 1
        var address: String?
        var st: TestStruct = TestStruct(name: "name", age: 24)
    }
    
    func testEnumerate() throws {
        print(try TestStruct(name: "aaa", age: 2).allProperties())
        print(try TestClass().allProperties())
        
        let model = TestStruct(name: "Bob", age: 2)
        let mirror = Mirror(reflecting: model)
    }
}

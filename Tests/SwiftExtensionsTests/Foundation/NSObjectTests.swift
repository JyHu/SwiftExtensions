//
//  NSObjectTests.swift
//  
//
//  Created by Jo on 2024/2/1.
//

import XCTest

final class NSObjectTests: XCTestCase {

    func testAssociations() throws {
        let key = "com.itiger.association.testkey"
        let value = "hello"
        let object = NSObject()
        object.setAssociatedObject(value, for: key, policy: .copyNonatomic)
        XCTAssertEqual(object.associatedObject(for: key), value)
        XCTAssertNotEqual(object.associatedObject(for: key), "world")
        
        let key2 = "com.itiger.assocation.testkey2"
        let value2 = NSObject()
        object.setAssociatedObject(value2, for: key2, policy: .retainNonatomic)
        XCTAssertEqual(object.associatedObject(for: key2), value2)
        XCTAssertNotEqual(object.associatedObject(for: key2), NSObject())
        
        let key3 = "com.itiger.association.testkey3"
        let value3 = 100
        object.setAssociatedObject(value3, for: key3, policy: .assign)
        XCTAssertEqual(object.associatedObject(for: key3), value3)
        XCTAssertNotEqual(object.associatedObject(for: key3), 99)
    }
    
    
    func testAssociationWeaks() throws {
        let key = "com.itiger.association.testKey"
        let object = NSObject()
        
        func testWeak() {
            let value = NSObject()
            object.setAssociatedWeakObject(value, for: key)
        }
        
        let associatedValue: NSObject? = object.associatedWeakObject(for: key)
        XCTAssertNil(associatedValue)
        
        let value = NSObject()
        object.setAssociatedWeakObject(value, for: key)
        XCTAssertEqual(object.associatedWeakObject(for: key), value)
    }
}

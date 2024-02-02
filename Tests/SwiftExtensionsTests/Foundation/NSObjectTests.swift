//
//  NSObjectTests.swift
//  
//
//  Created by Jo on 2024/2/1.
//

import XCTest

private extension NSObject.AssociationKey {
    static let key1 = NSObject.AssociationKey(rawValue: "com.itiger.association.testkey1")
    static let key2 = NSObject.AssociationKey(rawValue: "com.itiger.association.testkey2")
    static let key3 = NSObject.AssociationKey(rawValue: "com.itiger.association.testkey3")
}

final class NSObjectTests: XCTestCase {
    func testAssociations() throws {
        let value = "hello"
        let object = NSObject()
        object.setAssociatedObject(value, for: .key1, policy: .copyNonatomic)
        XCTAssertEqual(object.associatedObject(for: .key1), value)
        XCTAssertNotEqual(object.associatedObject(for: .key1), "world")
        
        let value2 = NSObject()
        object.setAssociatedObject(value2, for: .key2, policy: .retainNonatomic)
        XCTAssertEqual(object.associatedObject(for: .key2), value2)
        XCTAssertNotEqual(object.associatedObject(for: .key2), NSObject())
        
        let key3 = "com.itiger.association.testkey3"
        let value3 = 100
        object.setAssociatedObject(value3, for: .key3, policy: .assign)
        XCTAssertEqual(object.associatedObject(for: .key3), value3)
        XCTAssertNotEqual(object.associatedObject(for: .key3), 99)
    }
    
    func testAssociationWeaks() throws {
        let object = NSObject()
        
        func testWeak() {
            let value = NSObject()
            object.setAssociatedWeakObject(value, for: .key1)
        }
        
        let associatedValue: NSObject? = object.associatedWeakObject(for: .key1)
        XCTAssertNil(associatedValue)
        
        let value = NSObject()
        object.setAssociatedWeakObject(value, for: .key1)
        XCTAssertEqual(object.associatedWeakObject(for: .key1), value)
    }
}

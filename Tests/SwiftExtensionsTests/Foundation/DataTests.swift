//
//  DataTests.swift
//  
//
//  Created by Jo on 2022/10/31.
//

import XCTest
import SwiftExtensions

final class DataTests: XCTestCase {
    func testExample() throws {
        let stringData = "Hello world".data(using: .utf8)
        XCTAssertEqual(stringData?.bytes, [72, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100])
        
        let dictValue = ["key": "value"]
        
        
        let dataJson = try? (try? dictValue.toJsonData())?.toJsonObject() as? [String: String]
        XCTAssertEqual(dataJson, dictValue)
        
        let dataPlist = try? (try? dictValue.toPropertyListData())?.toPropertyList() as? [String: String]
        XCTAssertEqual(dataPlist, dictValue)
        
        
        let jsonString = "{\n  \"key\" : \"value\"\n}"
        XCTAssertEqual(dictValue.toJsonString(), jsonString)
        XCTAssertEqual(jsonString.jsonObject() as? [String: String], dictValue)
        
        let plistString = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">\n<plist version=\"1.0\">\n<dict>\n\t<key>key</key>\n\t<string>value</string>\n</dict>\n</plist>\n"
        XCTAssertEqual(dictValue.toPropertyListString(), plistString)
        XCTAssertEqual(plistString.propertyList() as? [String: String], dictValue)
    }
}

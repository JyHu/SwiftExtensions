//
//  URLTests.swift
//  
//
//  Created by Jo on 2022/11/2.
//

import XCTest
import SwiftExtensions

final class URLTests: XCTestCase {
    func testExample() throws {
        let tmpurl = URL(string: "https://www.itiger.com/user/login?username=joo&password=testpwd&type=login#redirect=home&tag=12")
        XCTAssertNotNil(tmpurl)
        
        let url = tmpurl!
        
        var queryParams = ["username": "joo", "password": "testpwd", "type": "login"]
        XCTAssertEqual(url.queryParams, queryParams)
        
        var fragments = ["redirect": "home", "tag": "12"]
        XCTAssertEqual(url.fragmentParams, fragments)
        
        fragments["token"] = "beartoken"
        XCTAssertEqual(url.resetFragment(with: fragments).fragmentParams, fragments)
        
        queryParams["type"] = "register"
        XCTAssertEqual(url.resetQuery(with: queryParams).queryParams, queryParams)
        
        queryParams["location"] = "cn"
        XCTAssertEqual(url.appendingQueryParameters(["location": "cn"]).queryParams?["location"], "cn")
    }
}

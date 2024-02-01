//
//  InputFormatterTests.swift
//  
//
//  Created by Jo on 2024/1/31.
//

import XCTest
@testable import SwiftExtensions

class InputFormatterTests: XCTestCase {
    func testMaxLengthFilter() {
        // 准备
        let formatter = InputFormatter(filter: .maxLength(5))
        let input = "123456"
        
        // 操作
        let result = formatter.isPartialStringValid(input, newEditingString: nil, errorDescription: nil)
        
        // 断言
        XCTAssertFalse(result, "输入超过最大长度应该被拒绝")
    }
    
    func testRegularExpressionFilter() {
        // 准备
        let formatter = InputFormatter(filter: .regularExpression("^[0-9]+$"))
        let validInput = "12345"
        let invalidInput = "abcde"
        
        // 操作
        let validResult = formatter.isPartialStringValid(validInput, newEditingString: nil, errorDescription: nil)
        let invalidResult = formatter.isPartialStringValid(invalidInput, newEditingString: nil, errorDescription: nil)
        
        // 断言
        XCTAssertTrue(validResult, "符合正则表达式的输入应该被接受")
        XCTAssertFalse(invalidResult, "不符合正则表达式的输入应该被拒绝")
    }
    
    func testValidatorFilter() {
        // 准备
        let validator: (String) -> Bool = { input in
            return input.contains("abc")
        }
        let formatter = InputFormatter(filter: .validater(validator))
        let validInput = "123abc456"
        let invalidInput = "123456789"
        
        // 操作
        let validResult = formatter.isPartialStringValid(validInput, newEditingString: nil, errorDescription: nil)
        let invalidResult = formatter.isPartialStringValid(invalidInput, newEditingString: nil, errorDescription: nil)
        
        // 断言
        XCTAssertTrue(validResult, "通过验证器的输入应该被接受")
        XCTAssertFalse(invalidResult, "未通过验证器的输入应该被拒绝")
    }
    
    // 其他测试用例根据具体情况添加
}

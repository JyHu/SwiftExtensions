//
//  MoneyTests.swift
//  
//
//  Created by Jo on 2023/6/1.
//

import XCTest
import SwiftExtensions

final class MoneyTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        
        let money1 = MoneyDecimal(integer: 32430904824, decimal: 3)
        XCTAssertEqual(try money1.amountInWords(.chinese(allowsZero: true)), "叁佰贰拾肆亿叁仟零玖拾万肆仟捌佰贰拾肆元零叁分")
        XCTAssertEqual(try money1.amountInWords(.chinese(allowsZero: false)), "叁佰贰拾肆亿叁仟零玖拾万肆仟捌佰贰拾肆元叁分")
        
        
        
        XCTAssertEqual(try money1.amountInWords(.english(style: .cents, spelling: .capitalized)), "Thirty-Two Billion, Four Hundred And Thirty Million, Nine Hundred And Four Thousand, Eight Hundred And Twenty-Four And Cents Three Only")
        XCTAssertEqual(try money1.amountInWords(.english(style: .cents, spelling: .caps)), "THIRTY-TWO BILLION, FOUR HUNDRED AND THIRTY MILLION, NINE HUNDRED AND FOUR THOUSAND, EIGHT HUNDRED AND TWENTY-FOUR AND CENTS THREE ONLY")
        XCTAssertEqual(try money1.amountInWords(.english(style: .percent, spelling: .capitalized)), "Thirty-Two Billion, Four Hundred And Thirty Million, Nine Hundred And Four Thousand, Eight Hundred And Twenty-Four And Three 3/100 Only")
        XCTAssertEqual(try money1.amountInWords(.english(style: .percent, spelling: .caps)), "THIRTY-TWO BILLION, FOUR HUNDRED AND THIRTY MILLION, NINE HUNDRED AND FOUR THOUSAND, EIGHT HUNDRED AND TWENTY-FOUR AND THREE 3/100 ONLY")
        XCTAssertEqual(try money1.amountInWords(.english(style: .point, spelling: .capitalized)), "Thirty-Two Billion, Four Hundred And Thirty Million, Nine Hundred And Four Thousand, Eight Hundred And Twenty-Four And Point Three Only")
        XCTAssertEqual(try money1.amountInWords(.english(style: .point, spelling: .caps)), "THIRTY-TWO BILLION, FOUR HUNDRED AND THIRTY MILLION, NINE HUNDRED AND FOUR THOUSAND, EIGHT HUNDRED AND TWENTY-FOUR AND POINT THREE ONLY")
        
        let money2 = try MoneyDecimal(money: 13600000001.06)
        
        XCTAssertEqual(try money2.amountInWords(.chinese(allowsZero: true)), "壹佰叁拾陆亿零陆分")
        XCTAssertEqual(try money2.amountInWords(.chinese(allowsZero: false)), "壹佰叁拾陆亿陆分")
        
        XCTAssertEqual(try money2.amountInWords(.english(style: .cents, spelling: .capitalized)), "Thirteen Billion, Six Hundred Million, One And Cents Six Only")
        XCTAssertEqual(try money2.amountInWords(.english(style: .cents, spelling: .caps)), "THIRTEEN BILLION, SIX HUNDRED MILLION, ONE AND CENTS SIX ONLY")
        XCTAssertEqual(try money2.amountInWords(.english(style: .percent, spelling: .capitalized)), "Thirteen Billion, Six Hundred Million, One And Six 6/100 Only")
        XCTAssertEqual(try money2.amountInWords(.english(style: .percent, spelling: .caps)), "THIRTEEN BILLION, SIX HUNDRED MILLION, ONE AND SIX 6/100 ONLY")
        XCTAssertEqual(try money2.amountInWords(.english(style: .point, spelling: .capitalized)), "Thirteen Billion, Six Hundred Million, One And Point Six Only")
        XCTAssertEqual(try money2.amountInWords(.english(style: .point, spelling: .caps)), "THIRTEEN BILLION, SIX HUNDRED MILLION, ONE AND POINT SIX ONLY")
        
//        print(try .amountInWords(.english(style: .cents, spelling: .capitalized)))
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

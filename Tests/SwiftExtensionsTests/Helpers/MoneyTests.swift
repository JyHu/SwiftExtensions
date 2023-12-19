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
        
        
        
        XCTAssertEqual(try money1.amountInWords(.english(style: .cents, spelling: .capitalized)), "Thirty-Two Billion, Four Hundred And Thirty Million, Nine Hundred And Four Thousand, Eight Hundred And Twenty-Four Dollars And Cents Three")
        XCTAssertEqual(try money1.amountInWords(.english(style: .cents, spelling: .caps)), "THIRTY-TWO BILLION, FOUR HUNDRED AND THIRTY MILLION, NINE HUNDRED AND FOUR THOUSAND, EIGHT HUNDRED AND TWENTY-FOUR DOLLARS AND CENTS THREE")
        XCTAssertEqual(try money1.amountInWords(.english(style: .percent, spelling: .capitalized)), "Thirty-Two Billion, Four Hundred And Thirty Million, Nine Hundred And Four Thousand, Eight Hundred And Twenty-Four Dollars And Three 3/100")
        XCTAssertEqual(try money1.amountInWords(.english(style: .percent, spelling: .caps)), "THIRTY-TWO BILLION, FOUR HUNDRED AND THIRTY MILLION, NINE HUNDRED AND FOUR THOUSAND, EIGHT HUNDRED AND TWENTY-FOUR DOLLARS AND THREE 3/100")
        XCTAssertEqual(try money1.amountInWords(.english(style: .point, spelling: .capitalized)), "Thirty-Two Billion, Four Hundred And Thirty Million, Nine Hundred And Four Thousand, Eight Hundred And Twenty-Four Dollars And Point Three")
        XCTAssertEqual(try money1.amountInWords(.english(style: .point, spelling: .caps)), "THIRTY-TWO BILLION, FOUR HUNDRED AND THIRTY MILLION, NINE HUNDRED AND FOUR THOUSAND, EIGHT HUNDRED AND TWENTY-FOUR DOLLARS AND POINT THREE")
        
        let money2 = try MoneyDecimal(money: 13600000001.06)
        
        XCTAssertEqual(try money2.amountInWords(.chinese(allowsZero: true)), "壹佰叁拾陆亿零陆分")
        XCTAssertEqual(try money2.amountInWords(.chinese(allowsZero: false)), "壹佰叁拾陆亿陆分")
        
        XCTAssertEqual(try money2.amountInWords(.english(style: .cents, spelling: .capitalized)), "Thirteen Billion, Six Hundred Million, One Dollars And Cents Six")
        XCTAssertEqual(try money2.amountInWords(.english(style: .cents, spelling: .caps)), "THIRTEEN BILLION, SIX HUNDRED MILLION, ONE DOLLARS AND CENTS SIX")
        XCTAssertEqual(try money2.amountInWords(.english(style: .percent, spelling: .capitalized)), "Thirteen Billion, Six Hundred Million, One Dollars And Six 6/100")
        XCTAssertEqual(try money2.amountInWords(.english(style: .percent, spelling: .caps)), "THIRTEEN BILLION, SIX HUNDRED MILLION, ONE DOLLARS AND SIX 6/100")
        XCTAssertEqual(try money2.amountInWords(.english(style: .point, spelling: .capitalized)), "Thirteen Billion, Six Hundred Million, One Dollars And Point Six")
        XCTAssertEqual(try money2.amountInWords(.english(style: .point, spelling: .caps)), "THIRTEEN BILLION, SIX HUNDRED MILLION, ONE DOLLARS AND POINT SIX")
        
//        print(try .amountInWords(.english(style: .cents, spelling: .capitalized)))
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

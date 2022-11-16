//
//  CalculatorTests.swift
//  WonderCalcTests
//
//  Created by Steven Schwedt on 11/14/22.
//

import XCTest
@testable import WonderCalc

final class CalculatorTests: XCTestCase {
    
    var calculator: Calculator!
    
    override func setUp() {
        calculator = Calculator()
    }
    
    func test_itCanAddNumbers() {
        calculator.numberTapped("2")
        calculator.operandTapped(.plus)
        calculator.numberTapped("2")
        calculator.operandTapped(.equal)
        
        XCTAssertEqual(calculator.publishedValue, "4")
        
        calculator.operandTapped(.clear)
        
        calculator.numberTapped("1")
        calculator.numberTapped("2")
        calculator.operandTapped(.plus)
        calculator.numberTapped("2")
        calculator.numberTapped("3")
        calculator.operandTapped(.equal)
        
        XCTAssertEqual(calculator.publishedValue, "35")
        
        calculator.operandTapped(.plus)
        calculator.numberTapped("2")
        calculator.operandTapped(.equal)
        
        XCTAssertEqual(calculator.publishedValue, "37")
        
        calculator.operandTapped(.plus)
        calculator.numberTapped("1")
        calculator.numberTapped(".")
        calculator.numberTapped("5")
        calculator.operandTapped(.equal)
        
        XCTAssertEqual(calculator.publishedValue, "38.5")
    }
    
    func test_itCanSubtractNumbers() {
        calculator.numberTapped("5")
        calculator.operandTapped(.minus)
        calculator.numberTapped("2")
        calculator.operandTapped(.equal)
        
        XCTAssertEqual(calculator.publishedValue, "3")
        
        calculator.operandTapped(.clear)
        
        calculator.numberTapped("1")
        calculator.numberTapped("2")
        calculator.operandTapped(.minus)
        calculator.numberTapped("2")
        calculator.numberTapped("3")
        calculator.operandTapped(.equal)
        
        XCTAssertEqual(calculator.publishedValue, "-11")
    }
    
    func test_itCanMultiplyNumbers() {
        calculator.numberTapped("5")
        calculator.operandTapped(.multiply)
        calculator.numberTapped("2")
        calculator.operandTapped(.equal)
        
        XCTAssertEqual(calculator.publishedValue, "10")
        
        calculator.operandTapped(.clear)
        
        calculator.numberTapped("1")
        calculator.numberTapped("2")
        calculator.operandTapped(.multiply)
        calculator.numberTapped("2")
        calculator.numberTapped("3")
        calculator.operandTapped(.equal)
        
        XCTAssertEqual(calculator.publishedValue, "276")
    }
    
    func test_itCanDivideNumbers() {
        calculator.numberTapped("6")
        calculator.operandTapped(.divide)
        calculator.numberTapped("2")
        calculator.operandTapped(.equal)
        
        XCTAssertEqual(calculator.publishedValue, "3")
        
        calculator.operandTapped(.clear)
        
        calculator.numberTapped("1")
        calculator.numberTapped("2")
        calculator.operandTapped(.divide)
        calculator.numberTapped("2")
        calculator.operandTapped(.equal)
        
        XCTAssertEqual(calculator.publishedValue, "6")
        
        calculator.operandTapped(.divide)
        calculator.numberTapped("4")
        calculator.operandTapped(.equal)
        
        XCTAssertEqual(calculator.publishedValue, "1.5")
    }
    
    func test_itCanMakeANumberNegative() {
        calculator.numberTapped("5")
        calculator.operandTapped(.negative)
        
        XCTAssertEqual(calculator.publishedValue, "-5")
        
        calculator.operandTapped(.negative)
        
        XCTAssertEqual(calculator.publishedValue, "5")
        
        calculator.operandTapped(.plus)
        calculator.numberTapped("3")
        calculator.operandTapped(.negative)
        calculator.operandTapped(.equal)
        
        XCTAssertEqual(calculator.publishedValue, "2")
    }
    
    func test_itCanSquareANumber() {
        calculator.numberTapped("5")
        calculator.operandTapped(.squared)
        
        XCTAssertEqual(calculator.publishedValue, "25")
        
        calculator.operandTapped(.squared)
        
        XCTAssertEqual(calculator.publishedValue, "625")
    }
}

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
        calculator.operandPressed(.plus)
        calculator.numberTapped("2")
        calculator.operandPressed(.equal)
        
        XCTAssertEqual(calculator.publishedValue, "4")
        
        calculator.operandPressed(.clear)
        
        calculator.numberTapped("1")
        calculator.numberTapped("2")
        calculator.operandPressed(.plus)
        calculator.numberTapped("2")
        calculator.numberTapped("3")
        calculator.operandPressed(.equal)
        
        XCTAssertEqual(calculator.publishedValue, "35")
    }
    
    func test_itCanSubtractNumbers() {
        calculator.numberTapped("5")
        calculator.operandPressed(.minus)
        calculator.numberTapped("2")
        calculator.operandPressed(.equal)
        
        XCTAssertEqual(calculator.publishedValue, "3")
        
        calculator.operandPressed(.clear)
        
        calculator.numberTapped("1")
        calculator.numberTapped("2")
        calculator.operandPressed(.minus)
        calculator.numberTapped("2")
        calculator.numberTapped("3")
        calculator.operandPressed(.equal)
        
        XCTAssertEqual(calculator.publishedValue, "-11")
    }
    
    func test_itCanMultiplyNumbers() {
        calculator.numberTapped("5")
        calculator.operandPressed(.multiply)
        calculator.numberTapped("2")
        calculator.operandPressed(.equal)
        
        XCTAssertEqual(calculator.publishedValue, "10")
        
        calculator.operandPressed(.clear)
        
        calculator.numberTapped("1")
        calculator.numberTapped("2")
        calculator.operandPressed(.multiply)
        calculator.numberTapped("2")
        calculator.numberTapped("3")
        calculator.operandPressed(.equal)
        
        XCTAssertEqual(calculator.publishedValue, "276")
    }
    
    func test_itCanDivideNumbers() {
        calculator.numberTapped("6")
        calculator.operandPressed(.divide)
        calculator.numberTapped("2")
        calculator.operandPressed(.equal)
        
        XCTAssertEqual(calculator.publishedValue, "3")
        
        calculator.operandPressed(.clear)
        
        calculator.numberTapped("1")
        calculator.numberTapped("2")
        calculator.operandPressed(.divide)
        calculator.numberTapped("2")
        calculator.operandPressed(.equal)
        
        XCTAssertEqual(calculator.publishedValue, "6")
    }
}

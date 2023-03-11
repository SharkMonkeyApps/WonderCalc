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
    var pasteBoard: PasteBoardable!
    
    override func setUp() {
        pasteBoard = MockPasteboard()
        calculator = Calculator(pasteBoard: pasteBoard)
    }

    func test_itCanDisplayAndClearNumbers() {
        XCTAssertEqual(calculator.publishedValue, "0")
        XCTAssertEqual(calculator.clearButtonText, "AC")

        calculator.buttonTapped(.five)
        XCTAssertEqual(calculator.publishedValue, "5")
        XCTAssertEqual(calculator.clearButtonText, "C")

        calculator.buttonTapped(.seven)
        XCTAssertEqual(calculator.publishedValue, "57")
        XCTAssertEqual(calculator.clearButtonText, "C")

        calculator.buttonTapped(.clear)
        XCTAssertEqual(calculator.publishedValue, "0")
        XCTAssertEqual(calculator.clearButtonText, "AC")

        calculator.buttonTapped(.two)
        XCTAssertEqual(calculator.publishedValue, "2")
        XCTAssertEqual(calculator.clearButtonText, "C")
    }

    func test_itDoesNotDisplayDoubleZero() {
        calculator.buttonTapped(.zero)
        XCTAssertEqual(calculator.publishedValue, "0")

        calculator.buttonTapped(.zero)
        calculator.buttonTapped(.zero)

        XCTAssertEqual(calculator.publishedValue, "0")
    }

    func test_itDoesNotDisplayDoubleDecimal() {
        calculator.buttonTapped(.decimal)
        XCTAssertEqual(calculator.publishedValue, "0.")

        calculator.buttonTapped(.zero)

        XCTAssertEqual(calculator.publishedValue, "0.0")

        calculator.buttonTapped(.decimal)

        XCTAssertEqual(calculator.publishedValue, "0.0")

        calculator.buttonTapped(.three)

        XCTAssertEqual(calculator.publishedValue, "0.03")

        calculator.buttonTapped(.decimal)
        calculator.buttonTapped(.five)

        XCTAssertEqual(calculator.publishedValue, "0.035")
    }

    func test_itCanDisplayCommas() {
        calculator.buttonTapped(.five)
        calculator.buttonTapped(.five)
        calculator.buttonTapped(.five)
        calculator.buttonTapped(.five)

        XCTAssertEqual(calculator.publishedValue, "5,555")

        calculator.buttonTapped(.five)

        XCTAssertEqual(calculator.publishedValue, "55,555")

        calculator.buttonTapped(.decimal)
        calculator.buttonTapped(.five)

        XCTAssertEqual(calculator.publishedValue, "55,555.5")
    }
    
    func test_itCanAddNumbers() {
        calculator.buttonTapped(.two)
        calculator.buttonTapped(.plus)
        calculator.buttonTapped(.two)
        calculator.buttonTapped(.equal)
        
        XCTAssertEqual(calculator.publishedValue, "4")
        
        clearAll()
        
        calculator.buttonTapped(.one)
        calculator.buttonTapped(.two)
        calculator.buttonTapped(.plus)
        calculator.buttonTapped(.two)
        calculator.buttonTapped(.three)
        calculator.buttonTapped(.equal)
        
        XCTAssertEqual(calculator.publishedValue, "35")
        
        calculator.buttonTapped(.plus)
        calculator.buttonTapped(.two)
        calculator.buttonTapped(.equal)
        
        XCTAssertEqual(calculator.publishedValue, "37")
        
        calculator.buttonTapped(.plus)
        calculator.buttonTapped(.one)
        calculator.buttonTapped(.decimal)
        calculator.buttonTapped(.five)
        calculator.buttonTapped(.equal)
        
        XCTAssertEqual(calculator.publishedValue, "38.5")
    }

    func test_itCanClearJustCurrentValue() {
        calculator.buttonTapped(.two)
        calculator.buttonTapped(.plus)
        calculator.buttonTapped(.two)

        XCTAssertEqual(calculator.publishedValue, "2")
        XCTAssertEqual(calculator.clearButtonText, "C")

        calculator.buttonTapped(.clear)

        XCTAssertEqual(calculator.publishedValue, "0")
        XCTAssertEqual(calculator.clearButtonText, "AC")

        calculator.buttonTapped(.two)
        calculator.buttonTapped(.equal)

        XCTAssertEqual(calculator.publishedValue, "4")
    }

    func test_itCanClearAll() {
        calculator.buttonTapped(.two)
        calculator.buttonTapped(.plus)
        calculator.buttonTapped(.two)

        calculator.buttonTapped(.clear)

        XCTAssertEqual(calculator.clearButtonText, "AC")

        calculator.buttonTapped(.clear)

        calculator.buttonTapped(.two)
        calculator.buttonTapped(.equal)

        XCTAssertEqual(calculator.publishedValue, "2")
    }
    
    func test_itCanSubtractNumbers() {
        calculator.buttonTapped(.five)
        calculator.buttonTapped(.minus)
        calculator.buttonTapped(.two)
        calculator.buttonTapped(.equal)
        
        XCTAssertEqual(calculator.publishedValue, "3")
        
        clearAll()
        
        calculator.buttonTapped(.one)
        calculator.buttonTapped(.two)
        calculator.buttonTapped(.minus)
        calculator.buttonTapped(.two)
        calculator.buttonTapped(.three)
        calculator.buttonTapped(.equal)
        
        XCTAssertEqual(calculator.publishedValue, "-11")
    }
    
    func test_itCanMultiplyNumbers() {
        calculator.buttonTapped(.five)
        calculator.buttonTapped(.multiply)
        calculator.buttonTapped(.two)
        calculator.buttonTapped(.equal)
        
        XCTAssertEqual(calculator.publishedValue, "10")
        
        clearAll()
        
        calculator.buttonTapped(.one)
        calculator.buttonTapped(.two)
        calculator.buttonTapped(.multiply)
        calculator.buttonTapped(.two)
        calculator.buttonTapped(.three)
        calculator.buttonTapped(.equal)
        
        XCTAssertEqual(calculator.publishedValue, "276")
    }
    
    func test_itCanDivideNumbers() {
        calculator.buttonTapped(.six)
        calculator.buttonTapped(.divide)
        calculator.buttonTapped(.two)
        calculator.buttonTapped(.equal)
        
        XCTAssertEqual(calculator.publishedValue, "3")
        
        clearAll()
        
        calculator.buttonTapped(.one)
        calculator.buttonTapped(.two)
        calculator.buttonTapped(.divide)
        calculator.buttonTapped(.two)
        calculator.buttonTapped(.equal)
        
        XCTAssertEqual(calculator.publishedValue, "6")
        
        calculator.buttonTapped(.divide)
        calculator.buttonTapped(.four)
        calculator.buttonTapped(.equal)
        
        XCTAssertEqual(calculator.publishedValue, "1.5")
    }

    func test_itHandlesDivideByZero() {
        calculator.buttonTapped(.five)
        calculator.buttonTapped(.divide)
        calculator.buttonTapped(.zero)
        calculator.buttonTapped(.equal)

        XCTAssertEqual(calculator.publishedValue, "Can't divide by zero")
    }
    
    func test_itCanMakeANumberNegative() {
        calculator.buttonTapped(.five)
        calculator.buttonTapped(.negative)
        
        XCTAssertEqual(calculator.publishedValue, "-5")
        
        calculator.buttonTapped(.negative)
        
        XCTAssertEqual(calculator.publishedValue, "5")
        
        calculator.buttonTapped(.plus)
        calculator.buttonTapped(.three)
        calculator.buttonTapped(.negative)
        calculator.buttonTapped(.equal)
        
        XCTAssertEqual(calculator.publishedValue, "2")
    }
    
    func test_itCanSquareANumber() {
        calculator.buttonTapped(.five)
        calculator.buttonTapped(.squared)
        
        XCTAssertEqual(calculator.publishedValue, "25")
        
        calculator.buttonTapped(.squared)
        
        XCTAssertEqual(calculator.publishedValue, "625")
    }

    func test_itCanMakeASquareNegative() {
        calculator.buttonTapped(.five)
        calculator.buttonTapped(.squared)

        XCTAssertEqual(calculator.publishedValue, "25")

        calculator.buttonTapped(.negative)

        XCTAssertEqual(calculator.publishedValue, "-25")
    }

    func test_itCanSquareRoot() {
        calculator.buttonTapped(.nine)
        calculator.buttonTapped(.squareRoot)

        XCTAssertEqual(calculator.publishedValue, "3")

        calculator.buttonTapped(.clear)

        calculator.buttonTapped(.six)
        calculator.buttonTapped(.seven)
        calculator.buttonTapped(.decimal)
        calculator.buttonTapped(.three)
        calculator.buttonTapped(.squareRoot)

        XCTAssertEqual(calculator.publishedValue, "8.203657720797473")
    }

    func test_itCanPercent() {
        calculator.buttonTapped(.six)
        calculator.buttonTapped(.percent)

        XCTAssertEqual(calculator.publishedValue, "0.06")

        calculator.buttonTapped(.clear)

        calculator.buttonTapped(.one)
        calculator.buttonTapped(.zero)
        calculator.buttonTapped(.zero)
        calculator.buttonTapped(.percent)

        XCTAssertEqual(calculator.publishedValue, "1")
    }

    func test_itCanMakeANumberNegativeAfterAnImmediatelyPerformedOperand() {
        calculator.buttonTapped(.nine)
        calculator.buttonTapped(.squareRoot)
        calculator.buttonTapped(.negative)

        XCTAssertEqual(calculator.publishedValue, "-3")

        calculator.buttonTapped(.clear)

        calculator.buttonTapped(.seven)
        calculator.buttonTapped(.squared)
        calculator.buttonTapped(.negative)

        XCTAssertEqual(calculator.publishedValue, "-49")

        calculator.buttonTapped(.clear)

        calculator.buttonTapped(.five)
        calculator.buttonTapped(.percent)
        calculator.buttonTapped(.negative)

        XCTAssertEqual(calculator.publishedValue, "-0.05")
    }

    func test_itCanPerformMultipleEquals() {
        calculator.buttonTapped(.two)
        calculator.buttonTapped(.plus)
        calculator.buttonTapped(.two)
        calculator.buttonTapped(.equal)

        XCTAssertEqual(calculator.publishedValue, "4")

        calculator.buttonTapped(.equal)

        XCTAssertEqual(calculator.publishedValue, "6")

        calculator.buttonTapped(.equal)

        XCTAssertEqual(calculator.publishedValue, "8")
    }

    func test_itResetsTypingAfterEqual() {
        calculator.buttonTapped(.two)
        calculator.buttonTapped(.plus)
        calculator.buttonTapped(.two)
        calculator.buttonTapped(.equal)

        XCTAssertEqual(calculator.publishedValue, "4")

        calculator.buttonTapped(.seven)

        XCTAssertEqual(calculator.publishedValue, "7")
    }

    func test_itResetsTypingAfterSquare() {
        calculator.buttonTapped(.nine)
        calculator.buttonTapped(.squared)

        XCTAssertEqual(calculator.publishedValue, "81")

        calculator.buttonTapped(.seven)

        XCTAssertEqual(calculator.publishedValue, "7")
    }


    func test_itCanSquareAfterOperator() {
        calculator.buttonTapped(.three)
        calculator.buttonTapped(.multiply)
        calculator.buttonTapped(.squared)

        XCTAssertEqual(calculator.publishedValue, "9")
    }

    func test_itCanPerformRepeatedExponent() {
        calculator.buttonTapped(.three)
        calculator.buttonTapped(.squared)

        XCTAssertEqual(calculator.publishedValue, "9")

        calculator.buttonTapped(.equal)

        XCTAssertEqual(calculator.publishedValue, "81")
    }

    func test_itCanHandleScientificNotation() {
        calculator.buttonTapped(.three)
        calculator.buttonTapped(.squared)
        calculator.buttonTapped(.squared)
        calculator.buttonTapped(.squared)
        calculator.buttonTapped(.squared)

        XCTAssertEqual(calculator.publishedValue, "43,046,721")

        calculator.buttonTapped(.squared)

        XCTAssertEqual(calculator.publishedValue, "1,853,020,188,851,841")

        calculator.buttonTapped(.squared)

        XCTAssertEqual(calculator.publishedValue, "3.433683820293e30")
    }

    func test_itCanHandleAnOverload() {
        calculator.buttonTapped(.three)
        calculator.buttonTapped(.squared)
        calculator.buttonTapped(.squared)
        calculator.buttonTapped(.squared)
        calculator.buttonTapped(.squared)
        calculator.buttonTapped(.squared)
        calculator.buttonTapped(.squared)
        calculator.buttonTapped(.squared)
        calculator.buttonTapped(.squared)
        calculator.buttonTapped(.squared)

        XCTAssertEqual(calculator.publishedValue, "1.93233498323e244")

        calculator.buttonTapped(.squared)

        XCTAssertEqual(calculator.publishedValue, "Too large to calculate")
    }

    func test_itFollowsTheOrderOfOperations() { // PEMDAS
        calculator.buttonTapped(.five)
        calculator.buttonTapped(.one)
        calculator.buttonTapped(.minus)
        calculator.buttonTapped(.three)
        calculator.buttonTapped(.decimal)
        calculator.buttonTapped(.four)
        calculator.buttonTapped(.divide)

        XCTAssertEqual(calculator.publishedValue, "3.4")

        calculator.buttonTapped(.three)
        calculator.buttonTapped(.negative)

        XCTAssertEqual(calculator.publishedValue, "-3")

        calculator.buttonTapped(.squared)

        XCTAssertEqual(calculator.publishedValue, "9")

        calculator.buttonTapped(.plus)

        XCTAssertEqual(calculator.publishedValue, "50.62222222222222")

        calculator.buttonTapped(.eight)
        calculator.buttonTapped(.multiply)
        calculator.buttonTapped(.two)
        calculator.buttonTapped(.squareRoot)
        calculator.buttonTapped(.plus)

        XCTAssertEqual(calculator.publishedValue, "61.93593072120698")

        calculator.buttonTapped(.seven)
        calculator.buttonTapped(.two)
        calculator.buttonTapped(.equal)

        XCTAssertEqual(calculator.publishedValue, "133.93593072120697")
    }

    func test_itCanCut() {
        calculator.buttonTapped(.five)
        calculator.buttonTapped(.cut)

        XCTAssertEqual(calculator.publishedValue, "0")
        XCTAssertEqual(pasteBoard.paste(), "5")
    }

    func test_itCanCopy() {
        calculator.buttonTapped(.five)
        calculator.buttonTapped(.copy)

        XCTAssertEqual(calculator.publishedValue, "5")
        XCTAssertEqual(pasteBoard.paste(), "5")
    }

    func testItCanPaste() {
        calculator.buttonTapped(.five)
        calculator.buttonTapped(.cut)
        calculator.buttonTapped(.paste)

        XCTAssertEqual(calculator.publishedValue, "5")

        clearAll()

        calculator.buttonTapped(.seven)
        calculator.buttonTapped(.plus)
        calculator.buttonTapped(.paste)

        XCTAssertEqual(calculator.publishedValue, "5")

        calculator.buttonTapped(.equal)

        XCTAssertEqual(calculator.publishedValue, "12")
    }

    // MARK: - Helpers

    private func clearAll() {
        calculator.buttonTapped(.clear)
        calculator.buttonTapped(.clear)
    }
}

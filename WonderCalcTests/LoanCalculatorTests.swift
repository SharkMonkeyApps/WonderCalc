//
//  LoanCalculatorTests.swift
//  WonderCalcTests
//
//  Created by Steven Schwedt on 2/11/23.
//

import XCTest
@testable import WonderCalc

final class LoanCalculatorTests: XCTestCase {
    
    var loanCalculator: LoanCalculator!
    
    override func setUp() {
        loanCalculator = LoanCalculator()
    }
    
    func test_itCanCalculateAPayment() {
        loanCalculator.amount = "100000"
        loanCalculator.years = "10"
        loanCalculator.rate = "6"
        
        XCTAssertEqual(loanCalculator.payments.monthly, "$1,110.21")
        XCTAssertEqual(loanCalculator.payments.total, "$133,224.60")
        XCTAssertEqual(loanCalculator.payments.interest, "$33,224.60")
    }

    func test_itCanCalculateAnAmount() {
        loanCalculator.amountToPayment = false
        loanCalculator.monthlyPayment = "2000"
        loanCalculator.years = "30"
        loanCalculator.rate = "10"

        XCTAssertEqual(loanCalculator.amountResult, "$227,901.64")
    }
}

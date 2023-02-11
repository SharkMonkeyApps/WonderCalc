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
    
    func test_itCanCalculateALoan() {
        loanCalculator.amount = "100000"
        loanCalculator.years = "10"
        loanCalculator.rate = "6"
        
        loanCalculator.payments.monthly = "$1,110.21"
        loanCalculator.payments.total = "$133,224.60"
    }
}

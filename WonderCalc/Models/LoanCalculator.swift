//
//  LoanCalculator.swift
//  WonderCalc
//
//  Created by Steven Schwedt on 11/17/22.
//

import Foundation
import Combine

class LoanCalculator: ObservableObject {
    typealias Payments = (monthly: String, total: String)
    
    @Published var amount: String = ""
    @Published var years: String = ""
    @Published var rate: String = ""
    
    @Published var payments: Payments = ("0", "0")
    
    init() {
        Publishers.CombineLatest3($amount, $years, $rate)
            .map { _ in self.calculatedPaymemnt }
            .assign(to: &$payments)
    }
    
    private var calculatedPaymemnt: Payments {
        guard let years = Double(years),
              let amount = Double(amount),
              let rate = Double(rate)
        else { return ("", "") }
        
        let numberOfMonths = years * 12
        let monthlyRate = ((rate / 100) / 12)
        let topPartOfformula = monthlyRate * (pow((monthlyRate + 1), numberOfMonths))
        let bottomPartOfFormula = pow((monthlyRate + 1), numberOfMonths) - 1
        
        let monthlyPaymentValue: Double = amount * topPartOfformula / bottomPartOfFormula
        let totalPaymentValue = monthlyPaymentValue * numberOfMonths
        let monthlyPayment = NumberFormatter.currencyString(monthlyPaymentValue)
        let totalPayment = NumberFormatter.currencyString(totalPaymentValue)
        
        return (monthlyPayment, totalPayment)
    }
}

//
//  LoanCalculator.swift
//  WonderCalc
//
//  Created by Steven Schwedt on 11/17/22.
//

import Foundation
import Combine

class LoanCalculator: ObservableObject {
    fileprivate typealias InputValues = (amount: String, years: String, rate: String)
    typealias Payments = (monthly: String, total: String, interest: String)
    
    @Published var amount: String = ""
    @Published var years: String = ""
    @Published var rate: String = ""
    
    @Published var payments: Payments = ("", "", "")
    
    init() {
        Publishers.CombineLatest3($amount, $years, $rate)
            .map { values in self.calculatedPaymemnt(values) }
            .assign(to: &$payments)
    }
    
    private func calculatedPaymemnt(_ values: InputValues) -> Payments {
        guard let years = Double(values.years),
              let amount = Double(values.amount),
              let rate = Double(values.rate)
        else { return ("", "", "") }
        
        let numberOfMonths = years * 12
        let monthlyRate = ((rate / 100) / 12)
        let topPartOfformula = monthlyRate * (pow((monthlyRate + 1), numberOfMonths))
        let bottomPartOfFormula = pow((monthlyRate + 1), numberOfMonths) - 1
        
        let monthlyPaymentValue: Double = amount * topPartOfformula / bottomPartOfFormula
        let totalPaymentValue = monthlyPaymentValue * numberOfMonths
        let monthlyPayment = NumberFormatter.currencyString(monthlyPaymentValue)
        let totalPayment = NumberFormatter.currencyString(totalPaymentValue)
        let interest = NumberFormatter.currencyString(totalPaymentValue - amount)
        print(monthlyPayment + totalPayment)
        
        return (monthlyPayment, totalPayment, interest)
    }
}

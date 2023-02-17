//
//  LoanCalculator.swift
//  WonderCalc
//
//  Created by Steven Schwedt on 11/17/22.
//

import Foundation
import Combine

class LoanCalculator: ObservableObject {
    fileprivate typealias InputValues = (amount: String, years: String, months: String, rate: String)
    typealias Payments = (monthly: String, total: String, interest: String)
    
    @Published var amount: String = ""
    @Published var years: String = ""
    @Published var months: String = ""
    @Published var rate: String = ""
    
    @Published var payments: Payments = ("", "", "")
    
    init() {
        Publishers.CombineLatest4($amount, $years, $months, $rate)
            .map { values in self.calculatedPaymemnt(values) }
            .assign(to: &$payments)
    }
    
    private func calculatedPaymemnt(_ values: InputValues) -> Payments {
        let numberOfMonths = (Double(values.years) ?? 0) * 12 + (Double(values.months) ?? 0)
        guard numberOfMonths > 0,
              let amount = Double(values.amount),
              let rate = Double(values.rate)
        else { return ("", "", "") }

        let monthlyRate = ((rate / 100) / 12)
        let topPartOfformula = monthlyRate * (pow((monthlyRate + 1), numberOfMonths))
        let bottomPartOfFormula = pow((monthlyRate + 1), numberOfMonths) - 1
        
        let monthlyPaymentValue: Double = amount * topPartOfformula / bottomPartOfFormula
        let totalPaymentValue = monthlyPaymentValue * numberOfMonths
        let monthlyPayment = NumberFormatter.currencyString(monthlyPaymentValue)
        let totalPayment = NumberFormatter.currencyString(totalPaymentValue)
        let interest = NumberFormatter.currencyString(totalPaymentValue - amount)
        
        return (monthlyPayment, totalPayment, interest)
    }
}

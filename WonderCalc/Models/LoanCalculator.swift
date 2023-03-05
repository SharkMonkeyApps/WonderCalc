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
    fileprivate typealias PaymentInputValues = (payment: String, years: String, months: String, rate: String)
    typealias Payments = (monthly: String, total: String, interest: String)
    
    @Published var amount: String = ""
    @Published var years: String = ""
    @Published var months: String = ""
    @Published var rate: String = ""

    @Published var amountToPayment = true
    
    @Published var payments: Payments = ("", "", "")

    @Published var monthlyPayment: String = "" // Used as input only
    @Published var amountResult: String = ""

    private var subscribers: Set<AnyCancellable> = []
    
    init() {
        Publishers.CombineLatest4($amount, $years, $months, $rate)
            .map { values in self.calculatedPaymemnt(values) }
            .assign(to: &$payments)

        Publishers.CombineLatest4($monthlyPayment, $years, $months, $rate)
            .map { values in self.calculateAmount(values) }
            .sink { value in
                let stringValue = value as String

                if self.amountToPayment == false {
                    self.amountResult = stringValue
                    self.amount = stringValue
                        .replacingOccurrences(of: "$", with: "")
                        .replacingOccurrences(of: ",", with: "")
                }
            }
            .store(in: &subscribers)
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

    private func calculateAmount(_ values: PaymentInputValues) -> String {
        let numberOfMonths = (Double(values.years) ?? 0) * 12 + (Double(values.months) ?? 0)
        guard numberOfMonths > 0,
              let payment = Double(values.payment),
              let rate = Double(values.rate)
        else { return "" }

        let monthlyRate = ((rate / 100) / 12)
        let topPartOfformula = (pow((monthlyRate + 1), numberOfMonths)) - 1
        let bottomPartOfFormula = monthlyRate * pow((monthlyRate + 1), numberOfMonths)
        let amountValue = payment * topPartOfformula / bottomPartOfFormula
        let amount = NumberFormatter.currencyString(amountValue)

        return amount

    }
}

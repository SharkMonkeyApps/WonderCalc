//
//  LoanView.swift
//  WonderCalc
//
//  Created by Steven Schwedt on 11/17/22.
//

import SwiftUI

struct LoanView: View {
    
    @ObservedObject var loanCalc: LoanCalculator
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Amount")
                TextField("", text: $loanCalc.amount)
                    .keyboardType(.decimalPad)
                Text("Term (years)")
                TextField("", text: $loanCalc.years)
                    .keyboardType(.numberPad)
                Text("Interest rate (%)")
                TextField("", text: $loanCalc.rate)
                    .keyboardType(.decimalPad)
                Text("Monthly Payment")
                Text(loanCalc.payments.monthly)
                Text("Total Paid")
                Text(loanCalc.payments.total)
            }
        }
    }
}

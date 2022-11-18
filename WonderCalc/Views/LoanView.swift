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
                    .padding()
                    .border(.foreground)
                Text("Term (years)")
                TextField("", text: $loanCalc.years)
                    .keyboardType(.numberPad)
                    .padding()
                    .border(.foreground)
                Text("Interest rate (%)")
                TextField("", text: $loanCalc.rate)
                    .keyboardType(.decimalPad)
                    .padding()
                    .border(.foreground)
                Text("Monthly Payment")
                Text(loanCalc.payments.monthly)
                Text("Total Paid")
                Text(loanCalc.payments.total)
            }
            .padding()
            .navigationTitle("Loan Calculator")
        }
    }
}

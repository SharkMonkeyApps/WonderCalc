//
//  LoanView.swift
//  WonderCalc
//
//  Created by Steven Schwedt on 11/17/22.
//

import SwiftUI

struct LoanView: View {
    
    @ObservedObject var loanCalc: LoanCalculator
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var body: some View {
        NavigationView {
            VStack {
                TextFieldRow(input: $loanCalc.amount, title: "Amount:", placeHolder: "0", keyboardType: .decimalPad)
                    .padding(.bottomPad)

                HStack {
                    Text("- Term - ")
                        .font(.subHeading)
                    Spacer()
                }
                
                TextFieldRow(input: $loanCalc.years, title: "    Years:", placeHolder: "0", keyboardType: .numberPad)

                TextFieldRow(input: $loanCalc.months, title: "    Months:", placeHolder: "0", keyboardType: .numberPad)
                    .padding(.bottomPad)
                
                TextFieldRow(input: $loanCalc.rate, title: "Interest Rate (%):", placeHolder: "0", keyboardType: .decimalPad)
                
                Spacer()
                
                resultsView
                
                Spacer()
            }
            .padding(horizontalSizeClass == .regular ? .wide : .standard)
            .navigationTitle("Loan Calculator")
        }
        .dismissKeyboardOnTap()
        .navigationViewStyle(StackNavigationViewStyle())
    }

    var resultsView: some View {
        VStack {
            Text("Monthly Payment: \(loanCalc.payments.monthly)")
                .font(.subHeading)
            Text("Total Paid: \(loanCalc.payments.total)")
                .font(.subHeading)
            Text("Total Interest: \(loanCalc.payments.interest)")
                .font(.subHeading)
                .padding(.bottomPad)
            Button("Clear") {
                loanCalc.amount = ""
                loanCalc.years = ""
                loanCalc.rate = ""
            }
            .font(.subHeading)
            .disabled(loanCalc.payments.monthly == "")
        }
    }
}

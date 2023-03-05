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
    let config: AppConfig
    
    var body: some View {
        NavigationView {
            VStack {
                TextFieldRow(input: $loanCalc.amount, title: "Amount:", placeHolder: "0", keyboardType: .decimalPad)
                    .padding(.bottom)

                HStack {
                    Text("- Term -")
                        .font(.subHeading)
                    Spacer()
                }
                
                TextFieldRow(input: $loanCalc.years, title: "    Years:", placeHolder: "0", keyboardType: .numberPad)

                TextFieldRow(input: $loanCalc.months, title: "    Months:", placeHolder: "0", keyboardType: .numberPad)
                    .padding(.bottomPad)
                
                TextFieldRow(input: $loanCalc.rate, title: "Interest Rate (%):", placeHolder: "0", keyboardType: .decimalPad)
                    .padding(.bottomPad)
                
                resultsView
                
                Spacer()
            }
            .padding(horizontalSizeClass == .regular ? .wide : .standard)
            .navigationTitle("Loan Calculator")
        }
        .dismissKeyboardOnTap()
        .navigationViewStyle(StackNavigationViewStyle())
    }

    // MARK: - Private

    var resultsView: some View {
        VStack {
            HStack(alignment: .center) {
                Text("Monthly Payment: \(loanCalc.payments.monthly)")
                    .font(.subHeading)
                copyButton(loanCalc.payments.monthly)
            }
            HStack(alignment: .center) {
                Text("Total Paid: \(loanCalc.payments.total)")
                    .font(.subHeading)
                copyButton(loanCalc.payments.total)
            }
            HStack(alignment: .center) {
                Text("Total Interest: \(loanCalc.payments.interest)")
                    .font(.subHeading)
                copyButton(loanCalc.payments.interest)
            }
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


    private func copyButton(_ value: String) -> some View {
        Button(action: { copyResults(value) }) {
            Text(Image(systemName: "doc.on.doc"))
                .font(.body)
                .foregroundColor(.white)
                .background(Capsule()
                    .fill(value == "" ? .gray : .blue)
                    .frame(width: 44, height: 44))
                .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 8))
        }
        .disabled(value == "")
    }

    private func copyResults(_ result: String) {
        if let number = NumberFormatter.currencyNumber(from: result) {
            config.pasteboard.copy("\(number)")
        }
    }
}

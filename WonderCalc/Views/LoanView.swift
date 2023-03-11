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
    @FocusState private var keyboardVisible: Bool
    let pasteBoard: PasteBoardable
    let config: AppConfig
    
    var body: some View {
        NavigationView {
            VStack {
                firstFieldRow

                HStack {
                    Text("- Term -")
                        .font(.subHeading)
                    Spacer()
                }
                
                TextFieldRow(input: $loanCalc.years, title: "    Years:", placeHolder: "0", keyboardType: .numberPad)
                    .focused($keyboardVisible)

                TextFieldRow(input: $loanCalc.months, title: "    Months:", placeHolder: "0", keyboardType: .numberPad)
                    .padding(.bottomPad)
                    .focused($keyboardVisible)

                TextFieldRow(input: $loanCalc.rate, title: "Interest Rate (%):", placeHolder: "0", keyboardType: .decimalPad)
                    .padding(.bottomPad)
                    .focused($keyboardVisible)

                swapButton
                resultsView

                keyboardVisible ? nil : clearButton
                keyboardVisible ? nil : Spacer()
            }
            .padding(horizontalSizeClass == .regular ? .wide : .standard)
            .navigationTitle("Loan Calculator")
            .navigationBarHidden(shouldHideToolbar || keyboardVisible)
        }
        .dismissKeyboardOnTap()
        .navigationViewStyle(StackNavigationViewStyle())
    }

    // MARK: - Private

    private var firstFieldRow: some View {
        if loanCalc.amountToPayment {
            return TextFieldRow(input: $loanCalc.amount, title: "Amount:", placeHolder: "0", keyboardType: .decimalPad)
                .padding(.bottom)
                .focused($keyboardVisible)
        } else {
            return TextFieldRow(input: $loanCalc.monthlyPayment, title: "Payment:", placeHolder: "0", keyboardType: .decimalPad)
                .padding(.bottom)
                .focused($keyboardVisible)
        }
    }

    private var resultsView: some View {
        if loanCalc.amountToPayment {
            return AnyView(paymentResultsView)
        } else {
            return AnyView(amountResultView)
        }
    }

    private var paymentResultsView: some View {
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
        }
    }

    private var amountResultView: some View {
        HStack(alignment: .center) {
            Text("Amount: \(loanCalc.amountResult)")
                .font(.subHeading)
            copyButton(loanCalc.amount)
        }
    }

    private var swapButton: some View {
        Button(action: swapLoan) {
            Text(Image(systemName: "rectangle.2.swap"))
                .font(.subHeading)
                .foregroundColor(.white)
                .padding()
                .background(Capsule()
                    .fill(.indigo)
                    .frame(height: 56))
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

    private var clearButton: some View {
        Button("Clear") {
            loanCalc.amount = ""
            loanCalc.years = ""
            loanCalc.rate = ""
            loanCalc.monthlyPayment = ""
            loanCalc.amountResult = ""
        }
        .font(.subHeading)
        .disabled(loanCalc.payments.monthly == "")
    }

    private func copyResults(_ result: String) {
        if let number = NumberFormatter.currencyNumber(from: result) {
            config.pasteboard.copy("\(number)")
        }
    }

    private func swapLoan() {
        loanCalc.amountToPayment.toggle()
    }

    private let shouldHideToolbar = UIScreen.main.bounds.size.height < 800
}

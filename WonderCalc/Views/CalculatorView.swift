//
//  ContentView.swift
//  WonderCalc
//
//  Created by Steven Schwedt on 11/14/22.
//

import SwiftUI

struct CalculatorView: View {
    
    @ObservedObject var calculator: Calculator
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Spacer()
                    Text("\(calculator.publishedValue)")
                        .font(.heading)
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.gray, lineWidth: 1)
                )

                LazyVGrid(columns: layout) {
                    button(.clear)
                    button(.cut)
                    button(.copy)
                    button(.paste)
                }
                
                LazyVGrid(columns: layout) {
                    button(.negative)
                    button(.percent)
                    button(.squareRoot)
                    button(.squared)
                }
                LazyVGrid(columns: layout) {
                    button(.seven)
                    button(.eight)
                    button(.nine)
                    button(.divide)
                }
                LazyVGrid(columns: layout) {
                    button(.four)
                    button(.five)
                    button(.six)
                    button(.multiply)
                }
                LazyVGrid(columns: layout) {
                    button(.one)
                    button(.two)
                    button(.three)
                    button(.minus)
                }
                LazyVGrid(columns: layout) {
                    button(.zero)
                    button(.decimal)
                    button(.equal)
                    button(.plus)
                }
            }
            .padding()
            .navigationTitle("WonderCalc")
            // TODO: - Support history + editing
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    NavigationLink("History") {
//                        CalculationsListView(calculator: calculator)
//                    }
//                }
//            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    // MARK: - Private
    
    private let layout = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    private func button(_ option: CalculatorButtonOption) -> CalculatorButton {
        CalculatorButton(option: option, callback: calculator.buttonTapped)
    }
    
//    private func numberButton(_ number: Int) -> NumberButton {
//        numberButton("\(number)")
//    }
//
//    private func numberButton(_ char: String) -> NumberButton {
//        NumberButton(value: char, callback: calculator.numberTapped)
//    }
//
//    private func operatorButton(_ operand: Operand) -> OperandButton {
//        OperandButton(operand: operand, callback: calculator.operandTapped)
//    }
//
//    private func pasteboardButton(_ option: PasteboardOption) -> PasteboardButton {
//        PasteboardButton(option: option, callback: calculator.pasteboardTapped)
//    }
}

struct CalcView_Previews: PreviewProvider {
    static var previews: some View {
        CalculatorView(calculator: Calculator())
    }
}

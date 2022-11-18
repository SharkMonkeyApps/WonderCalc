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
                Text("\(calculator.publishedValue)")
                    .font(.system(size: 28, weight: .semibold))
                
                LazyVGrid(columns: layout) {
                    operatorButton(.clear)
                    operatorButton(.negative)
                    operatorButton(.percent)
                    operatorButton(.squared)
                }
                LazyVGrid(columns: layout) {
                    numberButton(7)
                    numberButton(8)
                    numberButton(9)
                    operatorButton(.plus)
                }
                LazyVGrid(columns: layout) {
                    numberButton(4)
                    numberButton(5)
                    numberButton(6)
                    operatorButton(.minus)
                }
                LazyVGrid(columns: layout) {
                    numberButton(1)
                    numberButton(2)
                    numberButton(3)
                    operatorButton(.multiply)
                }
                LazyVGrid(columns: layout) {
                    numberButton(0)
                    numberButton(".")
                    operatorButton(.equal)
                    operatorButton(.divide)
                }
            }
            .padding()
            .navigationTitle("WonderCalc")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink("Calculations") {
                        CalculationsListView(calculator: calculator)
                    }
                }
            }
        }
    }
    
    // MARK: - Private
    
    private let layout = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    private func numberButton(_ number: Int) -> NumberButton {
        numberButton("\(number)")
    }
    
    private func numberButton(_ char: String) -> NumberButton {
        NumberButton(value: char, callback: calculator.numberTapped)
    }
    
    private func operatorButton(_ operand: Operand) -> OperandButton {
        OperandButton(operand: operand, callback: calculator.operandTapped)
    }
}

struct CalcView_Previews: PreviewProvider {
    static var previews: some View {
        CalculatorView(calculator: Calculator())
    }
}
